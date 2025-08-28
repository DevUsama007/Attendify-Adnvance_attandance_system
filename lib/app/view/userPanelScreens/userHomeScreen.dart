import 'package:attendify/app/custom_widget/custom_skeletonizer_widget.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:attendify/app/view/userPanelScreens/user_recent_activities_screen.dart';
import 'package:attendify/app/view_model/user_panel_view_models/user_homepage_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../custom_widget/user_homeScreen_widgets/empty_overview_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/error_overview_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/overview_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/recent_activity_error_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/recent_activity_loading_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/recent_activity_widget.dart';
import '../../res/appTextStyles.dart';
import '../../res/app_assets.dart';
import '../../res/routes/routes_name.dart';
import '../../utils/calendar_utils.dart';
import 'checkUserLocationScreen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  UserHomepageViewModel homepageController = Get.put(UserHomepageViewModel());
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homepageController.getUserData();
  }

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
                        CircleAvatar(
                          backgroundColor: AppColors.iconbgColor,
                          child: Icon(
                            Icons.notifications,
                            color: AppColors.iconDark,
                            size: 25,
                          ),
                        ).paddingOnly(right: 8.0),
                        CircleAvatar(
                          backgroundColor: AppColors.iconbgColor,
                          child: Icon(
                            Icons.person,
                            color: AppColors.iconDark,
                            size: 25,
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
                    "What's up! ${homepageController.name.value.toString()}",
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
                            color: AppColors.scaffoldDark,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: AppColors.iconDark,
                              size: 20,
                            ).paddingOnly(left: 10),
                            Text(CalendarUtils.getFormattedTodayDate(),
                                    style: AppTextStyles.customText(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w100))
                                .marginSymmetric(horizontal: 10, vertical: 5),
                          ],
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<String>(
                          future: homepageController
                              .getUsernameFromSharedPreferences(),
                          builder: (context, usernameSnapshot) {
                            // Handle username loading states
                            if (usernameSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CustomSkeletonizerWidget(
                                  child: emptyOverviewWidget(() {}, ''));
                            }

                            if (usernameSnapshot.hasError) {
                              return errorOverviewWidget();
                            }

                            final username = usernameSnapshot.data;
                            if (username == null || username.isEmpty) {
                              return Center(child: Text('Please login first'));
                            }
                            return FutureBuilder(
                              future: homepageController
                                  .getOverviewdate('Check In'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CustomSkeletonizerWidget(
                                      child: emptyOverviewWidget(() {}, ''));
                                }
                                if (snapshot.hasError) {
                                  return errorOverviewWidget();
                                }
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return emptyOverviewWidget(() {
                                    Get.to(
                                      () => CheckUserLocationScreen(
                                          btn_text: 'Check In'),
                                      transition: Transition.leftToRight,
                                    );
                                  }, 'Check In');
                                }
                                // Get the document data
                                // documentData['name']
                                final documentData = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                return overviewWidget(() {
                                  Get.to(
                                    () => CheckUserLocationScreen(
                                        btn_text: 'Check In'),
                                    transition: Transition.leftToRight,
                                  );
                                },
                                    'Check In',
                                    documentData['checkInTime'] ?? "--:--",
                                    documentData['checkInAmPm'] ?? "",
                                    'In');
                              },
                            );
                          }),
                      FutureBuilder<String>(
                          future: homepageController
                              .getUsernameFromSharedPreferences(),
                          builder: (context, usernameSnapshot) {
                            // Handle username loading states
                            if (usernameSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CustomSkeletonizerWidget(
                                  child: emptyOverviewWidget(() {}, ''));
                              ;
                            }

                            if (usernameSnapshot.hasError) {
                              return errorOverviewWidget();
                            }

                            final username = usernameSnapshot.data;
                            if (username == null || username.isEmpty) {
                              return Center(child: Text('Please login first'));
                            }
                            return FutureBuilder(
                              future: homepageController
                                  .getOverviewdate('Check Out'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CustomSkeletonizerWidget(
                                      child: emptyOverviewWidget(() {}, ''));
                                }
                                if (snapshot.hasError) {
                                  return errorOverviewWidget();
                                }
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return emptyOverviewWidget(() {
                                    Get.to(
                                      () => CheckUserLocationScreen(
                                          btn_text: 'Check Out'),
                                      transition: Transition.leftToRight,
                                    );
                                  }, 'Check Out');
                                }
                                // Get the document data
                                // documentData['name']
                                final documentData = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                return overviewWidget(() {
                                  Get.to(
                                    () => CheckUserLocationScreen(
                                        btn_text: 'Check Out'),
                                    transition: Transition.leftToRight,
                                  );
                                }, 'Check Out', documentData['checkOutTime'],
                                    documentData['checkOUtAmPm'], 'Out');
                              },
                            );
                          }),
                    ],
                  ).paddingSymmetric(vertical: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Activity",
                        style: AppTextStyles.customTextbolddark14(),
                      ).paddingOnly(left: 10),
                      InkWell(
                        onTap: () => Get.to(() => UserRecentActivitiesScreen(
                            username: homepageController.userId.toString())),
                        child: Text(
                          "view all",
                          style: AppTextStyles.customTextbolddark14(),
                        ).paddingOnly(right: 10),
                      )
                    ],
                  ).paddingOnly(top: 10),
                  //recent activity code started here
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<String>(
                      future:
                          homepageController.getUsernameFromSharedPreferences(),
                      builder: (context, usernameSnapshot) {
                        // Handle username loading states
                        if (usernameSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CustomSkeletonizerWidget(
                              child: recentActivityLoading());
                        }

                        if (usernameSnapshot.hasError) {
                          return recentActivityError('No Internet');
                        }

                        final username = usernameSnapshot.data;
                        if (username == null || username.isEmpty) {
                          return Center(child: Text('Please login first'));
                        }
                        return FutureBuilder<Map<String, dynamic>?>(
                          future: homepageController.fetchTheRecentActivity(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CustomSkeletonizerWidget(
                                  child: recentActivityLoading());
                            }

                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                              return recentActivityError('Internet Error');
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return recentActivityError('No Recent Activity');
                            }

                            final activityData = snapshot.data!;
                            print(activityData);
                            print(
                                'sessionName: ${activityData['data']['sessionName']}');
                            return recentActivityWidget(
                                activityData['data']['sessionName'],
                                '${activityData['data']['DayName']},${activityData['data']['Date']},${activityData['data']['Month']},${activityData['data']['Year']}',
                                activityData['data']['Time'],
                                activityData['data']['AmPm'],
                                activityData['data']['sessionName']);
                          },
                        );
                      }),
                ],
              ).marginSymmetric(horizontal: 10, vertical: 20),
            ).marginSymmetric(horizontal: 15),
          ),
        ],
      ),
    );
  }
}
