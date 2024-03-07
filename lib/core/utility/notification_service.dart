import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  //singleton pattern
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const String iconNotification = '@mipmap/notification_icon';
    const initializationSettingsAndroid =
        AndroidInitializationSettings(iconNotification);
    const initializationSettingsIos = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: false);
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIos);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',

    // description
    importance: Importance.max,
  );


  Future<void> showNotifications(RemoteMessage message) async {
    print("show notification called :-->> ${message.data}");
    print("show notification title :-->> ${message.data["title"]}");
    print("show notification message :-->> ${message.data["message"]}");
    Random random = Random();
    int id = random.nextInt(900) + 10;
    await flutterLocalNotificationsPlugin.show(
      id,
      message.data["title"],
      message.data["message"],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: "@mipmap/notification_icon",
          channelShowBadge: true,
          playSound: true,
          priority: Priority.max,
          importance: Importance.max,
          styleInformation: BigTextStyleInformation(message.data["message"] ?? ""),
        ),
      ),
      //  NotificationDetails(android: _androidNotificationDetails),
    );
  }

  // Future<void> showNotifications(RemoteMessage message) async {
  //   if (message.notification != null) {
  //     await flutterLocalNotificationsPlugin.show(
  //       0,
  //       message.data['title'],
  //       message.data['message'],
  //       // message.notification?.title,%
  //       // message.notification?.body != null
  //       //     ? message.notification?.body
  //       //     : message.data['message'],
  //       NotificationDetails(android: _androidNotificationDetails),
  //     );
  //   } else {
  //     await flutterLocalNotificationsPlugin.show(
  //       0,
  //       message.data['title'],
  //       message.data['message'],
  //       NotificationDetails(android: _androidNotificationDetails),
  //     );
  //   }
  // }

  void selectNotification(NotificationResponse? payload) async {
    //handle your logic here
  }
}
