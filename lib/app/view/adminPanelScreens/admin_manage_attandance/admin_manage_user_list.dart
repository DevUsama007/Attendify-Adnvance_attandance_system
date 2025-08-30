import 'package:attendify/app/view/adminPanelScreens/admin_manage_attandance/admin_manage_attandance_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../custom_widget/custom_skeletonizer_widget.dart';
import '../../../custom_widget/user_homeScreen_widgets/recent_activity_loading_widget.dart';
import '../../../res/appTextStyles.dart';
import '../../../res/app_colors.dart';
import '../admin_view_user_screen.dart';

class AdminManageUserList extends StatefulWidget {
  const AdminManageUserList({super.key});

  @override
  State<AdminManageUserList> createState() => _AdminManageUserListState();
}

class _AdminManageUserListState extends State<AdminManageUserList> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            centerTitle: true,
            expandedHeight: 120.0,
            backgroundColor: AppColors.scaffoldDark,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {});
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.iconbgColor,
                            child: Icon(
                              Icons.replay_circle_filled_rounded,
                              color: AppColors.iconDark,
                              size: 25,
                            ),
                          ).paddingOnly(right: 8.0),
                        ),
                      ],
                    ).paddingOnly(top: 40, bottom: 10),
                    Text(
                      'Consistency Creates Excellence" 🔁⭐',
                      style: AppTextStyles.customText(
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                        color: AppColors.textPrimaryDark.withOpacity(0.6),
                      ),
                    )
                  ],
                ),
              ),
              title: Text(
                'All Employees',
                style: AppTextStyles.customText(
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                  color: AppColors.textPrimaryDark.withOpacity(0.6),
                ),
              ).paddingOnly(left: 10),
            ),
          ),
          // Use SliverList instead of SliverToBoxAdapter for scrollable content
          StreamBuilder(
            stream: _firebaseFirestore
                .collection('attendify')
                .doc('UserData')
                .collection('userCradentials')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return CustomSkeletonizerWidget(
                        child: recentActivityLoading(),
                      ).paddingOnly(bottom: 10, top: 5);
                    },
                    childCount: 4,
                  ),
                );
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: Get.height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off_outlined,
                          color: Colors.white.withOpacity(0.5),
                          size: 40,
                        ),
                        Text(
                          'Internet Connection Error',
                          style: AppTextStyles.customText(
                              color: Colors.white.withOpacity(0.5)),
                        ).paddingOnly(top: 10, bottom: 20),
                      ],
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: Get.height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white.withOpacity(0.5),
                          size: 40,
                        ),
                        Text(
                          'No User Found',
                          style: AppTextStyles.customText(
                              color: Colors.white.withOpacity(0.5)),
                        ).paddingOnly(top: 10, bottom: 20),
                      ],
                    ),
                  ),
                );
              }

              final employees = snapshot.data!.docs;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final employeeData = employees[index];
                    final name = employeeData['name'] ?? '';
                    final username = employeeData['userName'] ?? '';
                    final password = employeeData['password'] ?? '';

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.scafoldSecondaryColor.withOpacity(0.3),
                        borderRadius: index == 0
                            ? BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )
                            : BorderRadius.only(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Text(
                              'Total Employees(${employees.length})',
                              style: AppTextStyles.customTextbolddark14(),
                            ).paddingOnly(top: 10, left: 20, right: 20),
                          InkWell(
                            onTap: () {
                              Get.to(() => AdminManageAttandanceList(
                                  username: username,name: name,));
                            },
                            child: userViewWidget(username, name, password)
                                .paddingOnly(left: 20, right: 20, top: 20),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: employees.length,
                ),
              );
            },
          ),
          SliverFillRemaining(
            child: Container(
              width: Get.width,
              height: Get.height,
              color: AppColors.scafoldSecondaryColor.withOpacity(0.3),
              child: Center(
                child: Text(
                  'No More Employees',
                  style: AppTextStyles.customTextbolddark14(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
