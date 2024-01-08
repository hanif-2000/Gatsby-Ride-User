// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// import '../core/utility/helper.dart';
// import '../core/utility/injection.dart';
// import '../core/utility/session_helper.dart';
// import '../features/order/data/models/chat_modal.dart';

// class NewSocketProvider with ChangeNotifier {
//   static final NewSocketProvider _singleton = NewSocketProvider._internal();

//   factory NewSocketProvider() {
//     return _singleton;
//   }

//   NewSocketProvider._internal();

//   final session = locator<Session>();

//   WebSocketChannel? channel;

//   connectToSocket() async {
//     try {
//       final wsUrl = Uri.parse(
//           'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
//       channel = WebSocketChannel.connect(wsUrl);

//       log("web socket connect url is : $wsUrl");
//       log("web socket connect url is : $channel");

//       await channel!.ready;
//       listenToSocket();
//     } catch (e) {
//       // showDialog(
//       //   barrierDismissible: false,
//       //   context: context,
//       //   builder: (context) {
//       //     return CustomSimpleDialog(text: "socket error $e", onTap: () {});
//       //   },
//       // );
//       log("connect to socket error :$e");
//     }
//   }

//   disconnectSocket() {
//     channel!.sink.close();
//   }

//   listenToSocket() {
//     var res = channel!.ready.asStream();

//     /// Listen for all incoming data
//     channel!.stream.listen(
//       (data) {
//         print(data);

//         final response = jsonDecode(data);
//         logMe('Message list data-----> ${response.toString()}');
//         if (response['type'] == 'MessageList') {
//           log("messgae type is MESSAGE LIST");
//           logMe('Message list data-----> ${response['data']}');
//           if (response['data'] != null) {
//             addChatAll(
//               List<ChatModel>.from(
//                 response["data"].map(
//                   (x) => ChatModel.fromMap(x),
//                 ),
//               ),
//             );
//             log("chat data is :-->>${chatMessageList.length}");
//           } else {
//             addChatAll([]);
//           }
//         }
//         if (response['type'] == 'Chat') {
//           addSingleChat(
//             ChatModel.fromMap(
//               response['data'],
//             ),
//           );

//           log("chat data is :-->>${chatMessageList.length}");
//         }
//         if (response['type'] == 'UnreadCount') {
//           log("unread message count called");

//           updateUnReadMessages(count: response['data']);
//         }

//         log("websoceet data is:-->>${data}");
//       },
//       onError: (error) => print("errot is" + error),
//       onDone: () {
//         Future.delayed(Duration(seconds: 5)).then(
//           (value) {
//             connectToSocket();
//           },
//         );
//       },
//     );

//     log("res is res:${res.length}");
//   }

// //join/unjoin room
//   joinExitRoom({int? receiverId, required String type}) {
//     markMessageAsRead(receiverId: receiverId);
//     log("join socket called $type");
//     if (type == 'Join') {
//     } else if (type == 'unJoin') {
//       getTotalUnreadCount(receiverId);
//     }
//     final map = {
//       'type': 'Customer',
//       'serviceType': type,
//       'UserID': session.userId,
//       'roomID': (int.parse(session.userId) > receiverId!)
//           ? '$receiverId-${session.userId}'
//           : '${session.userId}-$receiverId',
//     };
//     logMe(
//         'Join Exit room socket -- > ${map.toString()}' + 'type is:-->> $type');
//     channel!.sink.add(
//       jsonEncode(map),
//     );

//     // listenToSocket();

//     // dismissLoading();

//     // dismissLoading();
//     // listenRequests();
//   }

//   final chatController = TextEditingController();

//   List<ChatModel> _chatMessagesList = [];

//   int unreadMessageCount = 0;

//   List<ChatModel> get chatMessageList => _chatMessagesList;

//   clearChatList() {
//     _chatMessagesList.clear();
//     _chatMessagesList = [];
//     notifyListeners();
//   }

//   addChatAll(List<ChatModel> list) {
//     _chatMessagesList = list;
//     notifyListeners();
//   }

//   addSingleChat(ChatModel chat) {
//     log("my single chat data is:-->> ${chat}");
//     _chatMessagesList.insert(0, chat);
//     notifyListeners();
//   }

//   updateUnReadMessages({required int count}) {
//     unreadMessageCount = count;

//     log("un read message count is:-->> $unreadMessageCount");
//     notifyListeners();
//   }

