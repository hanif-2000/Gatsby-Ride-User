import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../core/utility/helper.dart';
import '../core/utility/injection.dart';
import '../core/utility/session_helper.dart';

class SocketProvider with ChangeNotifier {
  static final SocketProvider _singleton = SocketProvider._internal();

  factory SocketProvider() {
    return _singleton;
  }

  SocketProvider._internal();

  WebSocket? _socket;
  final session = locator<Session>();

  TextEditingController msgEditingController = TextEditingController();

  connectToSocket() {
    logMe('============= Chat Token ${session.chatToken} ================');
    logMe(
        'URL --> ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
    _socket = WebSocket(Uri.parse(
        'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}'));

    logMe('============= Connecting to Socket ================');
    _socket!.connection.listen((event) {
      logMe('Socket on Listen ---> ${event.toString()}');
      if (event is Connected) {
        listenRequests();
      }
    });
  }

  listenRequests() {
    logMe('============= Listening to requests ================');
    _socket!.messages.listen((event) {
      logMe('Data in socket');
      logMe('Request list data socket-----> ${event.toString()}');
    });
  }

  // rejectRequestSocket() {
  //   final map = {
  //     'serviceType': 'RejectRequest',
  //     'driverID': session.userId,
  //   };
  //   logMe('reject request socket -- > ${map.toString()}');
  //   _socket!.send(jsonEncode(map));
  // }

  // acceptRequestSocket() {
  //   final map = {
  //     'serviceType': 'AcceptRequest',
  //     'driverID': session.userId,
  //   };
  //   logMe('reject request socket -- > ${map.toString()}');
  //   _socket!.send(jsonEncode(map));
  // }

  joinExitRoom({int? receiverId, String type = 'Join'}) {
    final map = {
      'serviceType': type,
      'UserID': session.userId,
      'roomID': (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
    };
    logMe('Join Exit room socket -- > ${map.toString()}');
    _socket!.send(jsonEncode(map));
  }

  sendChatMessage({
    String? message,
    int? receiverId,
    String? messageType = 'Text',
  }) {
    // final chatProvider = locator<ChatProvider>();
    final map = {
      "userID": session.userId,
      "serviceType": "Chat",
      "recieverID": receiverId,
      "msg": message,
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "MessageType": "Text",
      "SenderType": "Customer",
      "RecieverType": "Driver",
      "type": "Chat"
    };
    print('Message send ---> ${map.toString()}');
    _socket!.send(jsonEncode(map));

    // chatProvider.addSingleChat(
    //   ChatDataModel(
    //     message,
    //     int.parse(session.userId),
    //     receiverId,
    //     DateTime.now(),
    //   ),
    // );
  }

  // markMessageAsRead({
  //   int? receiverId,
  // }) {
  //   final map = {
  //     "userID": session.userId,
  //     "serviceType": "Chat",
  //     "recieverID": receiverId,
  //     "room": (int.parse(session.userId) > receiverId!)
  //         ? '$receiverId-${session.userId}'
  //         : '${session.userId}-$receiverId',
  //     "SenderType": "Driver",
  //     "RecieverType": "Customer",
  //     "type": "read"
  //   };
  //   _socket!.send(jsonEncode(map));
  // }
}






// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:web_socket_client/web_socket_client.dart';
// import '../core/utility/helper.dart';
// import '../core/utility/injection.dart';
// import '../core/utility/session_helper.dart';

// class SocketProvider extends ChangeNotifier {
//   var session = locator<Session>();
//   WebSocket? socket;

//   connectToSocket() {
//     logMe('============= chat Token : ${session.chatToken} ================');
//     logMe('============= User Id Token :  ${session.userId} ================');

//     socket = WebSocket(Uri.parse(
//         'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}'));

//     log('ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');

//     logMe('============= Connecting to Socket ================');
//     socket!.connection.listen((event) {
//       logMe('Socket on Listen ---> ${event.toString()}');

//       if (event is Connected) {
//         // listenRequests();
//         // sendRequest();

//         logMe("=====event======>>>>> " + event.toString());
//       } else if (event is Disconnected) {
//         logMe("=== Event is Disconnected ===");
//         logMe("=== reason ${event.reason}");
//       }
//     });
//   }

//   TextEditingController msgEditingController = TextEditingController();

//   // var roomId = '';

//   //send request to socket

// //Check socket null

//   checkSocket() {
//     if (socket == null) {
//       connectToSocket();
//       sendRequest();
//     } else {
//       sendRequest();
//     }
//   }

// //Send Request
//   sendRequest() {
//     try {
//       socket!.send(jsonEncode({
//         "serviceType": "UserBookDriver",
//         "UserID": "${session.userId.toString()}"
//       }));

//       socket!.connection.listen((state) => print('state: "$state"'));

//       logMe("send request");

//       socket!.messages.listen((message) => message());
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   chatRequest() {
//     // log("msg--" + msgEditingController.text);
//     socket!.send(jsonEncode({
//       "userID": "${session.userId}",
//       "serviceType": "Chat",
//       "recieverID": "1",
//       "msg": "hello ",
//       "room": "1-1",
//       // "room":
//       //     "${math.min(int.parse(session.userId), int.parse(session.driverId))}-${math.max(int.parse(session.userId), int.parse(session.driverId))}",
//       "MessageType": "Text",
//       "SenderType": "Customer",
//       "RecieverType": "Driver",
//       "type": "chat",
//     }));
//   }

//   listenChat() {
//     socket!.connection.listen((event) {
//       log("connection event-->>>$event");
//     });
//   }
// }
