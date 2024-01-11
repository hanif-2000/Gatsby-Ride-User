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
    const String iconNotification = '@mipmap/launcher_icon';
    const initializationSettingsAndroid =
        AndroidInitializationSettings(iconNotification);
    const initializationSettingsIos = DarwinInitializationSettings(
        requestSoundPermission: false,
        requestAlertPermission: false,
        requestBadgePermission: false);
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIos);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails('channel ID', 'channel name',
          playSound: true,
          channelShowBadge: false,
          priority: Priority.max,
          importance: Importance.max,
          enableVibration: true
          // color: Color(0xff000000),
          );

  Future<void> showNotifications(RemoteMessage message) async {
    if (message.notification != null) {
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body != null
            ? message.notification?.body
            : message.data['message'],
        NotificationDetails(android: _androidNotificationDetails),
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        0,
        message.data['action'],
        '',
        NotificationDetails(android: _androidNotificationDetails),
      );
    }
  }

  void selectNotification(NotificationResponse? payload) async {
    //handle your logic here
  }
}
