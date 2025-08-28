import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/appTextStyles.dart';
import '../../res/app_assets.dart';
import '../../res/app_colors.dart';
Widget recentActivityError(String title) {
  return Container(
    width: Get.width,
    height: 150,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.darken),
            fit: BoxFit.cover,
            image: AssetImage(AppAssets.bgImage2))),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 30,
            color: Colors.white.withOpacity(0.7),
          ).marginSymmetric(vertical: 10, horizontal: 10),
           Text(
            title.toString(),
            style:
                AppTextStyles.customText(color: Colors.white.withOpacity(0.5)),
          )
        ],
      ),
    ),
  );
}
