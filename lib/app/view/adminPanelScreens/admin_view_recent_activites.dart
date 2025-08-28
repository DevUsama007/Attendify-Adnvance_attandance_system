import 'package:attendify/app/custom_widget/custom_skeletonizer_widget.dart';
import 'package:attendify/app/custom_widget/user_homeScreen_widgets/recent_activity_error_widget.dart';
import 'package:attendify/app/custom_widget/user_homeScreen_widgets/recent_activity_loading_widget.dart';
import 'package:attendify/app/custom_widget/user_homeScreen_widgets/recent_activity_widget.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:attendify/app/utils/calendar_utils.dart';
import 'package:attendify/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/appTextStyles.dart';
import '../../res/app_assets.dart';

class AdminRecentActivitiesScreen extends StatefulWidget {
  String pageTitle;
  AdminRecentActivitiesScreen({super.key, required this.pageTitle});

  @override
  State<AdminRecentActivitiesScreen> createState() =>
      _AdminRecentActivitiesScreenState();
}

class _AdminRecentActivitiesScreenState
    extends State<AdminRecentActivitiesScreen> {
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
                widget.pageTitle,
                style: AppTextStyles.customText(
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                  color: AppColors.textPrimaryDark.withOpacity(0.6),
                ),
              ).paddingOnly(left: 13),
            ),
          ),
          // Use SliverList instead of SliverToBoxAdapter for scrollable content
          StreamBuilder(
            stream: _firebaseFirestore
                .collection('attendify')
                .doc('recentActivity')
                .collection('userActivities')
                .orderBy('timestamp', descending: true)
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
                          'No Activities This Month',
                          style: AppTextStyles.customText(
                              color: Colors.white.withOpacity(0.5)),
                        ).paddingOnly(top: 10, bottom: 20),
                      ],
                    ),
                  ),
                );
              }

              final activities = snapshot.data!.docs;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final activity = activities[index];
                    final date =
                        '${activity['DayName']}, ${activity['Date']} ${activity['Month']} ${activity['Year']}';
                    final time = activity['Time'] ?? '';
                    final amOrPm = activity['AmPm'] ?? '';
                    final sessionName = activity['sessionName'] ?? '';
                    final name = activity['personName'] ?? '';
                    final username = activity['personId'] ?? '';

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
                          index == 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          AdminRecentActivityListWidget(name, username, date,
                                  time, amOrPm, sessionName)
                              .paddingOnly(bottom: 10, left: 20, right: 20),
                        ],
                      ),
                    );
                  },
                  childCount: activities.length,
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
                  'No More Activities',
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

Widget AdminRecentActivityListWidget(String name, String username, String date,
    String time, String amOrPm, String sessionName) {
  return Container(
    width: Get.width,
    height: 120,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.darken),
            fit: BoxFit.cover,
            image: AssetImage(AppAssets.bgImage2))),
    child: Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.6),
            child: Icon(
              Icons.location_on,
              color: AppColors.iconColor,
            ),
          ),
          title: Text(
            name.toString(),
            style: AppTextStyles.customText(fontSize: 16, color: Colors.white),
          ),
          subtitle: Text(
            date.toString(),
            style: AppTextStyles.customTextdark12(),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.iconColor),
            child: Text(
              sessionName.toString(),
              style: AppTextStyles.customText(fontSize: 11),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${username}: ',
              style: AppTextStyles.customText(
                fontSize: 16,
                color: AppColors.iconColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              time.toString(),
              style: AppTextStyles.customText(fontSize: 30),
            ),
            Text(
              amOrPm.toString(),
              style: AppTextStyles.customText(fontSize: 14),
            ),
          ],
        )
      ],
    ),
  );
}
