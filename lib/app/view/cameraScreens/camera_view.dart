import 'dart:io';
import 'dart:math';

import 'package:attendify/app/custom_widget/custom_button_widget.dart';
import 'package:attendify/app/res/appTextStyles.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:attendify/app/view_model/camera_view_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../custom_widget/loading_indicator_widget.dart';

class CameraView extends StatefulWidget {
  String session;
  CameraView({super.key, required this.session});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraViewModel _cameraViewModel = Get.put(CameraViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarDark,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBarDark,
        title: Text(
          "Keep The Head Straight",
          style: AppTextStyles.customTextbolddark14(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cameraViewModel.refreshImagePath();
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          ).paddingOnly(right: 10),
        ],
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Obx(
            () {
              return CustomButtonWidget(
                text: "Face Verification",
                onPressed: !_cameraViewModel.imagePath.value.isEmpty
                    ? () {}
                    : () {
                        _cameraViewModel.updatesessionName(
                            widget.session.toString().toLowerCase());
                        _cameraViewModel.takePicture(context);
                      },
              ).marginOnly(left: 40, right: 10);
            },
          )),
      body: Obx(() {
        if (!_cameraViewModel.isCameraReady.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          width: Get.width,
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !_cameraViewModel.imagePath.value.isEmpty
                  ? Container(
                      width: Get.width * 0.8,
                      height: Get.height * 0.7,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(pi),
                                child: Image.file(
                                    File(_cameraViewModel.imagePath.value))),
                          ),
                          _cameraViewModel.faceVerifying.value
                              ? Center(
                                  child: _cameraViewModel.isError.value
                                      ? _erroFaceDetectionWidget(
                                          message: _cameraViewModel
                                              .faceDetectionErrorMessage.value
                                              .toString())
                                      : _verifyingFaceWidget(
                                          message: _cameraViewModel
                                              .faceVerificationMessage.value,
                                        ))
                              : Container()
                        ],
                      ))
                  : Container(
                      width: Get.width * 0.9,
                      height: Get.height * 0.7,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: CameraPreview(
                          _cameraViewModel.controller,
                        ),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}

Widget _verifyingFaceWidget({String message = 'Face Verifying...'}) {
  return Container(
    width: Get.width * 0.6,
    height: 90,
    decoration: BoxDecoration(
      color: AppColors.scaffoldDark.withOpacity(0.7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          style: AppTextStyles.customTextbolddark14(),
        ),
        SizedBox(
          height: 8,
        ),
        LoadingIndicatorWidget(
            strokeWidth: 0.2,
            width: Get.width * 0.3,
            height: Get.height * 0.03,
            indicator: Indicator.ballPulse,
            indicatorColor: AppColors.iconColor)
      ],
    ),
  );
}

Widget _erroFaceDetectionWidget({String message = 'Face Verifying...'}) {
  return Container(
    width: Get.width * 0.6,
    height: 90,
    decoration: BoxDecoration(
      color: AppColors.scaffoldDark.withOpacity(0.7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Text(
        textAlign: TextAlign.center,
        message,
        style: AppTextStyles.customTextbolddark14(),
      ),
    ),
  );
}
