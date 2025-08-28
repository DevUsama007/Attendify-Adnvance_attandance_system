import 'package:attendify/app/res/appTextStyles.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget CustomButtonWidget(
    {required String text,
    required VoidCallback onPressed,
    Color backgroundColor = const Color.fromARGB(255, 236, 86, 75),
    Color textColor = Colors.white,
    bool isProcessing = false,
    String message = ''}) {
  return InkWell(
    onTap: isProcessing ? null : onPressed,
    child: Container(
      width: Get.width,
      height: 50,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: isProcessing
              ? Transform.scale(
                  scale: 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: [
                          Colors.white,
                        ],
                        // backgroundColor: AppColors.iconColor,
                        strokeWidth: 0.7,
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Text(
                        message,
                        style: AppTextStyles.customText(
                            fontSize: 18, color: AppColors.textPrimaryDark),
                      )
                    ],
                  ),
                )
              : Text(
                  text,
                  style: AppTextStyles.customTextbolddark14(),
                )),
    ),
  );
}
