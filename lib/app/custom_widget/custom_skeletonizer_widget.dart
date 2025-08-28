import 'package:attendify/app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget CustomSkeletonizerWidget({
  required Widget child,
}) {
  return Skeletonizer(
    textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(10)),
    effect: PulseEffect(
      from: AppColors.scaffoldDark.withOpacity(0.8),
      to: AppColors.scaffoldDark.withOpacity(0.4),
      duration: const Duration(seconds: 1),
    ),
    enabled: true,
    containersColor: Colors.black.withOpacity(0.2),
    child: child,
  );
}
