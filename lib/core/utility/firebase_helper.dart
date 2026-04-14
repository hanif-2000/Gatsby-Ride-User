import 'dart:developer';
import 'dart:io';
import 'package:GetsbyRideshare/core/presentation/pages/home_page/home_page.dart';
import 'package:GetsbyRideshare/core/utility/notification_service.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:GetsbyRideshare/socket/test_socket_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
      log("remote message is------->>>>>. ${message.toMap().toString()}");

      final String title = message.data['title'] ?? message.notification?.title ?? '';
      final bool isNoDriver = title.toLowerCase().contains('no driver');

      if (isNoDriver && session.isRunningOrder && session.orderStatus == 0) {
        // Wait 4 seconds before cancelling — gives socket 'Accept' event time to arrive.
        // If driver accepted in this window, orderStatus will be 1+ and we skip cancel.
        Future.delayed(const Duration(seconds: 4), () {
          if (session.isRunningOrder && session.orderStatus == 0) {
            _handleNoDriverAvailable(session);
          } else {
            log("No-driver notification ignored — driver already accepted (status=${session.orderStatus})");
          }
        });
        return;
      }

      // Show local notification on Android only (iOS APNs handles it automatically)
      if (!Platform.isIOS) {
        NotificationHelper notificationService = NotificationHelper();
        notificationService.showNotifications(message);
      }
    });
  }

  static void _handleNoDriverAvailable(Session session) {
    log("No driver available notification received — cancelling ride and going home");
    session.setIsRunningOrder = false;
    session.setOrderStatus = 8;
    session.setSearchingTime = 180;

    final socketProvider = locator<TestSocketProvider>();
    socketProvider.cancelRideByCustomer();

    final navigatorKey = locator<GlobalKey<NavigatorState>>();
    final context = navigatorKey.currentContext;
    if (context != null) {
      dismissLoading();
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.routeName,
        (route) => false,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = navigatorKey.currentContext;
        if (ctx != null) {
          showDialog(
            barrierDismissible: false,
            context: ctx,
            builder: (dialogContext) => PopScope(
              canPop: false,
              child: AlertDialog(
                title: Text(
                  "No Nearby Driver Found",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.pop(dialogContext),
                  ),
                ],
              ),
            ),
          );
        }
      });
    }
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
