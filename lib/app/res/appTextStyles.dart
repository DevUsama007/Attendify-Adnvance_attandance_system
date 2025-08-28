import 'package:attendify/app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  AppTextStyles._();
  static TextStyle customText({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    double fontSize = 12,
    double? height,
  }) {
    return GoogleFonts.poetsenOne(
      color: color ?? AppColors.textPrimaryDark,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle customTextbolddark20() {
    return GoogleFonts.poetsenOne(
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.bold);
  }

  static TextStyle customTextbolddark16() {
    return GoogleFonts.poetsenOne(
        color: AppColors.textPrimaryDark,
        fontSize: 16,
        fontWeight: FontWeight.bold);
  }

  static TextStyle customTextbolddark14() {
    return GoogleFonts.poetsenOne(
        color: AppColors.textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.bold);
  }

  static TextStyle customTextbolddark12() {
    return GoogleFonts.poetsenOne(
        color: AppColors.textPrimaryDark,
        fontSize: 12,
        fontWeight: FontWeight.bold);
  }

//without bold text styles
  static TextStyle customTextdark16() {
    return GoogleFonts.poetsenOne(
      color: AppColors.textPrimaryDark,
      fontSize: 16,
    );
  }

  static TextStyle customTextdark14() {
    return GoogleFonts.poetsenOne(
      color: AppColors.textPrimaryDark,
      fontSize: 14,
    );
  }

  static TextStyle customTextdark12() {
    return GoogleFonts.poetsenOne(
      color: AppColors.textPrimaryDark,
      fontSize: 12,
    );
  }

  // static TextStyle customTextGrey12() {
  //   return TextStyle(
  //       color: AppColors.textColor,
  //       fontFamily: AppFonts.poetsenOneRegular,
  //       fontSize: 14,
  //       fontWeight: FontWeight.w500);
  // }

  // static TextStyle customTextGrey10() {
  //   return TextStyle(
  //     color: AppColors.textColor,
  //     fontFamily: AppFonts.poetsenOneRegular,
  //     fontSize: 10,
  //   );
  // }
}
