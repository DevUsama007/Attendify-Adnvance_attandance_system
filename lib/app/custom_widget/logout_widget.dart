import 'package:attendify/app/custom_widget/admin_function_widget.dart';
import 'package:attendify/app/custom_widget/custom_button_widget.dart';
import 'package:attendify/app/res/appTextStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget logoutWidget(
  VoidCallback onSubmit,
  VoidCallback onCancel,
) {
  return Container(
    child: Column(
      children: [
        Text(
          'Do You Want to Logout',
          style: AppTextStyles.customText(fontSize: 16, color: Colors.white),
        ).paddingOnly(top: 10, bottom: 10),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: onCancel,
                child: logoutButton('Cancel', Colors.black.withOpacity(0.6))),
            InkWell(
                onTap: onSubmit,
                child:
                    logoutButton('Logout', Color.fromARGB(255, 236, 86, 75))),
          ],
        ).paddingOnly(top: 20),
      ],
    ),
  );
}

Widget logoutButton(String title, Color clr) {
  return Container(
    width: Get.width * 0.4,
    height: 45,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: clr),
    child: Center(
      child: Text(
        title,
        style: AppTextStyles.customText(fontSize: 12, color: Colors.white),
      ),
    ),
  );
}
