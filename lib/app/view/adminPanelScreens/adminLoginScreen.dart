import 'package:attendify/app/custom_widget/custom_button_widget.dart';
import 'package:attendify/app/custom_widget/custom_text_field.dart';
import 'package:attendify/app/res/appTextStyles.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:attendify/app/res/app_string.dart';
import 'package:attendify/app/res/app_assets.dart';
import 'package:attendify/app/utils/notificatinoUtils.dart';
import 'package:attendify/app/view_model/admin_view_models/admin_login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/routes/routes_name.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  AdminLoginViewModel adminloginController = Get.put(AdminLoginViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            child: SvgPicture.asset(
              AppAssets.attendifyLogo,
              width: 220,
              height: 220,
            ),
            top: 120,
            left: 70,
          ),
          Positioned(
            child: Text(
              AppStrings.welcomeMessage,
              style: AppTextStyles.customText(
                  fontSize: 14, fontWeight: FontWeight.bold),
            ),
            top: 245,
            left: 110,
          ),
          Positioned(
            child: Text(
              AppStrings.welcomenote,
              style: AppTextStyles.customTextbolddark12(),
            ),
            top: 270,
            left: 110,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFieldWidget(
                  controller: adminloginController.userNameController,
                  hintText: 'E.g. john_doe',
                  labeltext: 'UserName',
                  traillingIcon: Icons.person,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextFieldWidget(
                  controller: adminloginController.passwordController,
                  hintText: 'E.g. password@123',
                  labeltext: 'Password',
                  traillingIcon: Icons.remove_red_eye_rounded,
                  ontraillingtap: () {
                    print('object');
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    return CustomButtonWidget(
                      text: "Login",
                      isProcessing: adminloginController.isLoading.value,
                      onPressed: () {
                        adminloginController.fieldAuthentication(context);
                      },
                    );
                  },
                )
              ],
            ).paddingOnly(top: 380, left: 20, right: 20),
          )
        ],
      ),
    );
  }
}
