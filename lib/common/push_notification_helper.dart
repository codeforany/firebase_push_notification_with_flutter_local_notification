import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notification_demo/common/globs.dart';
import 'package:push_notification_demo/main.dart';
import 'package:push_notification_demo/view/data_view.dart';
import 'package:push_notification_demo/view/detail_view.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("backgroundHandler:");
  print(message.data.toString());
  print(message.notification?.title ?? "");

  openNotification(message.data);
}

class PushNotificationHelper {
  static String fcmToken = "";
  static Future<void> initialized() async {
    await Firebase.initializeApp();

    if (Platform.isAndroid) {
      // Local Notification Initalized
      NotificationHelper.initialized();
    } else if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    getDeviceTokenToSendNotification();

    // If App is Terminated state & used click notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.instance.getInitialMessage");

      if (message != null) {
        print("New Notification");
        print(message.data.toString());
        print(message.notification?.title ?? "");
      }
    });

    // App is Forground this method  work
    FirebaseMessaging.onMessage.listen((message) {
      print("FirebaseMessaging.onMessage.listen");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);

        if (Platform.isAndroid) {
          // Local Notification Code to Display Alert
          NotificationHelper.displayNotification(message);
        }
      }
    });

    // App on Backaground not Terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);

        openNotification(message.data);
      }
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  static Future<String> getDeviceTokenToSendNotification() async {
    fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    print("FCM Token: $fcmToken");

    return fcmToken;
  }
}

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialized() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(android: initializationSettingsAndroid),
        onDidReceiveNotificationResponse: (details) {
      print(details.toString());
      print("localBackgroundHandler :");
      print(details.notificationResponseType ==
              NotificationResponseType.selectedNotification
          ? "selectedNotification"
          : "selectedNotificationAction");
      print(details.payload);

      try {
        var payloadObj = json.decode(details.payload ?? "{}") as Map? ?? {};
        openNotification(payloadObj);
      } catch (e) {
        print(e);
      }
    }, onDidReceiveBackgroundNotificationResponse: localBackgroundHandler);
  }

  static void displayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "push_notification_demo", "push_notification_demo_channel",
            importance: Importance.max, priority: Priority.high),
      );

      await flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: json.encode(message.data));
    } on Exception catch (e) {
      print(e);
    }
  }
}

Future<void> localBackgroundHandler(NotificationResponse data) async {
  print(data.toString());
  print("localBackgroundHandler :");
  print(data.notificationResponseType ==
          NotificationResponseType.selectedNotification
      ? "selectedNotification"
      : "selectedNotificationAction");
  print(data.payload);

  try {
    var payloadObj = json.decode(data.payload ?? "{}") as Map? ?? {};
    openNotification(payloadObj);
  } catch (e) {
    print(e);
  }
}

void openNotification(Map payloadObj) async {
  await Future.delayed(const Duration(milliseconds: 300));
  if(payloadObj["user_login_need"].toString() == "true" ) {
    if(Globs.udValueBool(Globs.userLogin)) {
      // App inside user login
      if( payloadObj["user_id"].toString() == userPayload["user_id"].toString() ) {
        // Notification Payload Data user id current
        openNotificationScreen(payloadObj);
      }else{
        // Notification Payload Data user id not match
        print("skip open screen");
      }
    }else{
      // App inside not user login
      pushRedirect = true;
      pushPayload = payloadObj;

    }
  }else{
    //User not need
    openNotificationScreen(payloadObj);
  }
  
}

void openNotificationScreen(Map payloadObj) {
  try {
    if (payloadObj.isNotEmpty) {
      switch (payloadObj["page"] as String? ?? "") {
        case "detail":
          navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) => DetailView(nObj: payloadObj)));
          break;
        case "data":
          navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) => DataView(nObj: payloadObj)));
          break;
        default:
      }
    }
  } catch (e) {
    print(e);
  }
}
