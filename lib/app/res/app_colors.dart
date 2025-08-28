import 'package:flutter/material.dart';

class AppColors {
  // ========== Primary Colors ========== //
  static const Color primary = Color(0xFF2E5AAC); // Deep Blue
  static const Color primaryDark = Color(0xFF1E3F8B);
  static const Color primaryLight = Color(0xFF5B7FD9);

  // ========== App Bar ========== //
  static const Color appBarLight = primary;
  static const Color appBarDark = Color(0xFF121212);

  // ========== Buttons & Button Icons ========== //
  // Primary Button (Blue Background)
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryIcon = Colors.white; // White icon on blue

  // Secondary Button (Light Green Background)
  static const Color buttonSecondary = Color(0xFF81C784);
  static const Color buttonSecondaryIcon =
      Color(0xFF1E3F8B); // Dark blue icon on light green

  // Accent Button (Amber Background)
  static const Color buttonAccent = Color(0xFFFFC107);
  static const Color buttonAccentIcon =
      Color(0xFF333333); // Dark gray icon on amber

  // Disabled Button
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  static const Color buttonDisabledIcon = Color(0xFF757575); // Gray icon

  // Floating Action Button (FAB)
  static const Color fabBackground = primary;
  static const Color fabIcon = Colors.white;

  // ========== Icons (General) ========== //
  static const Color iconLight = primary; // Default light theme
  static const Color iconDark =
      Color.fromARGB(255, 214, 213, 213); // Default dark theme
  static const Color iconSuccess = Color(0xFF43A047);
  static const Color iconError = Color(0xFFE53935);

  // ========== Background & Text ========== //
  static const Color scaffoldLight = Color(0xFFFAFAFA);
  static const Color scaffoldDark = Color(0xFF121212);
  static const Color textPrimaryLight = Color(0xFF333333);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static Color textfieldcolor = const Color.fromARGB(255, 63, 63, 63);
  static Color pointerColor = const Color.fromARGB(255, 236, 86, 75);
  static Color iconColor = Color.fromARGB(255, 236, 86, 75);
  static Color buttonBackgroundColor = const Color.fromARGB(255, 236, 86, 75);
  static Color iconbgColor = const Color.fromARGB(255, 63, 63, 63);
  static Color scafoldSecondaryColor = const Color.fromARGB(255, 90, 90, 90);
  static Color appbarcolor = const Color.fromARGB(255, 90, 90, 90);
}
