import 'package:attendify/app/data/user_homepage_repo.dart';
import 'package:attendify/app/res/app_string.dart';
import 'package:attendify/app/utils/notificatinoUtils.dart';
import 'package:attendify/app/view/userPanelScreens/userSplashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/noitfication_services/notification_services.dart';
import '../../services/noitfication_services/send_notifcation_service.dart';
import '../../utils/calendar_utils.dart';
import '../../utils/storage_utils.dart';

class UserHomepageViewModel extends GetxController {
  final UserHomepageRepo _homepageRepo = UserHomepageRepo();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  RxString name = '-------'.obs;
  RxString userId = ''.obs;
  RxBool isAttendanceLoading = false.obs;

  // setTodayAttendance(BuildContext context, int year, String month,
  //     String todayDate, session, dynamic data) async {
  //   await _homepageRepo
  //       .addTodayAttendance(
  //           year, month, todayDate, userId.toString().trim(), session, data)
  //       .then(
  //     (value) async {
  //       await addTodayRecentActivity(context, session);
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       NotificationUtils.showSnackBar(
  //           context, 'Error', 'Failed to Submit Attendance', false);
  //     },
  //   );
  // }

  // addTodayRecentActivity(BuildContext context, String session) async {
  //   Map<String, dynamic> data = {
  //     'Time': CalendarUtils().getCurrentTime12Hour(),
  //     'AmPm': CalendarUtils().getAmPm(),
  //     'Date': CalendarUtils.getCurrentDate().toString(),
  //     'Month': CalendarUtils.getCurrentMonthName(),
  //     'Year': CalendarUtils.getCurrentYear(),
  //     'DayName': CalendarUtils.getCurrentDayName().toString(),
  //     'sessionName': session.toString(),
  //     'personId': userId.value.toString(),
  //     'personName': name.value.toString(),
  //     'timestamp': FieldValue.serverTimestamp(),
  //   };
  //   await _homepageRepo
  //       .addTodayRecentActivity(
  //           data, userId.value.toString(), session.toString())
  //       .then(
  //     (value) {
  //       NotificationUtils.showSnackBar(
  //           context, 'Success', 'Attendance Submitted', true);
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       NotificationUtils.showSnackBar(
  //           context, 'Error', 'Failed to Submit Attendance', false);
  //     },
  //   );
  // }

  getUserData() async {
    print('object');
    // This method can be used to fetch the admin name from storage or any other source
    await StorageService.read(AppStrings.storageUserName.toString())
        .then((value) {
      if (value != null) {
        name.value = value.toString();
      } else {
        name.value = '-------';
      }
    });
    await StorageService.read(AppStrings.storageUserId.toString())
        .then((value) {
      if (value != null) {
        userId.value = value.toString();
      } else {
        userId.value = '';
      }
    });
  }

  logoutUser() {
    StorageService.remove(AppStrings.storageUserId).then(
      (value) {
        Get.offAll(UserSplashScreen());
      },
    );
  }

  Future<DocumentSnapshot> getOverviewdate(String sessionName) {
    print(userId.value.toString());
    return _firebaseFirestore
        .collection('attendify')
        .doc('Attandance')
        .collection(CalendarUtils.getCurrentYear().toString())
        .doc(CalendarUtils.getCurrentMonthName())
        .collection(CalendarUtils.getCurrentDate().toString())
        .doc('userAttandance')
        .collection(userId.value.toString())
        .doc(sessionName.toString())
        .get();
  }

  Future<String> getUsernameFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStrings.storageUserId.toString()) ?? '';
  }

  // fetchTheRecentActivity() async {
  //   await _firebaseFirestore
  //       .collection('attendify')
  //       .doc('recentActivity')
  //       .collection('25-8-2025')
  //       .get()
  //       .then(
  //     (value) {
  //       print(value.docs
  //               .where((doc) => doc['personId'] == userId.value)
  //               .first
  //               .data()['personId'] ??
  //           'No Data Found');
  //     },
  //   );
  // }

  Future<Map<String, dynamic>?> fetchTheRecentActivity() {
    return _firebaseFirestore
        .collection('attendify')
        .doc('recentActivity')
        .collection('userActivities')
        .where('personId', isEqualTo: userId.value.toString())
        .orderBy('timestamp', descending: true)
        .limit(1) // Add this to only get the most recent document
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final recentDoc = querySnapshot.docs.first;
        return {
          'id': recentDoc.id,
          'data': recentDoc.data(),
          'timestamp': recentDoc.data()['timestamp'],
        };
      }
      return null; // No matching document found
    }).catchError((error) {
      print('Error fetching recent activity: $error');
      throw error; // Re-throw to let FutureBuilder handle the error
    });
  }

  @override
  onInit() {
    super.onInit();
    getUserData();
  }
}