//   sendChatMessage({
//     String? message,
//     int? receiverId,
//     String? messageType = 'Text',
//   }) {
//     // final chatProvider = locator<ChatProvider>();
//     final map = {
//       "userID": session.userId,
//       "serviceType": "Chat",
//       "recieverID": receiverId,
//       "msg": message,
//       "room": (int.parse(session.userId) > receiverId!)
//           ? '$receiverId-${session.userId}'
//           : '${session.userId}-$receiverId',
//       "MessageType": "Text",
//       "SenderType": "Customer",
//       "RecieverType": "Driver",
//       "type": "Chat"
//     };
//     print('Message send ---> ${map.toString()}');
//     channel!.sink.add(jsonEncode(map));
//     addSingleChat(
//       ChatModel(
//         id: session.orderId,
//         messageType: 'Text',
//         roomId: (int.parse(session.userId) > receiverId)
//             ? '$receiverId-${session.userId}'
//             : '${session.userId}-$receiverId',
//         message: message,
//         senderType: 'Customer',
//         recieverType: 'Driver',
//         sourceUserId: session.userId,
//         targetUserId: receiverId.toString(),
//         createdOn: DateTime.now(),
//         modifiedOn: DateTime.now(),
//       ),
//     );
//   }

//   //   //Get total number of unread message
//   getTotalUnreadCount(int? receiverId) {
//     log("get total count");
//     final map = {
//       "userID": session.userId,
//       "serviceType": "UnreadCount",
//       "room": (int.parse(session.userId) > receiverId!)
//           ? '$receiverId-${session.userId}'
//           : '${session.userId}-$receiverId',
//       "UserType": 'Customer'
//     };
//     log("get total count:" + map.toString());
//     channel!.sink.add(jsonEncode(map));

//     // listenRequests();
//     // disconnectSocket();
//     // connectToSocket();
//     // listenRequests();
//   }

//   markMessageAsRead({
//     int? receiverId,
//   }) {
//     log("mark message as read  called");
//     final map = {
//       "userID": session.userId,
//       "serviceType": "",
//       "recieverID": receiverId,
//       "room": (int.parse(session.userId) > receiverId!)
//           ? '$receiverId-${session.userId}'
//           : '${session.userId}-$receiverId',
//       "SenderType": "Customer",
//       "RecieverType": "Driver",
//       "type": "read"
//     };

//     log("mark as read ${map}");
//     channel!.sink.add(jsonEncode(map));
//   }
// }
























// // import 'dart:convert';
// // import 'dart:developer';

// // import 'package:flutter/material.dart';
// // import 'package:web_socket_client/web_socket_client.dart';

// // import '../core/utility/helper.dart';
// // import '../core/utility/injection.dart';
// // import '../core/utility/session_helper.dart';
// // import '../features/order/data/models/chat_modal.dart';

// // class NewSocketProvider with ChangeNotifier {
// //   static final NewSocketProvider _singleton = NewSocketProvider._internal();

// //   factory NewSocketProvider() {
// //     return _singleton;
// //   }

// //   NewSocketProvider._internal();

// //   WebSocket? _socket;
// //   final session = locator<Session>();
// //   // final chatProvider = locator<ChatProvider>();

// //   connectToSocket() {
// //     logMe('============= Chat Token ${session.chatToken} ================');

// //     logMe(
// //         'URL --> ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
// //     _socket = WebSocket(Uri.parse(
// //         'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}'));

// //     // logMe(
// //     //     'URL --> ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
// //     // _socket = WebSocket(Uri.parse(
// //     //     'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}'));

// //     logMe('============= Connecting to Socket ================');
// //     _socket!.connection.listen((event) {
// //       logMe('Socket on Listen ---> ${event.toString()}');
// //       if (event is Connected) {
// //         listenRequests();
// //       }
// //     });
// //   }

// //   Future<void> disconnectSocket() async {
// //     _socket!.close();
// //   }

// //   listenRequests() {
// //     // connectToSocket();
// //     logMe('============= Listening to requests ================');
// //     _socket!.messages.listen(
// //       (event) {
// //         final response = jsonDecode(event);
// //         logMe('Message list data-----> ${response.toString()}');
// //         if (response['type'] == 'MessageList') {
// //           log("messgae type is MESSAGE LIST");
// //           logMe('Message list data-----> ${response['data']}');
// //           if (response['data'] != null) {
// //             addChatAll(
// //               List<ChatModel>.from(
// //                 response["data"].map(
// //                   (x) => ChatModel.fromMap(x),
// //                 ),
// //               ),
// //             );
// //             log("chat data is :-->>${chatMessageList.length}");
// //           } else {
// //             addChatAll([]);
// //           }
// //         }
// //         if (response['type'] == 'Chat') {
// //           addSingleChat(
// //             ChatModel.fromMap(
// //               response['data'],
// //             ),
// //           );

// //           log("chat data is :-->>${chatMessageList.length}");
// //         }
// //         if (response['type'] == 'UnreadCount') {
// //           log("unread message count called");

// //           updateUnReadMessages(count: response['data']);
// //         }
// //       },
// //     );
// //   }

