import 'dart:io';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionServices {
  static Future<bool> detectFaceInImage(File imageFile) async {
    try {
      // Prepare the input image
      final inputImage = InputImage.fromFile(imageFile);

      // Configure face detector (fast mode, no landmarks/contours needed)
      final options = FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableLandmarks: false,
        enableContours: false,
      );

      final faceDetector = FaceDetector(options: options);

      // Run detection
      final List<Face> faces = await faceDetector.processImage(inputImage);

      // Dispose detector when done
      await faceDetector.close();

      // Return true if any face found
      return faces.isNotEmpty;
    } catch (e) {
      print("Face detection error: $e");
      return false;
    }
  }
}
