import 'package:attendify/app/res/appTextStyles.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldDark,
      builder: (_) {
        return AnimatedPadding(
          // This padding will adjust automatically when the keyboard opens
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 250),
          curve: Curves.decelerate,
          child: SingleChildScrollView(
            child: Container(
              height: height ?? MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: AppColors.scaffoldDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        );
      },
    );
  }
}


