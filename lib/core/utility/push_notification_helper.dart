import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (Platform.isIOS || (session.userId.isEmpty)) {
        return;
      }
      print("Foreground notification received:  ${message.data}");
      NotificationEntity notificationEntity = NotificationEntity.fromJson(message.data);
      print(message.data.toString());
      notificationEntity.title = notificationEntity.title ?? "Auto Experts Tx";
      notificationEntity.body = notificationEntity.body;
      _showNotifications(notificationEntity);
    });
  }

  /* Future? _onSelectNotification(String? payload) {
    if (Getters.authToken?.isEmpty??true) {
      return null;
    }
    NotificationEntity? entity = convertStringToNotificationEntity(payload);
    printLog("notification onSelectNotification ${entity.toString()}");
    if (entity != null) {
      _pushNextScreenFromForeground(entity);
    }
    return null;
  }*/

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
        ),
        payload: convertNotificationEntityToString(notificationEntity));
  }

  void _pushNextScreenFromForeground(NotificationEntity notificationEntity) async {
    final tuple2 = await callApi(notificationEntity);
    if (tuple2 != null) {
      /*if (myRouteObserver.currentRoute == Routes.notification &&
          Getters.getContext!.mounted) {
        Getters.getContext!.read<NotificationBloc>().add(GetNotifications());
      } else if (myRouteObserver.currentRoute == Routes.courseDetail &&
          Getters.getContext!.mounted) {
        back(Getters.getContext!);
        toNamed(Getters.getContext!, tuple2.$1, args: tuple2.$2);
      } else {
        toNamed(Getters.getContext!, tuple2.$1, args: tuple2.$2);
      }*/
    }
  }

  Future<(String, Object?)?> callApi(NotificationEntity entity) async {
   /* if (entity.courseId != null) {
      return (Routes.courseDetail, {"id": int.tryParse(entity.courseId ?? "")});
    } else {
      return (Routes.notification, null);
    }*/
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
    if (value == null) {
      return null;
    }

    Map<String, dynamic> map = _decoder.convert(value);
    return NotificationEntity.fromJson(map);
  }
}
