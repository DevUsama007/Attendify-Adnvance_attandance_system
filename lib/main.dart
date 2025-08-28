import 'package:attendify/app/data/embadingrepo.dart';
import 'package:attendify/app/res/routes/routes.dart';
import 'package:attendify/app/view/userPanelScreens/userSplashScreen.dart';
import 'package:attendify/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'app/services/facerecoginition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Attendify());
}

class Attendify extends StatelessWidget {
  const Attendify({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Face Embedding Demo',
      debugShowCheckedModeBanner: false,
      getPages: ApprRoutes.appRoutes(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserSplashScreen(),
    );
  }
}

class FaceEmbeddingScreen extends StatefulWidget {
  const FaceEmbeddingScreen({super.key});

  @override
  _FaceEmbeddingScreenState createState() => _FaceEmbeddingScreenState();
}

class _FaceEmbeddingScreenState extends State<FaceEmbeddingScreen> {
  final FaceEmbeddingExtractor _embeddingExtractor = FaceEmbeddingExtractor();
  Embadingrepo _embadingrepo = Embadingrepo();
  File? _selectedImage;
  List<double>? _embedding;
  bool _isLoading = false;
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    setState(() => _isLoading = true);
    try {
      await _embeddingExtractor.loadModel();
      setState(() => _modelLoaded = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load model: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model not loaded yet')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _embedding = null;
        _isLoading = true;
      });
      print(pickedFile.path.toString());
      try {
        final embedding =
            await _embeddingExtractor.extractEmbedding(_selectedImage!);
        await _embadingrepo.uploadFaceEmbedding(
          username: 'usama',
          embedding: embedding,
          name: 'Usama Basharat',
        );
        setState(() => _embedding = embedding);
      } catch (e) {
        print("Error processing image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImageAndCompare(ImageSource source) async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model not loaded yet')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _embedding = null;
        _isLoading = true;
      });
      print(pickedFile.path.toString());
      try {
        final embedding =
            await _embeddingExtractor.extractEmbedding(_selectedImage!);

        final double? similarity =
            await compareWithStoredFace(newImageFile: File(pickedFile.path));
        print(
            'the value of the comparison is $similarity========================================');
        if (similarity != null && similarity > 0.7) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Face matched with similarity: ${similarity.toStringAsFixed(4)}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Face did not match')),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('value of similarity ${similarity.toString()}')),
        );
        setState(() => _embedding = embedding);
      } catch (e) {
        print("Error processing image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<double?> compareWithStoredFace({
    required File newImageFile,
  }) async {
    try {
      // 1. Get stored embedding
      final storedEmbedding = await _embadingrepo.getFaceEmbedding('usama');
      if (storedEmbedding == null) {
        print('No stored face found for usama');
        return null;
      }

      // 2. Extract new embedding
      final newEmbedding =
          await _embeddingExtractor.extractEmbedding(newImageFile);

      // 3. Compare
      return _embeddingExtractor.compareEmbeddings(
          storedEmbedding, newEmbedding);
    } catch (e) {
      print('Error in face comparison: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Embedding Extractor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (!_modelLoaded)
              const Center(child: Text('Loading model...'))
            else
              _buildImageSection(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            if (_embedding != null) ...[
              const SizedBox(height: 20),
              _buildEmbeddingVisualization(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              _pickImageAndCompare(ImageSource.camera);
            },
            child: Text('Compare Image')),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _selectedImage != null
              ? Image.file(_selectedImage!, fit: BoxFit.cover)
              : const SizedBox(
                  height: 200,
                  child: Center(child: Text('No image selected')),
                ),
        ),
        if (_selectedImage != null && _embedding != null) ...[
          const SizedBox(height: 10),
          Text(
            'Embedding extracted (${_embedding!.length} dimensions)',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text('Camera'),
          onPressed: () => _pickImage(ImageSource.camera),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.photo_library),
          label: const Text('Gallery'),
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildEmbeddingVisualization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Embedding Vector:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _embedding!.map((value) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 4,
                  height: (value * 30).abs(), // Scale for visualization
                  color: value > 0 ? Colors.blue : Colors.red,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'First 10 values:',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          _embedding!
              .sublist(0, 10)
              .map((v) => v.toStringAsFixed(4))
              .join(', '),
        ),
      ],
    );
  }
}
