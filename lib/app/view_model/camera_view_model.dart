import 'dart:async';
import 'dart:io';
import 'package:attendify/app/res/app_string.dart';
import 'package:attendify/app/res/routes/routes_name.dart';
import 'package:attendify/app/services/face_detection_services.dart';
import 'package:attendify/app/utils/storage_utils.dart';
import 'package:attendify/app/view/cameraScreens/previewScreen.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../data/embadingrepo.dart';
import '../data/user_homepage_repo.dart';
import '../services/facerecoginition.dart';
import '../utils/calendar_utils.dart';
import '../utils/notificatinoUtils.dart';
import 'user_panel_view_models/user_homepage_view_model.dart';

class CameraViewModel extends GetxController {
  final UserHomepageRepo _homepageRepo = UserHomepageRepo();

  UserHomepageViewModel homepageController = Get.put(UserHomepageViewModel());
  late CameraController controller;
  final FaceEmbeddingExtractor _embeddingExtractor = FaceEmbeddingExtractor();
  Embadingrepo _embadingrepo = Embadingrepo();
  RxString sessionName = ''.obs;

  List<double>? _embedding;
  final RxBool isCameraReady = false.obs;
  final RxString imagePath = ''.obs;
  List<CameraDescription>? cameras;
  RxBool faceVerifying = false.obs;
  RxString faceVerificationMessage = 'Loading'.obs;
  RxString userName = ''.obs;
  RxString personName = ''.obs;
  RxBool isError = false.obs;
  RxString faceDetectionErrorMessage = 'Processing...'.obs;

  toggleFaceVerifying(bool value) {
    faceVerifying.value = value;
  }

  updatesessionName(String name) {
    sessionName.value = name;
  }

  toggleError(bool error, String message) {
    isError.value = error;
    faceDetectionErrorMessage.value = message;
  }

  updateFaceVerificationMessage(String message) {
    faceVerificationMessage.value = message;
  }

  refreshImagePath() {
    faceVerificationMessage.value = 'Loading...';
    faceDetectionErrorMessage.value = 'Processing...';
    imagePath.value = '';
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();

      // Find the front camera
      final frontCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () =>
            cameras![0], // fallback to first camera if no front camera
      );

      controller = CameraController(
        frontCamera,
        ResolutionPreset.ultraHigh,
      );

      await controller.initialize();
      isCameraReady.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Could not initialize camera: $e');
    }
  }

  Future<void> takePicture(BuildContext context) async {
    if (!isCameraReady.value || !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isTakingPicture) {
      return;
    }

    try {
      final Directory extDir = await getTemporaryDirectory();
      final String dirPath = '${extDir.path}/Pictures/flutter_test';
      await Directory(dirPath).create(recursive: true);
      final String filePath = join(dirPath, '${DateTime.now()}.jpg');

      final XFile picture = await controller.takePicture();
      final File imageFile = File(picture.path);
      await imageFile.copy(filePath);

      imagePath.value = filePath;
      if (imagePath.value.isNotEmpty) {
        faceVerification(context);
      }
      // add the code to move the image
      // Navigator.of(Get.context!).push(
      //   MaterialPageRoute(
      //     builder: (context) => PreviewView(),
      //   ),
      // );
      // Get.toNamed(Routes.PREVIEW);
    } catch (e) {
      Get.snackbar('Error', 'Failed to take picture: $e');
    }
  }

  faceVerification(BuildContext context) async {
    faceVerifying.value = true;
    isError.value = false;
    updateFaceVerificationMessage('Detecting face...');
    await _loadModel(context);

    await FaceDetectionServices.detectFaceInImage(File(imagePath.value)).then(
      (isFaceDetected) async {
        if (isFaceDetected) {
          updateFaceVerificationMessage('Face Varifying...');
          await compareWithStoredFace().then(
            (similarity) async {
              print('Similarity:--------------------------- $similarity');
              // similarity 0.7 maximum for the face detection
              if (similarity != null && similarity > 0.1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Face matched with similarity: ${similarity.toStringAsFixed(4)}')),
                );
                if (sessionName.value == 'check in') {
                  updateFaceVerificationMessage(
                      'updating ${sessionName.value} Attendance');
                  Map<String, dynamic> data = {
                    'username': userName.value.toString(),
                    'checkInTime': CalendarUtils().getCurrentTime12Hour(),
                    'checkInAmPm': CalendarUtils().getAmPm(),
                    'checkInDate': CalendarUtils.getCurrentDate().toString(),
                    'checkInMonth': CalendarUtils.getCurrentMonthName(),
                    'checkInYear': CalendarUtils.getCurrentYear(),
                    'checkInDay': CalendarUtils.getCurrentDayName().toString(),
                    'checkInSession': 'true'
                  };
                  await setTodayAttendance(
                          context,
                          DateTime.now().year,
                          CalendarUtils.getCurrentMonthName(),
                          CalendarUtils.getCurrentDate().toString(),
                          'Check In',
                          data)
                      .then((value) {
                    faceVerifying.value = false;
                    NotificationUtils.showSnackBar(
                        context, 'Success', 'Attendance Updated', true);
                    Get.offAllNamed(RouteName.userHomeScreen);
                  });
                } else if (sessionName.value == 'check out') {
                  updateFaceVerificationMessage(
                      'updating ${sessionName.value} Attendance');
                  Map<String, dynamic> data = {
                    'username': userName.value.toString(),
                    'checkOutTime': CalendarUtils().getCurrentTime12Hour(),
                    'checkOUtAmPm': CalendarUtils().getAmPm(),
                    'checkOutDate': CalendarUtils.getCurrentDate().toString(),
                    'checkOutMonth': CalendarUtils.getCurrentMonthName(),
                    'checkOutYear': CalendarUtils.getCurrentYear(),
                    'checkOutDay': CalendarUtils.getCurrentDayName().toString(),
                    'checkOutSession': 'true'
                  };
                  await setTodayAttendance(
                          context,
                          DateTime.now().year,
                          CalendarUtils.getCurrentMonthName(),
                          CalendarUtils.getCurrentDate().toString(),
                          'Check Out',
                          data)
                      .then((value) {
                    faceVerifying.value = false;
                    NotificationUtils.showSnackBar(
                        context, 'Success', 'Attendance Updated', true);

                    Get.offAllNamed(RouteName.userHomeScreen);
                  });
                }
              } else {
                toggleError(true, 'Face Did Not Match Retry ');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Face did not match')),
                );
              }
            },
          ).onError(
            (error, stackTrace) {
              toggleError(
                  true, 'Error occurred while comparing faces ${error}');
            },
          );
        } else {
          toggleError(true, 'No Face Detected Retry');
        }
      },
    );
  }

  //load the model for face embading extraction
  Future<void> _loadModel(BuildContext context) async {
    try {
      await _embeddingExtractor.loadModel();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load model: $e')),
      );
    }
  }
