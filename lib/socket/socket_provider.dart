import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart';
import '../core/utility/helper.dart';
import '../core/utility/injection.dart';
import '../core/utility/session_helper.dart';

class SocketProvider extends ChangeNotifier {
  var session = locator<Session>();
  WebSocket? socket;

  connectToSocket() {
    logMe('============= chat Token : ${session.chatToken} ================');
    logMe('============= User Id Token :  ${session.userId} ================');

    socket = WebSocket(Uri.parse(
        'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}'));

    logMe('============= Connecting to Socket ================');
    socket!.connection.listen((event) {
      logMe('Socket on Listen ---> ${event.toString()}');

      if (event is Connected) {
        // listenRequests();
        // sendRequest();

        logMe("=====event======>>>>> " + event.toString());
      } else if (event is Disconnected) {
        logMe("=== Event is Disconnected ===");
        logMe("=== reason ${event.reason}");
      }
    });
  }

  var roomId = '';

  //send request to socket

  sendRequest() {
    socket!
        // .send("serviceType: UserBookDriver, id: ${session.userId.toString()}");
        .send(jsonEncode({
      "serviceType": "UserBookDriver",
      "UserID": "${session.userId.toString()}"
    }));

    socket!.connection.listen((state) => print('state: "$state"'));

    logMe("send request");

    socket!.messages.listen((message) => message());
  }

  chatRequest({required String msg}) {
    socket!.send(jsonEncode({
      "userID": "${session.userId}",
      "serviceType": "Chat",
      "recieverID": "${session.driverId}",
      "msg": msg,
      "room":
          "${min(int.parse(session.userId), int.parse(session.driverId))}-${max(int.parse(session.userId), int.parse(session.driverId))}",
      "MessageType": "Text",
      "SenderType": "Customer",
      "RecieverType": "Driver",
      "type": "chat",
    }));
  }

  listenChat() {}
}
