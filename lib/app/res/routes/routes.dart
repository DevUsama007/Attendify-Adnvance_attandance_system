import 'package:attendify/app/res/routes/routes_name.dart';
import 'package:attendify/app/view/adminPanelScreens/adminLoginScreen.dart';
import 'package:attendify/app/view/adminPanelScreens/adminSplashScreen.dart';
import 'package:attendify/app/view/adminPanelScreens/admin_manage_attandance/admin_manage_attandance_list.dart';
import 'package:attendify/app/view/adminPanelScreens/admin_manage_attandance/admin_manage_user_list.dart';
import 'package:attendify/app/view/userPanelScreens/userHomeScreen.dart';
import 'package:attendify/app/view/userPanelScreens/userSplashScreen.dart';
import 'package:attendify/app/view/userPanelScreens/userloginScreen.dart';
import 'package:get/get.dart';

import '../../view/adminPanelScreens/adminAddNewUser.dart';
import '../../view/adminPanelScreens/adminHomeScreen.dart';
import '../../view/adminPanelScreens/admin_today_report_screen.dart';
import '../../view/adminPanelScreens/admin_view_recent_activites.dart';
import '../../view/adminPanelScreens/admin_view_user_screen.dart';
import '../../view/cameraScreens/camera_view.dart';
import '../../view/userPanelScreens/checkUserLocationScreen.dart';
import '../../view/userPanelScreens/user_recent_activities_screen.dart';

class ApprRoutes {
  static List<GetPage> appRoutes() {
    return [
      GetPage(
          name: RouteName.adminSplashScreen,
          page: () => AdminSplashScreen(),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.adminLoginScreen,
          page: () => AdminLoginScreen(),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.adminHomeScreen,
          page: () => AdminHomeScreen(),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.adminAddNewUser,
          page: () => AdminAddNewUser(),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.adminViewUserScreen,
          page: () => AdminViewUserScreen(),
          transition: Transition.downToUp),
      GetPage(
          name: RouteName.adminTodayReportScreen,
          page: () => AdminTodayReportScreen(),
          transition: Transition.downToUp),
      GetPage(
          name: RouteName.adminRecentActivitiesScreen,
          page: () => AdminRecentActivitiesScreen(
                pageTitle: '',
              ),
          transition: Transition.downToUp),
      GetPage(
          name: RouteName.adminManageUserList,
          page: () => AdminManageUserList(),
          transition: Transition.downToUp),
      GetPage(
          name: RouteName.adminManageAttandanceList,
          page: () => AdminManageAttandanceList(
                username: '',
                name: '',
              ),
          transition: Transition.downToUp),
      GetPage(
          name: RouteName.userSplashScreen,
          page: () => UserSplashScreen(),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.userHomeScreen,
          page: () => UserHomeScreen(),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.userLoginScreen,
          page: () => UserLoginScreen(),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.checkUserLocationScreen,
          page: () => CheckUserLocationScreen(
                btn_text: '',
              ),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.cameraScreen,
          page: () => CameraView(
                session: '',
              ),
          transition: Transition.leftToRight),
      GetPage(
          name: RouteName.userRecentActivitiesScreen,
          page: () => UserRecentActivitiesScreen(
                username: '',
              ),
          transition: Transition.downToUp),
    ];
  }
}
