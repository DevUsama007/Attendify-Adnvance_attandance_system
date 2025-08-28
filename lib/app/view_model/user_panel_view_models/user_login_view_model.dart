import 'package:attendify/app/res/app_string.dart';
import 'package:attendify/app/utils/storage_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/routes/routes_name.dart';
import '../../utils/notificatinoUtils.dart';

class UserLoginViewModel extends GetxController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  toggleLoading(bool value) {
    isLoading.value = value;
  }

  fieldAuthentication(context) {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      NotificationUtils.showSnackBar(
          context, 'Error', 'Please fill in all fields', false);
    } else {
      login(context);
    }
  }

//function to login the user
  void login(BuildContext context) async {
    try {
      toggleLoading(true);
      final authData = await _firebaseFirestore
          .collection('attendify')
          .doc('UserData')
          .collection('userCradentials')
          .doc(usernameController.text.trim())
          .get();
      if (authData.exists) {
        // Check if the credentials are correct
        if (authData.data()!['userName'] == usernameController.text.trim() &&
            authData.data()!['password'] == passwordController.text.trim()) {
          // Login successful
          NotificationUtils.showSnackBar(
              context, 'Success', 'Welcome to Attendify', true);
          storeUserData(authData.data()!['name'], authData.data()!['userName']);
          Get.offAllNamed(RouteName.userHomeScreen);
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

//login function ends here
  storeUserData(String name, String username) {
    StorageService.save(AppStrings.storageUserName.toString(), name);
    StorageService.save(AppStrings.storageUserId.toString(), username);
  }
}
