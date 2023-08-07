import 'dart:developer';

import 'package:GetsbyRideshare/core/utility/notification_service.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';
import 'helper.dart';
import 'injection.dart';

class FirebaseHelper {
  static late FirebaseMessaging messaging;

  static Future<void> init() async {
    logMe("Firebasee helperrrr");
    await Firebase.initializeApp(
        name: 'Gatsby RideShare',
        options: DefaultFirebaseOptions.currentPlatform);
    messaging = FirebaseMessaging.instance;

    await permissionHandler().then((authorized) async {
      log("IS AUTHORIZED:  $authorized");
      if (authorized) {
        await setupMessaging();
      }
    });
  }

  static Future<void> setupMessaging() async {
    await messaging.getToken().then((token) async {
      final session = locator<Session>();
      logMe("firebase-token: $token");
      session.setFcmToken = token!;
    });
    await incomingNotificationHandling();
  }

  static Future<void> incomingNotificationHandling() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationHelper _notificationService = NotificationHelper();
      _notificationService.showNotifications(message);
    });
  }

  static Future<bool> permissionHandler() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logMe('User granted permission: ${settings.authorizationStatus}');
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  log("Message _____ " + message.data.toString());

  logMe("Handling a background message: ${message.messageId}");
}
