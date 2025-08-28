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

// class UserRecentActivitiesScreen extends StatefulWidget {
//   String username;
//   UserRecentActivitiesScreen({super.key, required this.username});

//   @override
//   State<UserRecentActivitiesScreen> createState() =>
//       _UserRecentActivitiesScreenState();
// }

// class _UserRecentActivitiesScreenState
//     extends State<UserRecentActivitiesScreen> {
//   FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldDark,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             pinned: true, //pined the app bar at the top
//             floating: true,
//             centerTitle: true,
//             expandedHeight: 120.0,
//             // toolbarHeight: 120,
//             backgroundColor: AppColors.scaffoldDark,
//             automaticallyImplyLeading: false,
//             // pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {},
//                           child: CircleAvatar(
//                             backgroundColor: AppColors.iconbgColor,
//                             child: Icon(
//                               Icons.replay_circle_filled_rounded,
//                               color: AppColors.iconDark,
//                               size: 25,
//                             ),
//                           ).paddingOnly(right: 8.0),
//                         ),
//                         CircleAvatar(
//                           backgroundColor: AppColors.iconbgColor,
//                           child: Icon(
//                             Icons.person,
//                             color: AppColors.iconDark,
//                             size: 25,
//                           ),
//                         ),
//                       ],
//                     ).paddingOnly(top: 40, bottom: 10),
//                     Text(
//                       'Consistency Creates Excellence" 🔁⭐',
//                       style: AppTextStyles.customText(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w100,
//                         color: AppColors.textPrimaryDark.withOpacity(0.6),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               title: Text(
//                 'Recent Activities',
//                 style: AppTextStyles.customText(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w100,
//                   color: AppColors.textPrimaryDark.withOpacity(0.6),
//                 ),
//               ).paddingOnly(left: 10),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               height: Get.height,
//               decoration: BoxDecoration(
//                   color: AppColors.scafoldSecondaryColor.withOpacity(0.3),
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30))),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'This Month',
//                     style: AppTextStyles.customTextbolddark14(),
//                   ).paddingOnly(top: 30),
//                   Expanded(
//                       child: StreamBuilder(
//                     stream: _firebaseFirestore
//                         .collection('attendify')
//                         .doc('recentActivity')
//                         .collection('userActivities')
//                         .orderBy('timestamp', descending: true)
//                         .where('personId',
//                             isEqualTo: widget.username.toString())
//                         .where('Month',
//                             isEqualTo: CalendarUtils.getCurrentMonthName())
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Column(
//                           children: List.generate(
//                             4,
//                             (index) {
//                               return CustomSkeletonizerWidget(
//                                       child: recentActivityLoading())
//                                   .paddingOnly(bottom: 10, top: 5);
//                             },
//                           ),
//                         );
//                       }
//                       if (snapshot.hasError) {
//                         return Container(
//                           width: Get.width,
//                           height: Get.height,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.cloud_off_outlined,
//                                 color: Colors.white.withOpacity(0.5),
//                                 size: 40,
//                               ),
//                               Text(
//                                 'Internet Connection Error',
//                                 style: AppTextStyles.customText(
//                                     color: Colors.white.withOpacity(0.5)),
//                               ).paddingOnly(top: 10, bottom: 20),
//                             ],
//                           ),
//                         );
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return Container(
//                           width: Get.width,
//                           height: Get.height,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.cloud_off_outlined,
//                                 color: Colors.white.withOpacity(0.5),
//                                 size: 40,
//                               ),
//                               Text(
//                                 'No Data Found',
//                                 style: AppTextStyles.customText(
//                                     color: Colors.white.withOpacity(0.5)),
//                               ).paddingOnly(top: 10, bottom: 20),
//                             ],
//                           ),
//                         );
//                       }
//                       // Handle the data from the stream
//                       // final activities = snapshot.data;
//                       return ListView.builder(
//                         itemCount: snapshot.data?.docs.length ?? 0,
//                         itemBuilder: (context, activityindex) {
//                           final activity = snapshot.data?.docs[activityindex];
//                           final date =
//                               ' ${activity?['DayName']},${activity?['Date']} ${activity?['Month']} ${activity?['Year']}';
//                           final time = activity?['Time'] ?? '';
//                           final amOrPm = activity?['AmPm'] ?? '';
//                           final sessionName = activity?['sessionName'] ?? '';

//                           return Column(
//                             children: [
//                               recentActivityListWidget(sessionName,
//                                       date.toString(), time, amOrPm)
//                                   .paddingOnly(bottom: 5),
//                               recentActivityListWidget(sessionName,
//                                       date.toString(), time, amOrPm)
//                                   .paddingOnly(bottom: 5),
//                               recentActivityListWidget(sessionName,
//                                       date.toString(), time, amOrPm)
//                                   .paddingOnly(bottom: 5),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   )),
//                 ],
//               ).paddingOnly(left: 20, right: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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

class UserRecentActivitiesScreen extends StatefulWidget {
  String username;
  UserRecentActivitiesScreen({super.key, required this.username});

  @override
  State<UserRecentActivitiesScreen> createState() =>
      _UserRecentActivitiesScreenState();
}

class _UserRecentActivitiesScreenState
    extends State<UserRecentActivitiesScreen> {
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
                'Recent Activities',
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
                .doc('recentActivity')
                .collection('userActivities')
                .orderBy('timestamp', descending: true)
                .where('personId', isEqualTo: widget.username.toString())
                .where('Month', isEqualTo: CalendarUtils.getCurrentMonthName())
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
                              'This Month',
                              style: AppTextStyles.customTextbolddark14(),
                            ).paddingOnly(
                                top: 30, left: 20, right: 20, bottom: 20),
                          recentActivityListWidget(
                            sessionName,
                            date.toString(),
                            time,
                            amOrPm,
                          ).paddingOnly(bottom: 10, left: 20, right: 20),
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
