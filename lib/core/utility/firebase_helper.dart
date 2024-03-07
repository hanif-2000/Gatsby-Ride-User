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
    log("Firebasee helperrrr init");
    messaging = FirebaseMessaging.instance;
    await incomingNotificationHandling();
  }

  static Future<void> incomingNotificationHandling() async {
    log("Firebasee helperrrr init incomingNotificationHandling");

/*
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp listen called");
      print("on message listen called");
      print("remote message is------->>>>>. ${message.toMap().toString()}");
   //   _fetchRemoteMessage(message);
      NotificationHelper notificationService = NotificationHelper();
      notificationService.showNotifications(message);
    });
    //========//
*/

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final session = locator<Session>();
      if (session.sessionToken.isEmpty) {
        return;
      }
      log("onMessage listen called");
      print("on message listen called");
      log("remote message is------->>>>>. ${message.toMap().toString()}");
      //  _fetchRemoteMessage(message);
      NotificationHelper notificationService = NotificationHelper();
      notificationService.showNotifications(message);
    });
  }

  static _fetchRemoteMessage(RemoteMessage message) {
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
  }
}
