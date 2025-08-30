import 'package:attendify/app/res/app_string.dart';
import 'package:attendify/app/utils/calendar_utils.dart';
import 'package:attendify/app/utils/storage_utils.dart';
import 'package:attendify/app/view/adminPanelScreens/adminSplashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminHomepageViewModel extends GetxController {
  RxString adminName = '-------'.obs;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  RxList<String> adminOptions = <String>[
    'Add New User',
    'View Users',
    'Manage Attendance',
    'Today Report'
  ].obs;
  getAdminName() {
    // This method can be used to fetch the admin name from storage or any other source
    StorageService.read(AppStrings.storageAdminName).then((value) {
      if (value != null) {
        adminName.value = value.toString();
      } else {
        adminName.value = '-------';
      }
    });
  }

  logoutAdmin() {
    StorageService.remove(AppStrings.storageAdminId).then(
      (value) {
        Get.offAll(AdminSplashScreen());
      },
    );
  }

  Future<Map<String, dynamic>?> fetchTheRecentActivity() {
    print(
        " Today date ${CalendarUtils.getCurrentDate()} ${CalendarUtils.getCurrentMonthName()} ${CalendarUtils.getCurrentYear()}");
    return _firebaseFirestore
        .collection('attendify')
        .doc('recentActivity')
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .limit(1) // Add this to only get the most recent document
        .get()
        .then((querySnapshot) {
      print(querySnapshot.docs.first);
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
    getAdminName();
  }
}
