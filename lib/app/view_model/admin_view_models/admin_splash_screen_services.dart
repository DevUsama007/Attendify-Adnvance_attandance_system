import 'package:attendify/app/res/app_string.dart';
import 'package:get/get.dart';

import '../../res/routes/routes_name.dart';
import '../../services/noitfication_services/notification_services.dart';
import '../../services/noitfication_services/send_notifcation_service.dart';
import '../../utils/storage_utils.dart';

class SplashScreenServices extends GetxController {
  NotificationServices _notificationServices = NotificationServices();
  late var user_id;
  splashDelayer() {
    // _notificationServices.getDeviceToken().then(
    //   (value) async {
    //     print('Deviev token :${value}');
    //     await SendNotificationService.sendNotificationService(
    //         // value.toString(),
    //         'chXGsu6uToKyMzt3AZgMDg:APA91bGsGYQtSnG585hdtTwAoXBEBXUNZ7n0toSw0nH23DFMleJYK1AvvjDYFB1g2oeSsPm47Q2fW6BFNQwUp79YOMKKXi7VrYjTPF7tFgqIAnTgIPkufP0',
    //         "Usama Notification",
    //         "I am here for coding",
    //         {'screen': "Cart Screen", 'type': "dumy"});
    //     // print('Device token');
    //     // print(value);
    //   },
    // );
    // print('object');
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
