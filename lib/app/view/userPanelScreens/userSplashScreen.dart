import 'package:attendify/app/res/app_colors.dart';
import 'package:attendify/app/res/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../res/appTextStyles.dart';
import '../../res/app_string.dart';
import '../../view_model/admin_view_models/admin_splash_screen_services.dart';

class UserSplashScreen extends StatefulWidget {
  const UserSplashScreen({super.key});

  @override
  State<UserSplashScreen> createState() => _UserSplashScreenState();
}

class _UserSplashScreenState extends State<UserSplashScreen> {
  SplashScreenServices _controler = Get.put(SplashScreenServices());
  @override
  void initState() {
    super.initState();
    _controler.userSplashDelayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.attendifyLogo2,
                width: 100,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  AppStrings.appName,
                  style: AppTextStyles.customTextbolddark20(),
                ),
              ),
              Transform.scale(
                scale: 0.3,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: [
                    Colors.white,
                  ],
                  // backgroundColor: AppColors.iconColor,
                  strokeWidth: 0.9,
                ),
              )
            ],
          ),
        ),
      ).paddingOnly(top: 250),
    );
  }
}
