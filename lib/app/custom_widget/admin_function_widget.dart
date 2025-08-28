import 'package:attendify/app/res/appTextStyles.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget AdminFunctionWidget(
  String title,
  VoidCallback onPressed,
) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: Get.width * 0.35,
      height: 70,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldDark,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          title.toString(),
          style: AppTextStyles.customTextbolddark12(),
        ),
      ),
    ),
  );
}
