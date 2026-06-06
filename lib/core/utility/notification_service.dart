import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
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
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // alert: false — background replay messages foreground mein auto-banner na dikhayein.
    // Background notifications APNs khud dikhata hai. Socket events foreground UI update karte hain.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );
  }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<void> showNotifications(RemoteMessage message) async {
    print("show notification called :-->> ${message.data}");
    final title = message.data["title"] ?? message.notification?.title ?? "";
    final body = message.data["message"] ?? message.data["body"] ?? message.notification?.body ?? "";
    await showLocalNotification(title: title, body: body);
  }

  Future<void> showLocalNotification({required String title, required String body}) async {
    Random random = Random();
    int id = random.nextInt(900) + 10;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
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
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  void selectNotification(NotificationResponse? payload) async {}
}