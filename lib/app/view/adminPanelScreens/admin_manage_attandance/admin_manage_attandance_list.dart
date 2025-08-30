import 'package:attendify/app/custom_widget/custom_bottom_sheet.dart';
import 'package:attendify/app/custom_widget/custom_button_widget.dart';
import 'package:attendify/app/utils/calendar_utils.dart';
import 'package:attendify/app/view_model/admin_view_models/admin_addUser_viewModel.dart';
import 'package:attendify/app/view_model/user_panel_view_models/admin_manage_attandance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../custom_widget/custom_skeletonizer_widget.dart';
import '../../../custom_widget/user_homeScreen_widgets/overview_widget.dart';
import '../../../custom_widget/user_homeScreen_widgets/recent_activity_loading_widget.dart';
import '../../../res/appTextStyles.dart';
import '../../../res/app_assets.dart';
import '../../../res/app_colors.dart';

class AdminManageAttandanceList extends StatefulWidget {
  final String username;
  final String name;

  AdminManageAttandanceList(
      {super.key, required this.username, required this.name});

  @override
  State<AdminManageAttandanceList> createState() =>
      _AdminManageAttandanceListState();
}

class _AdminManageAttandanceListState extends State<AdminManageAttandanceList> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final AdminManageAttandanceViewModel _attandanceController =
      Get.put(AdminManageAttandanceViewModel());

  // Improved method to fetch user attendance
  Future<List<Map<String, dynamic>>> _getUserAttendance(String username) async {
    List<Map<String, dynamic>> attendanceRecords = [];
    final year = _attandanceController.year.toString();
    final month = _attandanceController.monthName.toString();

    for (int day = 1; day <= 31; day++) {
      try {
        final dayPath = _firebaseFirestore
            .collection('attendify')
            .doc('Attandance')
            .collection(year)
            .doc(month)
            .collection(day.toString())
            .doc('userAttandance')
            .collection(username);

        // Use Future.wait to fetch both documents simultaneously
        final results = await Future.wait([
          dayPath.doc('Check In').get(),
          dayPath.doc('Check Out').get(),
        ]);

        final checkInDoc = results[0];
        final checkOutDoc = results[1];

        if (checkInDoc.exists || checkOutDoc.exists) {
          attendanceRecords.add({
            'day': day.toString(),
            'checkIn': checkInDoc.exists ? checkInDoc.data() : null,
            'checkOut': checkOutDoc.exists ? checkOutDoc.data() : null,
          });
        }
      } catch (e) {
        // Day collection might not exist, continue to next day
        continue;
      }
    }

    return attendanceRecords;
  }

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
                        InkWell(
                          onTap: () {
                            CustomBottomSheet.show(
                                context: context, child: CustomRecordView());
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.iconbgColor,
                            child: Icon(
                              Icons.calendar_month,
                              color: AppColors.iconDark,
                              size: 25,
                            ),
                          ).paddingOnly(right: 8.0),
                        ),
                      ],
                    ).paddingOnly(top: 40, bottom: 10),
                    Text(
                      '${_attandanceController.monthName},${_attandanceController.year.toString()}" 🔁⭐',
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
                '${widget.name}',
                style: AppTextStyles.customText(
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                  color: AppColors.textPrimaryDark.withOpacity(0.6),
                ),
              ).paddingOnly(left: 10),
            ),
          ),
          // Use SliverList instead of SliverToBoxAdapter for scrollable content
          FutureBuilder(
            future: _getUserAttendance(widget.username),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color:
                              AppColors.scafoldSecondaryColor.withOpacity(0.3),
                          borderRadius: index == 0
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                )
                              : BorderRadius.only(),
                        ),
                        child: CustomSkeletonizerWidget(
                          child: _recrodLoading(),
                        ),
                      );
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
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

              final attendanceRecords = snapshot.data!;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final record = attendanceRecords[index];
                    final checkInData = record['checkIn'];
                    final checkOutData = record['checkOut'];

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
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                        width: Get.width,
                        height: 165,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(AppAssets.bgImage2)),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date:  ${record['day']} ",
                              style: AppTextStyles.customText(
                                  color: AppColors.iconColor, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                overviewWidget(
                                    () {},
                                    "Check In",
                                    checkInData?['checkInTime'] ?? "--:--",
                                    checkInData?['checkInAmPm'] ?? "",
                                    'In'),
                                overviewWidget(
                                    () {},
                                    "Check Out",
                                    checkOutData?['checkOutTime'] ?? "--:--",
                                    checkOutData?['checkOUtAmPm'] ?? "",
                                    'Out'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: attendanceRecords.length,
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
                  'No More Data',
                  style: AppTextStyles.customTextbolddark14(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _recrodLoading() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      width: Get.width,
      height: 165,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage(AppAssets.bgImage2)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date:     ",
            style: AppTextStyles.customText(
                color: AppColors.iconColor, fontSize: 15),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              overviewWidget(() {}, "Check In", "--:--", "", 'In'),
              overviewWidget(() {}, "Check Out", "--:--", "", 'Out'),
            ],
          ),
        ],
      ),
    );
  }

  Widget CustomRecordView() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(color: AppColors.scaffoldDark),
      child: Column(
        children: [
          Text(
            'Year & Month',
            style: AppTextStyles.customText(fontSize: 16, color: Colors.white),
          ),
          Divider(),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 110,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                      () {
                        return Text(
                          _attandanceController.selectedYear.value.toString() ==
                                  ''
                              ? _attandanceController.year.value.toString()
                              : _attandanceController.selectedYear.value
                                  .toString(),
                          style: AppTextStyles.customText(
                              color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                    PopupMenuButton(
                      style: ButtonStyle(
                        textStyle: WidgetStatePropertyAll(
                            TextStyle(color: Colors.red)),
                        // backgroundColor: WidgetStatePropertyAll(Colors.red)
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 35,
                        color: Colors.white,
                      ),
                      itemBuilder: (context) => List.generate(
                        _attandanceController.yearList.length,
                        (index) {
                          return PopupMenuItem(
                            onTap: () {
                              _attandanceController.updateyear(
                                  _attandanceController.yearList[index]
                                      .toString());
                            },
                            child: Text(
                              _attandanceController.yearList[index].toString(),
                              style:
                                  AppTextStyles.customText(color: Colors.black),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            children: List.generate(
              _attandanceController.monthsList.length,
              (index) {
                return Obx(
                  () {
                    return InkWell(
                      onTap: () {
                        _attandanceController.updateMonth(
                            _attandanceController.monthsList[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                                color: _attandanceController
                                            .selectedMonth.value ==
                                        _attandanceController.monthsList[index]
                                    ? Colors.white
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          _attandanceController.monthsList[index].toString(),
                          style: AppTextStyles.customText(
                              color: Colors.white.withOpacity(0.8)),
                        ).marginSymmetric(horizontal: 20, vertical: 20),
                      ).paddingSymmetric(horizontal: 10, vertical: 10),
                    );
                  },
                );
              },
            ),
          ),
          CustomButtonWidget(
            text: "Get Record",
            onPressed: () {
              _attandanceController.updateAttandance(
                  _attandanceController.selectedMonth.value == ''
                      ? _attandanceController.monthName.value.toString()
                      : _attandanceController.selectedMonth.value.toString(),
                  _attandanceController.selectedYear.value == ''
                      ? _attandanceController.year.value.toString()
                      : _attandanceController.selectedYear.value.toString());
              Navigator.pop(context);
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
