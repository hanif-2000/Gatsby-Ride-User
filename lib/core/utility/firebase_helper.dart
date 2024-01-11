import 'dart:developer';
import 'package:GetsbyRideshare/core/utility/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';
import 'helper.dart';


class FirebaseHelper {
  static late FirebaseMessaging messaging;

  static Future<void> init() async {
    logMe("Firebasee helperrrr init");
    log("Firebasee helperrrr init");
    messaging = FirebaseMessaging.instance;
    await incomingNotificationHandling();
 /*   await permissionHandler().then((authorized) async {
      log("IS AUTHORIZED:  $authorized");
      if (authorized) {
        await setupMessaging();
      } else {
        await setupMessaging();
        // await permissionHandler().then((value) async => {
        //       if (authorized) {await setupMessaging()}
        //     });
      }
    });*/
  }
/*
  static Future<void> setupMessaging() async {
    log("Firebasee helperrrr init setupMessaging");

    await messaging.getToken().then((token) async {
      final session = locator<Session>();
      logMe("firebase-token: $token");
      session.setFcmToken = token!;
    });
    await incomingNotificationHandling();
  }*/

  static Future<void> incomingNotificationHandling() async {
    log("Firebasee helperrrr init incomingNotificationHandling");

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("on message listen:-->> ${message.data}");
      log("on message listen:-->> ${message.notification!.title}");
      log("on message listen:-->> ${message.notification!.bodyLocArgs}");
      // if (message.notification!.title != 'New Order' ||
      //     message.notification!.title != 'Booking Cancelled') {
      //   var orderProvider = Provider.of<OrderProvider>(
      //       locator<GlobalKey<NavigatorState>>().currentContext!,
      //       listen: false);

      //   orderProvider.updateUnReadMessages(isNewMessage: true);
      // final GlobalKey<ScaffoldState> key = GlobalKey();

      // Session session = locator<Session>();
      // if (!session.isOrderRunning) {
      //   homeProvider.getRequestListData().listen((event) {
      //     log("event is -->> $event");
      //     if (event is RequestListLoaded) {
      //       logMe(
      //           'Request list data loaded success----------> ${event.data.length}');
      //       Navigator.pushNamedAndRemoveUntil(
      //           locator<GlobalKey<NavigatorState>>().currentContext!,
      //           HomePage.routeName,
      //           (route) => false);
      // }
      //     });
      //   }
      // }

      // fetchRemoteMessage(message);
      NotificationHelper _notificationService = NotificationHelper();
      _notificationService.showNotifications(message);
    });
  }

  static Future<bool> permissionHandler() async {
    log("Firebasee helperrrr permission handler called");
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
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
  log("Firebasee helperrrr firebase messgae background handler");
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  NotificationHelper _notificationService = NotificationHelper();
  _notificationService.showNotifications(message);

  log("Message _____ " + message.data.toString());
  log("message data TITLE is ---${message.notification!.title}");
  log("message data BODY is ---${message.data['message']}");

  logMe("Handling a background message: ${message.messageId}");
}
