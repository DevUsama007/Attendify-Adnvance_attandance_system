import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceEmbeddingExtractor {
  late Interpreter _interpreter;
  late int _embeddingSize; // Will be determined dynamically

  Future<void> loadModel() async {
    _interpreter =
        await Interpreter.fromAsset('assets/models/mobilefacenet.tflite');

    // Properly inspect input and output tensors
    final inputTensors = _interpreter.getInputTensors();
    final outputTensors = _interpreter.getOutputTensors();

    print('Input details: $inputTensors');
    print('Output details: $outputTensors');

    // Set embedding size based on actual model output
    _embeddingSize = outputTensors[0].shape[1];
    print('Determined embedding size: $_embeddingSize');
  }

  Future<List<double>> extractEmbedding(File imageFile) async {
    // 1. Decode and resize
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) throw Exception("Cannot decode image");

    img.Image resized = img.copyResize(image, width: 112, height: 112);

    // 2. Prepare input [1,112,112,3] normalized [-1,1]
    var input = List.generate(
      1,
      (_) => List.generate(
        112,
        (y) => List.generate(
          112,
          (x) {
            final pixel = resized.getPixel(x, y);
            final r = ((pixel.r / 255.0) - 0.5) / 0.5;
            final g = ((pixel.g / 255.0) - 0.5) / 0.5;
            final b = ((pixel.b / 255.0) - 0.5) / 0.5;
            return [r, g, b];
          },
        ),
      ),
    );

    // 3. Prepare output with dynamically determined size
    var output =
        List.filled(1 * _embeddingSize, 0.0).reshape([1, _embeddingSize]);

    // 4. Run inference
    _interpreter.run(input, output);

    return List<double>.from(output[0]);
  }

  double compareEmbeddings(List<double> e1, List<double> e2) {
    if (e1.length != e2.length) {
      throw Exception('Embeddings must be of same length');
    }

    double dot = 0.0, normE1 = 0.0, normE2 = 0.0;
    for (int i = 0; i < e1.length; i++) {
      dot += e1[i] * e2[i];
      normE1 += e1[i] * e1[i];
      normE2 += e2[i] * e2[i];
    }
    return dot / (sqrt(normE1) * sqrt(normE2));
  }
}
