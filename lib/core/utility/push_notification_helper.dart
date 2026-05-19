import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:GetsbyRideshare/core/presentation/pages/home_page/home_page.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import '../domain/entities/notification_entity.dart';
import 'injection.dart';


class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  static const JsonDecoder _decoder = JsonDecoder();
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');
  final session = locator<Session>();
  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,

  );

  final BehaviorSubject<String?> _selectNotificationSubject =
      BehaviorSubject<String?>();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    _configureSelectNotificationSubject();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/notification_icon');
    DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: null,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          _selectNotificationSubject.add(notificationResponse.payload);
        }
      },
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // iOS foreground options NotificationHelper.init() mein set hoti hain (alert:false)
    // taki FCM + local dono ek saath na aayein (duplicate avoid)
    _initFirebaseListeners();
  }

  void _configureSelectNotificationSubject() {
    _selectNotificationSubject.stream.listen((String? payload) async {
      if (session.userId.isEmpty) {
        return;
      }
      NotificationEntity? entity = convertStringToNotificationEntity(payload);
      print("notification _configureSelectNotificationSubject ${entity.toString()}");
      if (entity != null) {
        _pushNextScreenFromForeground(entity);
      }
    });
  }

  Future? _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (session.userId.isEmpty) {
      return null;
    }

    NotificationEntity? entity = convertStringToNotificationEntity(payload);

    print("notification onDidReceiveLocalNotification ${entity.toString()}");
    if (entity != null) {
      _pushNextScreenFromForeground(entity);
    }
    return null;
  }

  void _initFirebaseListeners() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (session.userId.isEmpty) {
        print("userToken is Null");
        return;
      }
      print("IOS Foreground notification opened: ${message.data}");
      NotificationEntity notificationEntity =
          NotificationEntity.fromJson(message.data);
      _pushNextScreenFromForeground(notificationEntity);
    });
    // onMessage is handled by FirebaseHelper.incomingNotificationHandling() to
    // avoid duplicate local notifications. Do not add another listener here.
  }

  Future<void> clearAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.cancelAll();
    }
  }

  Future<void> _showNotifications(NotificationEntity notificationEntity) async {
    Random random = Random();
    int id = random.nextInt(900) + 10;
    await _flutterLocalNotificationsPlugin.show(
        id,
        notificationEntity.title,
        notificationEntity.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: "@mipmap/notification_icon",
            channelShowBadge: true,
            playSound: true,
            priority: Priority.high,
            importance: Importance.high,
            styleInformation: BigTextStyleInformation(notificationEntity.body!),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: convertNotificationEntityToString(notificationEntity));
  }

  void _pushNextScreenFromForeground(NotificationEntity notificationEntity) async {
    final route = await callApi(notificationEntity);
    if (route == null) return;
    final navigatorKey = locator<GlobalKey<NavigatorState>>();
    final context = navigatorKey.currentContext;
    if (context != null && (context as Element).mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(route.$1, (r) => false);
    }
  }

  Future<(String, Object?)?> callApi(NotificationEntity entity) async {
    // Notification tap hone par hamesha HomePage par bhejo —
    // HomePage khud session check karke order page par redirect kar deta hai
    return (HomePage.routeName, null);
  }

  Future<(String, Object?)?> getPushNotificationRoute() async {
    RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    const NotificationAppLaunchDetails? notificationAppLaunchDetails = null;
    if (remoteMessage != null && remoteMessage.data.isNotEmpty) {
      print("RemoteMessage data ${remoteMessage.data}");
      NotificationEntity notificationEntity = NotificationEntity.fromJson(remoteMessage.data);
      notificationEntity.title = remoteMessage.data['title'];
      notificationEntity.body = remoteMessage.data['body'];
      notificationEntity.type = remoteMessage.data['type'];
      notificationEntity.courseId = remoteMessage.data['courseId'];
      return callApi(notificationEntity);
    }
    if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
      NotificationEntity? entity = convertStringToNotificationEntity(notificationAppLaunchDetails?.notificationResponse?.payload);
      if (entity != null) {
        print("RemoteMessage data ${entity.toJson()}");
        return callApi(entity);
      }
    }

    return null;
  }

  String convertNotificationEntityToString(NotificationEntity? notificationEntity) {
    String value = _encoder.convert(notificationEntity);
    return value;
  }

  NotificationEntity? convertStringToNotificationEntity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    try {
      Map<String, dynamic> map = _decoder.convert(value);
      return NotificationEntity.fromJson(map);
    } catch (e) {
      print("convertStringToNotificationEntity parse error: $e");
      return null;
    }
  }
}
