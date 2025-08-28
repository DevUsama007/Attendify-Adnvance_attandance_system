import 'package:attendify/app/custom_widget/custom_skeletonizer_widget.dart';
import 'package:attendify/app/custom_widget/user_homeScreen_widgets/overview_widget.dart';
import 'package:attendify/app/custom_widget/user_homeScreen_widgets/recent_activity_error_widget.dart';
import 'package:attendify/app/custom_widget/user_homeScreen_widgets/recent_activity_loading_widget.dart';
import 'package:attendify/app/custom_widget/user_homeScreen_widgets/recent_activity_widget.dart';
import 'package:attendify/app/res/app_colors.dart';
import 'package:attendify/app/utils/calendar_utils.dart';
import 'package:attendify/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widget/user_homeScreen_widgets/empty_overview_widget.dart';
import '../../custom_widget/user_homeScreen_widgets/error_overview_widget.dart';
import '../../res/appTextStyles.dart';
import '../../res/app_assets.dart';
import 'admin_view_recent_activites.dart';

class AdminTodayReportScreen extends StatefulWidget {
  AdminTodayReportScreen({super.key});

  @override
  State<AdminTodayReportScreen> createState() => _AdminTodayReportScreenState();
}

class _AdminTodayReportScreenState extends State<AdminTodayReportScreen> {
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
                      '${CalendarUtils.getCurrentDayName()} ${CalendarUtils.getCurrentDate()},${CalendarUtils.getCurrentMonthName()} ${CalendarUtils.getCurrentYear()} 🔁⭐',
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
                'Today Report',
                style: AppTextStyles.customText(
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                  color: AppColors.textPrimaryDark.withOpacity(0.6),
                ),
              ).paddingOnly(left: 13),
            ),
          ),

          // Main content
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
                          'No Activities This Month',
                          style: AppTextStyles.customText(
                              color: Colors.white.withOpacity(0.5)),
                        ).paddingOnly(top: 10, bottom: 20),
                      ],
                    ),
                  ),
                );
              }

              final data = snapshot.data!.docs;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final userData = data[index];

                    final username = userData['userName'] ?? '';

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
                          Container(
                            width: Get.width,
                            height: 165,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(AppAssets.bgImage2)),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Employee Name: ",
                                      style: AppTextStyles.customText(
                                          color: AppColors.iconColor,
                                          fontSize: 15),
                                    ),
                                    FutureBuilder(
                                      future: _firebaseFirestore
                                          .collection('attendify')
                                          .doc('UserData')
                                          .collection('userCradentials')
                                          .doc(username.toString())
                                          .get(),
                                      builder: (context, usernameSnapshot) {
                                        if (usernameSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                            'fetching',
                                            style: AppTextStyles.customText(
                                                color: AppColors.iconColor
                                                    .withOpacity(0.6),
                                                fontSize: 15),
                                          );
                                        }
                                        if (usernameSnapshot.hasError) {
                                          return Text(
                                            'Error Occur',
                                            style: AppTextStyles.customText(
                                                color: AppColors.iconColor
                                                    .withOpacity(0.6),
                                                fontSize: 15),
                                          );
                                        }
                                        if (!usernameSnapshot.hasData) {
                                          return Text(
                                            'Not Found',
                                            style: AppTextStyles.customText(
                                                color: AppColors.iconColor
                                                    .withOpacity(0.6),
                                                fontSize: 15),
                                          );
                                        }
                                        return Text(
                                          usernameSnapshot.data!['name'],
                                          style: AppTextStyles.customText(
                                              color: AppColors.iconColor,
                                              fontSize: 15),
                                        );
                                      },
                                    )
                                  ],
                                ).paddingOnly(left: 10, top: 5, bottom: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FutureBuilder(
                                      future: _firebaseFirestore
                                          .collection('attendify')
                                          .doc('Attandance')
                                          .collection(
                                              CalendarUtils.getCurrentYear()
                                                  .toString())
                                          .doc(CalendarUtils
                                                  .getCurrentMonthName()
                                              .toString())
                                          .collection(CalendarUtils
                                                  .getCurrentDate()
                                              .toString()) // Use current date, not hardcoded '24'
                                          .doc('userAttandance')
                                          .collection(username)
                                          .doc('Check In')
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CustomSkeletonizerWidget(
                                              child: emptyOverviewWidget(
                                                  () {}, ''));
                                        }
                                        if (snapshot.hasError) {
                                          return errorOverviewWidget();
                                        }
                                        if (!snapshot.hasData ||
                                            !snapshot.data!.exists) {
                                          return emptyOverviewWidget(
                                              () {}, 'Check In');
                                        }
                                        final documentData = snapshot.data!
                                            .data() as Map<String, dynamic>;
                                        return overviewWidget(
                                            () {},
                                            "Check In",
                                            documentData['checkInTime'] ??
                                                "--:--",
                                            documentData['checkInAmPm'] ?? "",
                                            'In');
                                      },
                                    ),
                                    //show the check out data here
                                    FutureBuilder(
                                      future: _firebaseFirestore
                                          .collection('attendify')
                                          .doc('Attandance')
                                          .collection(
                                              CalendarUtils.getCurrentYear()
                                                  .toString())
                                          .doc(CalendarUtils
                                                  .getCurrentMonthName()
                                              .toString())
                                          .collection(CalendarUtils
                                                  .getCurrentDate()
                                              .toString()) // Use current date, not hardcoded '24'
                                          .doc('userAttandance')
                                          .collection(username)
                                          .doc('Check Out')
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CustomSkeletonizerWidget(
                                              child: emptyOverviewWidget(
                                                  () {}, ''));
                                        }
                                        if (snapshot.hasError) {
                                          return errorOverviewWidget();
                                        }
                                        if (!snapshot.hasData ||
                                            !snapshot.data!.exists) {
                                          return emptyOverviewWidget(
                                              () {}, 'Check In');
                                        }
                                        final documentData = snapshot.data!
                                            .data() as Map<String, dynamic>;
                                        return overviewWidget(
                                            () {},
                                            "Check Out",
                                            documentData['checkOutTime'] ??
                                                "--:--",
                                            documentData['checkOUtAmPm'] ??
                                                "pm",
                                            'In');
                                      },
                                    ),
                                  ],
                                ).paddingOnly(bottom: 5, left: 10, right: 10),
                              ],
                            ),
                          ).paddingOnly(left: 10, right: 10, bottom: 10),
                        ],
                      ),
                    );
                  },
                  childCount: data.length,
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
                  'No More Record',
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

Widget AdminTodayReportWidget({
  required String userName,
  required String chkInAmPm,
  required String chkInDate,
  required String chkInDay,
  required String chkInMonth,
  required String chkInTime,
  required String chkInYear,
  required String chkOutAmPm,
  required String chkOutDate,
  required String chkOutDay,
  required String chkOutMonth,
  required String chkOutTime,
  required String chkOutYear,
}) {
  return Container(
    width: Get.width,
    height: 165,
    decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage(AppAssets.bgImage2)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Employee Name: ",
              style: AppTextStyles.customText(
                  color: AppColors.iconColor, fontSize: 15),
            ),
            Text(
              'Usama Jutt',
              style: AppTextStyles.customText(
                  color: AppColors.iconColor, fontSize: 15),
            ),
          ],
        ).paddingOnly(left: 10, top: 5, bottom: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            overviewWidget(() {}, "Check In", "09:12", 'Am', 'In'),
          ],
        ).paddingOnly(bottom: 5, left: 5, right: 5),
      ],
    ),
  );
}


  // overviewWidget(() {}, "Check Out", "09:12", 'Am', 'Out')