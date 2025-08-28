import 'package:flutter/material.dart';

import '../res/appTextStyles.dart';
import '../res/app_colors.dart';

class CustomTextFieldWidget extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  String labeltext;
  int maxlines;
  final VoidCallback? onchange;
  VoidCallback? ontraillingtap;
  IconData? traillingIcon;
  CustomTextFieldWidget({
    super.key,
    this.onchange,
    this.ontraillingtap,
    this.maxlines = 1,
    required this.traillingIcon,
    required this.controller,
    required this.hintText,
    required this.labeltext,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTextStyles.customText(color: AppColors.textPrimaryDark),
      cursorColor: AppColors.pointerColor,
      maxLines: maxlines,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: ontraillingtap,
          child: Icon(traillingIcon,
              color: AppColors.textPrimaryDark.withOpacity(0.5)),
        ),
        filled: true,
        fillColor: AppColors.textfieldcolor,
        labelText: labeltext,
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textPrimaryDark.withOpacity(0.3)),
        labelStyle: AppTextStyles.customText(
            color: AppColors.textPrimaryDark.withOpacity(0.5), fontSize: 12),
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors
                .textfieldcolor, // Focused border color (e.g., your purple accent)
            width: 1.5, // Thicker border when selected
          ),
          borderRadius: BorderRadius.circular(5), // Match your design
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.textPrimaryDark.withOpacity(
                0.3), // Focused border color (e.g., your purple accent)
            width: 1.5, // Thicker border when selected
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        // Optional: Add the same borderRadius to the base `border` for consistency
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.textPrimaryDark.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onChanged: (_) {
        // Only call the callback if it's provided
        onchange?.call();
      },
    );
  }
}
