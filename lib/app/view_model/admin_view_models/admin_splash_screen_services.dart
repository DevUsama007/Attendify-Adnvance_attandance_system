import 'package:attendify/app/res/app_string.dart';
import 'package:get/get.dart';

import '../../res/routes/routes_name.dart';
import '../../utils/storage_utils.dart';

class SplashScreenServices extends GetxController {
  late var user_id;
  splashDelayer() {
    print('object');
    Future.delayed(Duration(seconds: 3), () async {
      Get.toNamed(RouteName.adminLoginScreen);
      user_id = await StorageService.read(AppStrings.storageAdminId);
      print(user_id);
      if (user_id == null || user_id == '') {
        Get.offAllNamed(RouteName.adminLoginScreen);
      } else {
        Get.offAllNamed(RouteName.adminHomeScreen);
      }
    });
  }

  userSplashDelayer() {
    Future.delayed(Duration(seconds: 3), () async {
      Get.toNamed(RouteName.userLoginScreen);
      user_id = await StorageService.read(AppStrings.storageUserId);
      print(user_id);
      if (user_id == null || user_id == '') {
        Get.offAllNamed(RouteName.userLoginScreen);
      } else {
        Get.offAllNamed(RouteName.userHomeScreen);
      }
    });
  }
}