// //   rejectRequestSocket() {
// //     final map = {
// //       'serviceType': 'RejectRequest',
// //       'driverID': session.userId,
// //     };
// //     logMe('reject request socket -- > ${map.toString()}');
// //     _socket!.send(
// //       jsonEncode(map),
// //     );
// //   }

// //   acceptRequestSocket() {
// //     final map = {
// //       'serviceType': 'AcceptRequest',
// //       'driverID': session.userId,
// //     };
// //     logMe('reject request socket -- > ${map.toString()}');
// //     _socket!.send(jsonEncode(map));
// //   }

// // //join/unjoin room
// //   joinExitRoom({int? receiverId, required String type}) {
// //     log("join socket called $type");
// //     if (type == 'Join') {
// //       markMessageAsRead(receiverId: receiverId);
// //     } else if (type == 'unJoin') {
// //       getTotalUnreadCount(receiverId);
// //     }
// //     final map = {
// //       'type': 'Customer',
// //       'serviceType': type,
// //       'UserID': session.userId,
// //       'roomID': (int.parse(session.userId) > receiverId!)
// //           ? '$receiverId-${session.userId}'
// //           : '${session.userId}-$receiverId',
// //     };
// //     logMe(
// //         'Join Exit room socket -- > ${map.toString()}' + 'type is:-->> $type');
// //     _socket!.send(
// //       jsonEncode(map),
// //     );

// //     // dismissLoading();

// //     // dismissLoading();
// //     // listenRequests();
// //   }

// //   //Get total number of unread message
// //   getTotalUnreadCount(int? receiverId) {
// //     log("get total count");
// //     final map = {
// //       "userID": session.userId,
// //       "serviceType": "UnreadCount",
// //       "room": (int.parse(session.userId) > receiverId!)
// //           ? '$receiverId-${session.userId}'
// //           : '${session.userId}-$receiverId',
// //       "UserType": 'Customer'
// //     };
// //     log("get total count:" + map.toString());
// //     _socket!.send(jsonEncode(map));

// //     listenRequests();
// //     // disconnectSocket();
// //     // connectToSocket();
// //     // listenRequests();
// //   }

// //   sendChatMessage({
// //     String? message,
// //     int? receiverId,
// //     String? messageType = 'Text',
// //   }) {
// //     // final chatProvider = locator<ChatProvider>();
// //     final map = {
// //       "userID": session.userId,
// //       "serviceType": "Chat",
// //       "recieverID": receiverId,
// //       "msg": message,
// //       "room": (int.parse(session.userId) > receiverId!)
// //           ? '$receiverId-${session.userId}'
// //           : '${session.userId}-$receiverId',
// //       "MessageType": "Text",
// //       "SenderType": "Customer",
// //       "RecieverType": "Driver",
// //       "type": "Chat"
// //     };
// //     print('Message send ---> ${map.toString()}');
// //     _socket!.send(jsonEncode(map));
// //     addSingleChat(
// //       ChatModel(
// //         id: session.orderId,
// //         messageType: 'Text',
// //         roomId: (int.parse(session.userId) > receiverId)
// //             ? '$receiverId-${session.userId}'
// //             : '${session.userId}-$receiverId',
// //         message: message,
// //         senderType: 'Customer',
// //         recieverType: 'Driver',
// //         sourceUserId: session.userId,
// //         targetUserId: receiverId.toString(),
// //         createdOn: DateTime.now(),
// //         modifiedOn: DateTime.now(),
// //       ),
// //     );
// //   }

// //   markMessageAsRead({
// //     int? receiverId,
// //   }) {
// //     log("mark message as read  called");
// //     final map = {
// //       "userID": session.userId,
// //       "serviceType": "",
// //       "recieverID": receiverId,
// //       "room": (int.parse(session.userId) > receiverId!)
// //           ? '$receiverId-${session.userId}'
// //           : '${session.userId}-$receiverId',
// //       "SenderType": "Customer",
// //       "RecieverType": "Driver",
// //       "type": "read"
// //     };
// //     _socket!.send(jsonEncode(map));
// //   }

// //   final chatController = TextEditingController();

// //   List<ChatModel> _chatMessagesList = [];

// //   int unreadMessageCount = 0;

// //   List<ChatModel> get chatMessageList => _chatMessagesList;

// //   clearChatList() {
// //     _chatMessagesList.clear();
// //     _chatMessagesList = [];
// //     notifyListeners();
// //   }

// //   addChatAll(List<ChatModel> list) {
// //     _chatMessagesList = list;
// //     notifyListeners();
// //   }

// //   addSingleChat(ChatModel chat) {
// //     log("my single chat data is:-->> ${chat}");
// //     _chatMessagesList.insert(0, chat);
// //     notifyListeners();
// //   }

// //   updateUnReadMessages({required int count}) {
// //     unreadMessageCount = count;

// //     log("un read message count is:-->> $unreadMessageCount");
// //     notifyListeners();
// //   }
// // }
