import 'dart:developer';
import 'dart:io';
import 'package:GetsbyRideshare/core/utility/notification_service.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'helper.dart';
import 'injection.dart';

class FirebaseHelper {
  static late FirebaseMessaging messaging;

  static Future<void> init() async {
    logMe("Firebasee helperrrr init");
    log("Firebasee helperrrr init");
    messaging = FirebaseMessaging.instance;
    await incomingNotificationHandling();

  }


  static Future<void> incomingNotificationHandling() async {
    log("Firebasee helperrrr init incomingNotificationHandling");

    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("on message listen called");
      print("on message listen called");
      print("remote message is------->>>>>. ${message.toMap().toString()}");
      fetchRemoteMessage(message);

      NotificationHelper notificationService = NotificationHelper();
      notificationService.showNotifications(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final session = locator<Session>();
      if (session.sessionToken.isEmpty) {
        return;
      }
      log("on message listen called");
      print("on message listen called");
      log("remote message is------->>>>>. ${message.toMap().toString()}");
      fetchRemoteMessage(message);
      NotificationHelper notificationService = NotificationHelper();
      notificationService.showNotifications(message);
    });
  }

  static fetchRemoteMessage(RemoteMessage message) {
    // Booking Cancelled//
    //New Order

    print("notification titilew is---->> $message");
    log("notification category :${message.category}");
    log("notification collapseKey :${message.collapseKey}");
    log("notification contentAvailable :${message.contentAvailable}");
    log("notification data :${message.data}");
    log("notification contains key startiung point  :${message.data.containsKey('Starting point')}");
    log("notification Destination :${message.data['Destination']}");
    log("notification from :${message.from}");
    log("notification messageId :${message.messageId}");
    log("notification messageType :${message.messageType}");
    log("notification mutableContent :${message.mutableContent}");
    log("notification notification :${message.notification}");
    log("notification senderId :${message.senderId}");
    log("notification sentTime :${message.sentTime}");
    log("notification threadId :${message.threadId}");
    log("notification ttl :${message.ttl}");

    log("remote message called");

    logMe('data: ${message.data}');
    late String? title;
    late String? body;
    late String? orderId;
    late String? clickAction;
    final Map<String, dynamic> data = message.data;
    if (Platform.isIOS) {
      title = data["title"];
      body = data["body"];
      orderId = data["id_order"];
      clickAction = data["click_action"];
    } else if (Platform.isAndroid) {
      final RemoteNotification? notification = message.notification;
      title = notification?.title;
      body = notification?.body;
      orderId = data["id_order"];
      clickAction = data["click_action"];
    }

    // if (clickAction != null) {
    //   final incomingOrderDetail = IncomingOrderDetail(
    //       title: title!,
    //       body: body!,
    //       orderId: orderId!,
    //       clickAction: clickAction);
    //   NotificationHandler.handleNotificationAction(incomingOrderDetail);
    // }
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
  log("background message called");

  NotificationHelper notificationService = NotificationHelper();

  notificationService.showNotifications(message);

  //No need for showing Notification manually.
  //For BackgroundMessages: Firebase automatically sends a Notification.
  //If you call the flutterLocalNotificationsPlugin.show()-Methode for
  //example the Notification will be displayed twice.
  return;
  // await Firebase.initializeApp();

  // NotificationHelper notificationService = NotificationHelper();

  // logMe("Handling a background message: ${message.messageId}");
}

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   log("Firebasee helperrrr firebase messgae background handler");
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();

//   NotificationHelper _notificationService = NotificationHelper();
//   _notificationService.showNotifications(message);

//   log("Message _____ " + message.data.toString());
//   log("message data TITLE is ---${message.notification!.title}");
//   log("message data BODY is ---${message.data['message']}");

//   logMe("Handling a background message: ${message.messageId}");
// }
