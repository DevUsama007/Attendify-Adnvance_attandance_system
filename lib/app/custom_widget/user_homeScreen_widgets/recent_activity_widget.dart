import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/appTextStyles.dart';
import '../../res/app_assets.dart';
import '../../res/app_colors.dart';

Widget recentActivityWidget(
    String title, String date, String time, String amOrPm, String sessionName) {
  return Container(
    width: Get.width,
    height: 140,
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
            child: Icon(
              Icons.location_on,
              color: AppColors.iconColor,
            ),
          ),
          title: Text(
            title.toString(),
            style: AppTextStyles.customText(fontSize: 16, color: Colors.white),
          ),
          subtitle: Text(
            date.toString(),
            style: AppTextStyles.customTextdark12(),
          ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${sessionName.toString()}: ',
              style: AppTextStyles.customText(
                fontSize: 16,
                color: AppColors.iconColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              time.toString(),
              style: AppTextStyles.customText(fontSize: 30),
            ),
            Text(
              amOrPm.toString(),
              style: AppTextStyles.customText(fontSize: 14),
            ),
          ],
        )
      ],
    ),
  );
}

Widget recentActivityListWidget(
  String title,
  String date,
  String time,
  String amOrPm,
) {
  return Container(
    width: Get.width,
    height: 120,
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
            child: Icon(
              Icons.location_on,
              color: AppColors.iconColor,
            ),
          ),
          title: Text(
            title.toString(),
            style: AppTextStyles.customText(fontSize: 16, color: Colors.white),
          ),
          subtitle: Text(
            date.toString(),
            style: AppTextStyles.customTextdark12(),
          ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${title.toString()}: ',
              style: AppTextStyles.customText(
                fontSize: 16,
                color: AppColors.iconColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              time.toString(),
              style: AppTextStyles.customText(fontSize: 30),
            ),
            Text(
              amOrPm.toString(),
              style: AppTextStyles.customText(fontSize: 14),
            ),
          ],
        )
      ],
    ),
  );
}
