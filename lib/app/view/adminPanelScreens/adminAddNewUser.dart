import 'package:attendify/app/custom_widget/custom_button_widget.dart';
import 'package:attendify/app/custom_widget/custom_text_field.dart';
import 'package:attendify/app/res/appTextStyles.dart';
import 'package:attendify/app/res/app_assets.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:attendify/app/view/adminPanelScreens/adminLoginScreen.dart';
import 'package:attendify/app/view_model/admin_view_models/admin_addUser_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AdminAddNewUser extends StatefulWidget {
  const AdminAddNewUser({super.key});

  @override
  State<AdminAddNewUser> createState() => _AdminAddNewUserState();
}

class _AdminAddNewUserState extends State<AdminAddNewUser> {
  AdminAdduserViewmodel adminAddusercontroller =
      Get.put(AdminAdduserViewmodel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appbarcolor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Add New User",
          style: AppTextStyles.customTextbolddark14(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Obx(
              () => GestureDetector(
                onTap: () => adminAddusercontroller.imagePicker(context),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor:
                      Colors.grey[200], // Background color when no image
                  backgroundImage: adminAddusercontroller.selectedImage.value !=
                          null
                      ? FileImage(adminAddusercontroller.selectedImage.value!)
                      : null,
                  child: adminAddusercontroller.selectedImage.value == null
                      ? Icon(Icons.add_a_photo)
                      : null,
                ).paddingOnly(top: 10, bottom: 10),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CustomTextFieldWidget(
                    traillingIcon: Icons.person,
                    controller: adminAddusercontroller.nameControler,
                    hintText: "E.g Usama Ali",
                    labeltext: "Name")
                .paddingSymmetric(vertical: 5),
            CustomTextFieldWidget(
                    traillingIcon: Icons.person,
                    controller: adminAddusercontroller.userNameController,
                    hintText: "E.g UsamaAli007",
                    labeltext: "Username")
                .paddingSymmetric(vertical: 5),
            CustomTextFieldWidget(
                    traillingIcon: Icons.lock,
                    controller: adminAddusercontroller.passwordController,
                    hintText: "e.g Usama%1234",
                    labeltext: "Password")
                .paddingSymmetric(vertical: 5),
            SizedBox(
              height: 20,
            ),
            Obx(
              () {
                return CustomButtonWidget(
                  text: adminAddusercontroller.isadding.value
                      ? 'Adding User...'
                      : 'Add User',
                  onPressed: () {
                    adminAddusercontroller.fieldValidation(context);
                  },
                  isProcessing: adminAddusercontroller.isadding.value,
                  message: adminAddusercontroller.addingMessage.value,
                );
              },
            )
          ],
        ).paddingSymmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}
