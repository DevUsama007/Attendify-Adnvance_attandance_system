import 'dart:io';

import 'package:attendify/app/data/embadingrepo.dart';
import 'package:attendify/app/services/face_detection_services.dart';
import 'package:attendify/app/utils/notificatinoUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/admin_homepage_repo.dart';
import '../../services/facerecoginition.dart';
import '../../utils/image_picker_utils.dart';

class AdminAdduserViewmodel extends GetxController {
  AdminHomepageRepo _homepageRepo = AdminHomepageRepo();
  Embadingrepo _embadingrepo = Embadingrepo();
  final FaceEmbeddingExtractor _embeddingExtractor = FaceEmbeddingExtractor();
  RxBool isadding = false.obs;
  RxString addingMessage = ''.obs;
  RxBool loadedModel = false.obs;
  List<double>? _embedding;
  updateEmbedding(List<double>? embedding) {
    _embedding = embedding;
  }

  toggleModelLoading(bool value) {
    loadedModel.value = value;
  }

  toggleMessage(String message) {
    addingMessage.value = message;
  }

  toggleAdding(bool adding) {
    isadding.value = adding;
  }

  TextEditingController nameControler = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool pickImage = false.obs;

  final Rx<File?> selectedImage = Rx<File?>(null);
  Future<void> loadModel() async {
    try {
      toggleModelLoading(true);
      await _embeddingExtractor.loadModel();
      toggleMessage('Model loaded successfully');
    } catch (e) {
      toggleModelLoading(false);
      toggleMessage('Failed to load model: $e');
    }
  }

  fieldValidation(BuildContext context) {
    if (nameControler.text.isEmpty ||
        userNameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      NotificationUtils.showSnackBar(
          context, 'Error', 'All fields are required', false);
    } else {
      detectFace(context);
    }
  }

  detectFace(BuildContext context) async {
    toggleAdding(true);
    toggleMessage('Detecting face in image...');
    if (selectedImage.value != null) {
      bool hasFace =
          await FaceDetectionServices.detectFaceInImage(selectedImage.value!);
      if (hasFace) {
        extractEmbeddings(context);
      } else {
        toggleAdding(false);
        NotificationUtils.showSnackBar(
            context, 'Error', 'No face detected', false);
      }
    } else {
      toggleAdding(false);
      NotificationUtils.showSnackBar(
          context, 'Error', 'Please select the image first', false);
    }
  }

  // embeding extractor
  extractEmbeddings(BuildContext context) async {
    if (loadedModel.value == false) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'Model not loaded yet',
      ));
    } else {
      if (selectedImage.value != null) {
        toggleAdding(true);
        toggleMessage('Extracting embedings...');
        final embedding = await _embeddingExtractor
            .extractEmbedding(selectedImage.value!)
            .then(
          (value) async {
            print(value);
            updateEmbedding(value);
            print('Embedings ${_embedding}');
            await _embadingrepo
                .uploadFaceEmbedding(
              username: userNameController.text.toString(),
              embedding: value,
              name: nameControler.text.toString(),
            )
                .then(
              (value) {
                addUser(context);
              },
            );
          },
        ).onError(
          (error, stackTrace) {
            Get.showSnackbar(GetSnackBar(
              title: 'Error',
              message: 'Failed to extract embedding: $error',
            ));
          },
        );
      } else {
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
          message: 'Please select an image first',
        ));
        // Handle null case (e.g., show error message)
      }
    }

    // Implement your embedding extraction logic here
    // upload embedings
  }

  addUser(BuildContext context) {
    toggleAdding(true);
    toggleMessage('Adding User Data...');
    // Implements your user addition logic here
    _homepageRepo
        .addUser(
      userNameController.text.toString(),
      nameControler.text.toString(),
      passwordController.text.toString(),
    )
        .then((value) {
      toggleAdding(false);
      NotificationUtils.showSnackBar(
          context, 'Success', 'User added successfully', true);
      Navigator.pop(context);
    }).catchError((error) {
      toggleAdding(false);
      NotificationUtils.showSnackBar(context, 'Error', error.toString(), false);
    });
  }

  Future<void> imagePicker(BuildContext context) async {
    try {
      final image = await ImagePickerUtils.pickImage();
      if (image != null) {
        selectedImage.value = image;
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: 'Failed',
        message: e.toString(),
        duration: Duration(seconds: 2),
      ));
    }
  }

  togglePickImage(bool value) {
    pickImage.value = value;
  }

  @override
  void onInit() {
    loadModel();
    super.onInit();
  }
}
