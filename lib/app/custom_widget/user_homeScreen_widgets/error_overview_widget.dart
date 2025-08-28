import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/appTextStyles.dart';
import '../../res/app_colors.dart';

Widget errorOverviewWidget() {
  return Container(
    width: Get.width * 0.42,
    height: 125,
    decoration: BoxDecoration(
        color: AppColors.scaffoldDark, borderRadius: BorderRadius.circular(20)),
    child: Center(
      child: Icon(
        Icons.cloud_off_outlined,
        size: 30,
        color: Colors.white.withOpacity(0.7),
      ).marginSymmetric(vertical: 10, horizontal: 10),
    ),
  );
}
