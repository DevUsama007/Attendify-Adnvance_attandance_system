import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/appTextStyles.dart';
import '../../res/app_assets.dart';
import '../../res/app_colors.dart';

Widget recentActivityLoading() {
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
    child: Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.6),
          ),
          title: Container(
            width: 40,
            height: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.scaffoldDark),
          ).paddingOnly(right: 70),
          subtitle: Container(
            width: 90,
            height: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.scaffoldDark),
          ).paddingOnly(right: 20),
          trailing: Container(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.iconColor),
            child: Text(
              'On time',
              style: AppTextStyles.customText(fontSize: 9),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 30,
          width: 180,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
        )
      ],
    ),
  );
}