//face embading model code ends here

//extract the embadings and compare it with the stored embadings
  Future<double?> compareWithStoredFace() async {
    try {
      // 1. Get stored embedding

      final storedEmbedding = await _embadingrepo
          .getFaceEmbedding(userName.value.toString().trim());
      print(storedEmbedding);
      if (storedEmbedding == null) {
        toggleError(true, '${userName.value} Face Not Found');
        return null;
      }
      // 2. Extract new embedding
      final newEmbedding =
          await _embeddingExtractor.extractEmbedding(File(imagePath.value));
      print('stored embeddings: $storedEmbedding');
      print('new embeddings: $newEmbedding');
      // 3. Compare
      return _embeddingExtractor.compareEmbeddings(
          storedEmbedding, newEmbedding);
    } catch (e) {
      print('Error in face comparison: $e');
      return null;
    }
  }

  getUserName() async {
    await StorageService.read(AppStrings.storageUserId).then((value) {
      userName.value = value;
    });
    await StorageService.read(AppStrings.storageUserName).then((value) {
      personName.value = value;
    });
  }

//codes ends here
  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    getUserName();
  }

  setTodayAttendance(BuildContext context, int year, String month,
      String todayDate, session, dynamic data) async {
    await _homepageRepo
        .addTodayAttendance(
            year, month, todayDate, userName.toString().trim(), session, data)
        .then(
      (value) async {
        await addTodayRecentActivity(context, session);
      },
    ).onError(
      (error, stackTrace) {
        NotificationUtils.showSnackBar(
            context, 'Error', 'Failed to Submit Attendance', false);
      },
    );
  }

  addTodayRecentActivity(BuildContext context, String session) async {
    print(
        "--------------------------------jutt--------------------------------------");
    Map<String, dynamic> data = {
      'Time': CalendarUtils().getCurrentTime12Hour(),
      'AmPm': CalendarUtils().getAmPm(),
      'Date': CalendarUtils.getCurrentDate().toString(),
      'Month': CalendarUtils.getCurrentMonthName(),
      'Year': CalendarUtils.getCurrentYear(),
      'DayName': CalendarUtils.getCurrentDayName().toString(),
      'sessionName': session.toString(),
      'personId': userName.value.toString(),
      'personName': personName.value.toString(),
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _homepageRepo.addTodayRecentActivity(
        data, userName.value.toString(), session.toString());
  }
}
