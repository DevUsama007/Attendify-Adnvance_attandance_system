import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/appTextStyles.dart';
import '../../res/app_colors.dart';

Widget emptyOverviewWidget(
  VoidCallback ontap,
  String title,
) {
  return InkWell(
    onTap: ontap,
    child: Container(
      width: Get.width * 0.42,
      height: 125,
      decoration: BoxDecoration(
          color: AppColors.scaffoldDark,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              Text(
                title.toString(),
                style: AppTextStyles.customTextbolddark14(),
              ).paddingOnly(left: 15)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '--:--',
                style: AppTextStyles.customText(
                    fontSize: 20, color: Colors.white.withOpacity(0.7)),
              ),
              Container(
                height: 30, // This makes the divider visible!
                child: VerticalDivider(
                  color: Colors.white,
                  thickness: 2,
                  width: 10,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.iconColor),
                child: Text(
                  'N/A',
                  style: AppTextStyles.customText(
                      fontSize: 9, color: Colors.white.withOpacity(0.9)),
                ),
              )
            ],
          ).paddingOnly(top: 10, left: 10, right: 10),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Not Updated Yet',
                style: AppTextStyles.customText(
                    fontSize: 12, color: Colors.white.withOpacity(0.4)),
              ),
            ],
          )
        ],
      ).marginSymmetric(vertical: 10, horizontal: 10),
    ),
  );
}
