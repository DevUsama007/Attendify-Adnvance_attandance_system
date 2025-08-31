import 'package:attendify/app/res/app_string.dart';
import 'package:attendify/app/res/routes/routes_name.dart';
import 'package:attendify/app/services/noitfication_services/notification_services.dart';
import 'package:attendify/app/utils/notificatinoUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/storage_utils.dart';

class AdminLoginViewModel extends GetxController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  NotificationServices _notificationServices = NotificationServices();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  toggleLoading(bool value) {
    isLoading.value = value;
  }

  fieldAuthentication(context) {
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      NotificationUtils.showSnackBar(
          context, 'Error', 'Please fill in all fields', false);
    } else {
      login(context);
    }
  }

  void login(BuildContext context) async {
    try {
      toggleLoading(true);
      final authData = await _firebaseFirestore
          .collection('attendify')
          .doc('AdminCradentials')
          .get();
      if (authData.exists) {
        // Check if the credentials are correct
        if (authData.data()!['username'] == userNameController.text.trim() &&
            authData.data()!['password'] == passwordController.text.trim()) {
          // Login successful
          NotificationUtils.showSnackBar(
              context, 'Success', 'Welcome to Attendify', true);
          storeAdminData(
              authData.data()!['Name'], authData.data()!['username']);
          loginServices(context);
        } else {
          // Login failed
          NotificationUtils.showSnackBar(
              context, 'Error', 'Invalid username or password', false);
        }
      } else {
        NotificationUtils.showSnackBar(
            context, 'Error', 'Data Not Found', false);
      }
      // Simulate a login process
      await Future.delayed(Duration(seconds: 2));
      toggleLoading(false);
    } catch (e) {
      toggleLoading(false);
      NotificationUtils.showSnackBar(
          context, 'Error', 'An error occurred: ${e.toString()}', false);
    }
  }

  storeAdminData(String name, String username) {
    StorageService.save(AppStrings.storageAdminName.toString(), name);
    StorageService.save(AppStrings.storageAdminId.toString(), username);
  }

  loginServices(BuildContext context) async {
    await _notificationServices.getDeviceToken().then(
      (value) {
        storeDeviceId(value.toString(), context);
      },
    );
  }

  storeDeviceId(String deviceId, BuildContext context) async {
    await _firebaseFirestore
        .collection('attendify')
        .doc('AdminCradentials')
        .set(
            {'deviceToken': deviceId.toString()}, SetOptions(merge: true)).then(
      (value) {
        Get.offAllNamed(RouteName.adminHomeScreen);
      },
    ).onError(
      (error, stackTrace) {
        toggleLoading(false);
        NotificationUtils.showSnackBar(
            context, 'Error', 'An error occurred: ${error.toString()}', false);
      },
    );
  }
}
