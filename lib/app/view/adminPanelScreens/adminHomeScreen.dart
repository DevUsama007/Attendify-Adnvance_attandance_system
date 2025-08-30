import 'package:attendify/app/custom_widget/custom_bottom_sheet.dart';
import 'package:attendify/app/custom_widget/custom_button_widget.dart';
import 'package:attendify/app/custom_widget/logout_widget.dart';
import 'package:attendify/app/res/appTextStyles.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:attendify/app/res/routes/routes_name.dart';
import 'package:attendify/app/view/adminPanelScreens/admin_view_recent_activites.dart';
import 'package:attendify/app/view_model/admin_view_models/admin_homepage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widget/admin_function_widget.dart';
import '../../custom_widget/custom_skeletonizer_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/recent_activity_error_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/recent_activity_loading_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/recent_activity_widget.dart';
import '../../utils/calendar_utils.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  AdminHomepageViewModel _homeController = Get.put(AdminHomepageViewModel());
  List<String> adminFunctions = [
    "Add Users",
    "View Attendance",
    "Today Report",
    "View Users"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldDark,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true, //pined the app bar at the top
              floating: true,
              centerTitle: true,
              expandedHeight: 120.0,
              // toolbarHeight: 120,
              backgroundColor: AppColors.scaffoldDark,
              automaticallyImplyLeading: false,
              // pinned: true,
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
                              Get.to(() => AdminRecentActivitiesScreen(
                                  pageTitle: 'Notifications'));
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.iconbgColor,
                              child: Icon(
                                Icons.notifications,
                                color: AppColors.iconDark,
                                size: 25,
                              ),
                            ).paddingOnly(right: 8.0),
                          ),
                          InkWell(
                            onTap: () {
                              CustomBottomSheet.show(
                                  height: 200,
                                  context: context,
                                  child: logoutWidget(
                                    () {
                                      _homeController.logoutAdmin();
                                    },
                                    () {
                                      Navigator.pop(context);
                                    },
                                  ));
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.iconbgColor,
                              child: Icon(
                                Icons.person,
                                color: AppColors.iconDark,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 40, bottom: 10),
                      Text(
                        'Time to do what you do best',
                        style: AppTextStyles.customText(
                          fontSize: 12,
                          fontWeight: FontWeight.w100,
                          color: AppColors.textPrimaryDark.withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
                ),
                title: Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "What's up! ${_homeController.adminName.value.toString()}",
                      style: AppTextStyles.customTextbolddark14(),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: Get.height * 0.9,
                decoration: BoxDecoration(
                    color: AppColors.scafoldSecondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "OverView",
                          style: AppTextStyles.customTextbolddark14(),
                        ).paddingOnly(left: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(CalendarUtils.getFormattedTodayDate(),
                                  style: AppTextStyles.customText(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100))
                              .marginSymmetric(horizontal: 10, vertical: 5),
                        ),
                      ],
                    ).paddingOnly(bottom: 10),
                    Wrap(
                      children: List.generate(
                          _homeController.adminOptions.length, (index) {
                        return AdminFunctionWidget(
                          "${_homeController.adminOptions[index]}",
                          () {
                            index == 0
                                ? Get.toNamed(RouteName.adminAddNewUser)
                                : index == 1
                                    ? Get.toNamed(RouteName.adminViewUserScreen)
                                    : index == 2
                                        ? Get.toNamed(
                                            RouteName.adminManageUserList)
                                        : index == 3
                                            ? Get.toNamed(RouteName
                                                .adminTodayReportScreen)
                                            : null;
                          },
                        ).paddingSymmetric(horizontal: 10, vertical: 10);
                      }),
                    ).paddingOnly(left: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Activity",
                          style: AppTextStyles.customTextbolddark14(),
                        ).paddingOnly(left: 10),
                        InkWell(
                          onTap: () {
                            Get.to(() => AdminRecentActivitiesScreen(
                                pageTitle: 'Recent Activities'));
                          },
                          child: Text(
                            "view all",
                            style: AppTextStyles.customTextbolddark14(),
                          ).paddingOnly(right: 10),
                        )
                      ],
                    ).paddingOnly(top: 10),
                    FutureBuilder<Map<String, dynamic>?>(
                      future: _homeController.fetchTheRecentActivity(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CustomSkeletonizerWidget(
                                  child: recentActivityLoading())
                              .paddingOnly(top: 10);
                        }

                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                          return recentActivityError('Internet Error')
                              .paddingOnly(top: 10);
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return recentActivityError('No Today Activity')
                              .paddingOnly(top: 10);
                        }

                        final activityData = snapshot.data!;

                        return AdminRecentActivityListWidget(
                                activityData['data']['personName'],
                                activityData['data']['personId'],
                                '${activityData['data']['DayName']},${activityData['data']['Date']},${activityData['data']['Month']},${activityData['data']['Year']}',
                                activityData['data']['Time'],
                                activityData['data']['AmPm'],
                                activityData['data']['sessionName'])
                            .paddingOnly(top: 10);
                      },
                    )
                  ],
                ).marginSymmetric(horizontal: 10, vertical: 20),
              ).marginSymmetric(horizontal: 15),
            ),
            // SliverFillRemaining()
          ],
        ));
  }
}
