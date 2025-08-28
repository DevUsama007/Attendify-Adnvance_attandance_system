import 'dart:io';
import 'package:attendify/app/view_model/camera_view_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewView extends StatelessWidget {
  final CameraViewModel cameraController = Get.put(CameraViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Obx(() {
          if (cameraController.imagePath.value.isEmpty) {
            return Text('No image captured');
          }
          return Image.file(File(cameraController.imagePath.value));
        }),
      ),
    );
  }
}
