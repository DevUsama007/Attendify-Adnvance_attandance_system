import 'dart:io';
import 'dart:math';

import 'package:attendify/app/view/adminPanelScreens/admin_view_recent_activites.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

//firebase Initialization
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen(
      (message) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        // print(message.data['data'].toString()); get the instance from data

        if (Platform.isAndroid) {
          initLocalNotifications(context, message);
          showNotification(message);
        } else {
          showNotification(message);
        }
      },
    );
  }

//Ask for notification permisssion
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission Granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('provission permission granted');
    } else {
      print('Permission Denied');
    }
  }

//get the device token
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

//refresh the token
  void isTokenRefresh() {
    print('in refresh');
    messaging.onTokenRefresh.listen(
      (event) {
        event.toString();
      },
    );
  }

//initLocal Notification
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSetting = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

//show notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', 'High Imortance Noticaiton',
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'Your Channel Description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker',
            icon: '@mipmap/ic_launcher');
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(
      Duration.zero,
      () async {
        await _flutterLocalNotificationsPlugin.show(
            1,
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            notificationDetails);
      },
    );
  }

//redirect the notification
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.notification != null) {
      Get.to(() => AdminRecentActivitiesScreen(pageTitle: 'Notifications'));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => AdminRecentActivitiesScreen(
      //         pageTitle: 'Notifications',
      //       ),
      //     ));
    }
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    //when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        handleMessage(context, event);
      },
    );
  }
//subscribe to the topic  in firebase messaging

  void subcribeTopic(String topic) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic(topic);
    if (kDebugMode) {
      print('subscribe to the topic ${topic} ');
    }
  }

  void unsubcribeTopic(String topic) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.unsubscribeFromTopic(topic);
    if (kDebugMode) {
      print('unsubscribe to the topic ${topic} ');
    }
  }
}
