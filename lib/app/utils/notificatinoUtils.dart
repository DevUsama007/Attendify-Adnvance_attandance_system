import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import '../res/appTextStyles.dart';
import '../res/app_colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class NotificationUtils {
  static void showSnackBar(
      BuildContext context, String title, String message, bool success) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20, // Below status bar
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: AwesomeSnackbarContent(
            color: success ? Colors.green : Colors.red,
            titleTextStyle: AppTextStyles.customText(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            messageTextStyle: AppTextStyles.customText(
              fontSize: 12,
              color: Colors.white,
            ),
            title: title,
            message: message,
            contentType: success ? ContentType.success : ContentType.failure,
          ),
        ),
      ),
    );

    // Insert overlay
    overlay.insert(overlayEntry);

    // Remove after 3 seconds
    Future.delayed(Duration(seconds: 3), () => overlayEntry.remove());
  }
}
