import 'package:get/get.dart';

import '../../res/routes/routes_name.dart';

class SplashScreenServices extends GetxController {
  late var user_id;
  splashDelayer() {
    print('object');
    Future.delayed(Duration(seconds: 3), () async {
      Get.toNamed(RouteName.adminLoginScreen);
      // user_id = await StorageService.read('user_id');
      // print(user_id);
      // if (user_id == null || user_id == '') {
      //   Get.offNamed(RouteName.loginScreenView);
      // } else {
      //   Get.offNamed(RouteName.bottomnavigationbarscreen);
      // }
    });
  }

  userSplashDelayer() {
    Future.delayed(Duration(seconds: 3), () async {
      Get.toNamed(RouteName.userLoginScreen);
      // user_id = await StorageService.read('user_id');
      // print(user_id);
      // if (user_id == null || user_id == '') {
      //   Get.offNamed(RouteName.loginScreenView);
      // } else {
      //   Get.offNamed(RouteName.bottomnavigationbarscreen);
      // }
    });
  }
}
