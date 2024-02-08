// // import 'package:flutter/foundation.dart';
// // import 'package:web_socket_client/web_socket_client.dart';

// // import '../core/utility/injection.dart';
// // import '../core/utility/session_helper.dart';

// // class BookingSocketProvider with ChangeNotifier {
// //   final session = locator<Session>();
// //   WebSocket? _socket;
// //   connectToSocket() {
// //     _socket = WebSocket(
// //       Uri.parse(
// //         "ws://shakti.parastechnologies.in:8052?token=452761566&userID=18",
// //       ),
// //       pingInterval: Duration(seconds: 5),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui' as ui;

// import 'package:GetsbyRideshare/core/utility/helper.dart';
// import 'package:GetsbyRideshare/socket/deryde_folder/chat/model/chat_list_model.dart';
// import 'package:GetsbyRideshare/socket/deryde_folder/chat/model/get_chat_model.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:web_socket_client/web_socket_client.dart';

// class SocketProvider extends ChangeNotifier {
//   // static final SocketProvider _provider = SocketProvider.internal();

//   // factory SocketProvider() {
//   //   return _provider;
//   // }

//   // SocketProvider.internal();

//   var customerId = '14';
//   var driverId = '57';
//   var roomId = '14-57';
//   var orderId = '387';

//   // getImage() async {
//   //   final Uint8List markerImage =
//   //       await getImageForMap(AppImagesPath.carMarker, 80);
//   // }

//   // final locationProvider = locator<LocationProvider>();

//   Future<Uint8List> getImageForMap(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   /** Update order status Text */

//   updateOrderStatusText({required String val}) {
//     if (val == "1") {
//       reachedLocation = "Reach Location";
//     } else if (val == "3") {
//       reachedLocation = "Start Trip";
//     } else if (val == "5") {
//       reachedLocation = "End Trip";
//     } else if (val == "7") {
//       // log("${Provider.of<RideInProgressProvider>(  navigatorKey.currentState!.context).receiptModel?.order?.id??""}");
//       // Navigator.push(
//       //                               navigatorKey.currentState!.context,
//       //                               MaterialPageRoute(
//       //                                   builder: (context) => CarReceiptScreen(
//       //                                         orderrId: Provider.of<RideInProgressProvider>(context).receiptModel?.order?.id??""
//       //                                       )));
//       reachedLocation = "";
//     }
//     notifyListeners();
//   }

//   ///
//   WebSocket? _socket;

//   LatLng driverLatLng = const LatLng(0.0, 0.0);

//   // -----> function to connect the socket <--------- //
//   Future<dynamic> connectToSocketInBooking(BuildContext context) async {
//     print("booking socket -------->CONNECTING TO SOCKET <--------");
//     log('-------> uri === "ws://shakti.parastechnologies.in:8052?token=1396527211&userID=14');
//     print(
//         'booking socket -------> uri === "ws://shakti.parastechnologies.in:8052?token=1396527211&userID=14');
//     _socket = WebSocket(Uri.parse(
//         'ws://shakti.parastechnologies.in:8052?token=1396527211&userID=14'));

//     _socket!.connection.listen((event) {
//       if (event is Connected) {
//         print("booking socket ************ Connectd ***********");
//         showToast(message: "B: Disconnected");

//         listenSocketRequests(context);
//         //      listenGetChat();
//         // postCurrentPosition(context);
//       } else if (event is Disconnected) {
//         showToast(message: "B: Disconnected");
//         print("booking socket ************ DisConnectd ***********");
//       } else if (event is Connecting) {
//         showToast(message: "B: Connecting");

//         print("booking socket ************ Connecting ***********");
//       } else if (event is Reconnecting) {
//         showToast(message: "B: Reconnecting");

//         print("booking socket ************ Reconnecting ***********");
//       } else if (event is Reconnected) {
//         showToast(message: "B: Reconnected");

//         print("booking socket ************ Reconnected ***********");
//       } else {
//         showToast(message: "B: ${_socket!.connection.state}");

//         print(
//             "booking socket ************ ${_socket!.connection.state} ***********");
//       }
//     });
//   }

//   // <------------ Listen To Socket Request Chat --------> //

//   void listenGetChat() {
//     final map = {
//       'serviceType': 'GetChat',
//       'roomID': roomId,
//       'user_id': customerId,
//       'reciever_id': driverId,
//       'userType': 'Customer',
//     };
//     // print('---kkk----${jsonDecode(map.toString())}');
//     _socket!.send(json.encode(map));
//     try {
//       _socket!.connection.listen((event) {
//         if (event is Connected) {
//           _socket!.send(json.encode(map));
//           print('---kkk----${map.toString()}');
//           notifyListeners();
//         }
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   void disconnect() {
//     _socket!.connection.listen((event) {
//       if (event is Connected) {
//         _socket!.close();
//       }
//     });
//   }

//   // <------------ Send Message  Chat --------> //
//   sendMessage({
//     String? message,
//   }) {
//     final map = {
//       'userID': customerId,
//       'recieverID': driverId,
//       'msg': message,
//       'room': roomId,
//       'MessageType': "Text",
//       'SenderType': 'Customer',
//       'RecieverType': 'Driver',
//       'serviceType': 'Chat',
//       'type': 'Chat',
//       'payment_method': '2'
//     };
//     print('---------message send--------${map.toString()}');
//     _socket!.send(jsonEncode(map));
//     messageCnt.text = '';
//     chatList.insert(
//         0,
//         ChatModel(
//             message: message,
//             // senderId: customerId,
//             // receiverId: driverDetailModel?.data?.driverID,
//             createdOn: DateTime.now(),
//             messageType: 'Text',
//             id: orderId,
//             recieverType: "Driver",
//             roomId: roomId,
//             senderType: 'Customer'));
//     notifyListeners();
//   }

//   var unreadCount = '0';

//   updateUnreadCount(val) {
//     unreadCount = val;
//     notifyListeners();

//     log("unrad count :-->> $unreadCount");
//   }

//   // <------------ Listen To Socket Request --------> //

//   void listenSocketRequests(BuildContext context) {
//     _socket!.messages.listen((event) {
//       //  Decoding data
//       final response = jsonDecode(event);
//       print("---Event${response.toString()}");
//       print("ride status ========> ${response['type']}");

//       if (response['type'] == 'Accept') {
//         // driverDetailModel = DriverDetailModel.fromJson(response);
//         // orderrId = driverDetailModel?.data?.id;
//         // log("oder id ==>${orderrId}");
//         // Provider.of<SharedPreferencesManager>(context, listen: false)
//         //     .setorderId(orderrId);
//         // log("--order id checking -->    ${SharedPreferencesManager().oderid}");
//         // print('dfgdfszgdfgdfg ${driverDetailModel?.data?.name}');
//         // print('dfgdfszgdfgdfg ${driverDetailModel?.data?.driverID}');
//         // log("custoer id check===>${driverDetailModel?.data?.id}");
//         // if (driverDetailModel?.data?.profile_photo != null) {
//         //   ExitRoom();

//         //   // //    Navigator.pop(context);
//         //   Navigator.pushAndRemoveUntil(
//         //       context,
//         //       MaterialPageRoute(
//         //           builder: (context) => const DriverRequestAcceptView()),
//         //       (route) => false);
//         //   //   //  Navigator.pushNamed(context, DriverRequestAcceptView.routeName,);
//         //   notifyListeners();
//         // }
//       } else if (response['type'] == 'GetChat') {
//         print('----k---${response.toString()}');
//         getChatModel = GetChatModel.fromJson(response);
//         chatList.clear();
//         for (var element in getChatModel!.data!) {
//           chatList.add(ChatModel(
//               message: element.message,
//               senderId: int.tryParse(element.senderId.toString()),
//               receiverId: int.tryParse(element.receiverId.toString()),
//               senderType: element.senderType));
//         }
//         //  notifyListeners();
//         print(chatList.length);
//       } else if (response['type'] == 'UnreadCount') {
//         updateUnreadCount(response["data"].toString());
//         notifyListeners();
//       } else if (response['type'] == 'UpdatedLatLong') {
//         // driverUpdateLatLng = UpdateLatLngResponseModels.fromJson(response);

//         // driverLatLng =
//         //     LatLng(driverUpdateLatLng!.latitude, driverUpdateLatLng!.longitude);
//         // locationProvider.updateDriverCoordinates(driverLatLng);
//         // locationProvider.updateBookingFlowDriverCoordinates(Marker(
//         //   infoWindow: const InfoWindow(title: "driver"),
//         //   icon: BitmapDescriptor.defaultMarker,
//         //   // icon: BitmapDescriptor.fromBytes(
//         //   //     size: const Size(2, 2)),
//         //   markerId: const MarkerId("DRIVER"),
//         //   position: driverLatLng,
//         // ));
//         // locationProvider.updatePolylineWithSocket();

//         // notifyListeners();

//         // locationProvider.updateMarkerList(Marker(
//         //   infoWindow: const InfoWindow(title: "driver"),
//         //   icon: BitmapDescriptor.defaultMarker,
//         //   // icon: BitmapDescriptor.fromBytes(
//         //   //     size: const Size(2, 2)),
//         //   markerId: const MarkerId("DRIVER"),
//         //   position: driverLatLng,
//         // ));

//         // markerList?.add(Marker(
//         //   infoWindow: const InfoWindow(title: "source"),
//         //   icon: BitmapDescriptor.defaultMarker,
//         //   // icon: BitmapDescriptor.fromBytes(
//         //   //     size: const Size(2, 2)),
//         //   markerId: const MarkerId("DRIVER"),
//         //   position: driverLatLng,
//         // ));
//       } else if (response['type'] == 'CustomerBookRequest') {
//         reachedLocation = "Driver is Arriving Soon! ";
//         // driverDetailModel = DriverDetailModel.fromJson(response);
//         // print(' request ${driverDetailModel?.data?.name}');
//         notifyListeners();
//       } else if (response['type'] == 'reachLocation') {
//         reachedLocation = "Driver has reached your location";
//         startCountdown(300);
//         // locationProvider.updateIsWithDriver();
//         notifyListeners();
//       } else if (response['type'] == 'startTrip') {
//         reachedLocation = "Driver has started trip";
//         notifyListeners();
//       } else if (response['type'] == 'endTrip') {
//         // SharedPreferencesManager().remove("orderId");
//         log("context is not null");
//         // locationProvider.updateIsWithDriver(value: false);
//         driverLatLng = LatLng(0, 0);
//         // locationProvider.updateDriverCoordinates(driverLatLng);

//         // navigatorKey.currentState!.push(MaterialPageRoute(
//         //     builder: ((context) => CarReceiptScreen(
//         //           orderrId: orderrId,
//         //         ))));

//         //    navigatorKey.currentState!.pushAndRemoveUntil( MaterialPageRoute(builder:(context)=> const DriverRequestAcceptView()),
//         //       (route) => false);
//       } else if (response['type'] == 'Chat') {
//         // chatList.insert(
//         //     0,
//         //     ChatModel(
//         //         message: response['data']['message'],
//         //         senderId:
//         //             int.parse(response['data']['source_user_id'].toString()),
//         //         receiverId: int.parse(customerId),
//         //         senderType: 'Driver',
//         //         createdOn: DateTime.now()));
//         // notifyListeners();
//         // print({"--Chat-$response.toString()"});
//       }
//       /*     else if(response['type']=='Reject'){
//         navigatorKey.currentState!.push(MaterialPageRoute(builder: ((context) => const HomeView())));
//         notifyListeners();
//       }*/
//       else if (response['type'] == 'Cancel') {
//         // showDialog(
//         //     context: navigatorKey.currentState!.context,
//         //     builder: (context) {
//         //       return AlertDialog(
//         //         shape: RoundedRectangleBorder(
//         //             borderRadius: BorderRadius.circular(20)),
//         //         title: SizedBox(
//         //             height: MediaQuery.of(context).size.height * 0.1,
//         //             width: MediaQuery.of(context).size.height * 0.18,
//         //             child: AppImagesPath.logoPath.image()),
//         //         content: Row(
//         //           mainAxisAlignment: MainAxisAlignment.center,
//         //           children: [
//         //             TextWidget(
//         //               msg: "Ride Cancelled by  the Driver",
//         //               color: AppColors.color001E00,
//         //               font: FontMixin.boldFamily,
//         //               fontWeight: FontMixin.fontWeightRegular,
//         //               maxLine: 1,
//         //               textSize: 15,
//         //             ),
//         //           ],
//         //         ),
//         //         actions: <Widget>[
//         //           Row(
//         //             mainAxisAlignment: MainAxisAlignment.center,
//         //             children: [
//         //               ButtonWidget(
//         //                 width: 160,
//         //                 height: 40,
//         //                 msg: "Find New Driver",
//         //                 fontColor: AppColors.colorWhite,
//         //                 callback: () {
//         //                   removeItem();
//         //                   homeprovider.dropText.clear();
//         //                   homeProvider.pickUpText.clear();
//         //                   homeProvider.clearController();
//         //                   navigatorKey.currentState!.push(MaterialPageRoute(
//         //                       builder: ((context) => const HomeView())));

//         //                   notifyListeners();
//         //                 },
//         //               ),
//         //             ],
//         //           ),
//         //           Container(
//         //             height: 10,
//         //           ),
//         //         ],
//         //       );
//         //     });
//         // /*    navigatorKey.currentState!.push(MaterialPageRoute(builder: ((context) => const HomeView())));
//         //  notifyListeners();*/
//       }

//       /*else{
//          ModalBottomSheet.moreModalBottomSheet(
//           context,
//           const RequestRideView(),
//           isExpendable: false,
//           // topBorderRadius: 0,
//           padding: EdgeInsets.zero,
//          );
//        }*/

//       //  print('-----Event  ${event.toString()}');
//     });
//   }

//   // void removeItem() {
//   //   // clearChat();
//   //   chatList.clear();
//   //   notifyListeners();
//   // }

//   // DriverDetailModel? driverDetailModel;

//   // CustomerReceiptModel? customerReceiptModel;
//   // UpdateLatLngResponseModels? driverUpdateLatLng;

//   var reachedLocation = "";
//   var orderrId;

//   List<ChatModel> chatList = [];
//   TextEditingController messageCnt = TextEditingController();
//   GetChatModel? getChatModel;

//   addChatAll(List<ChatModel> list) {
//     chatList = list;
//     notifyListeners();
//   }

//   // updateDriverDetailsModel({required DriverDetailModel val}) {
//   //   driverDetailModel = val;
//   //   notifyListeners();
//   // }

//   // updateOrderDetailsModel({required O val}){

//   // driverDetailModel=val;
//   // notifyListeners();
//   // }

//   String? newTime;

//   // <------------ BOOK TAXI --------------> //

//   // <------------ Join room  --------> //
//   joinRoom() {
//     // print('----${type}');
//     final map = {
//       'UserID': customerId,
//       'type': 'Customer',
//       'serviceType': 'Join',
//       'roomID': roomId
//     };
//     try {
//       _socket!.connection.listen((event) {
//         if (event is Connected) {
//           _socket!.send(jsonEncode(map));
//           print('--join room----${map.toString()}');
//           listenGetChat();
//           notifyListeners();
//         }
//       });
//     } catch (e) {
//       print(map.toString());
//     }
//   }

//   // <------------ Exit room  --------> //
//   ExitRoom() {
//     final map = {
//       'UserID': customerId,
//       'roomID': roomId,
//       'type': 'Customer',
//       'serviceType': 'unJoin',
//     };
//     print(map);
//     try {
//       _socket!.connection.listen((event) {
//         if (event is Connected) {
//           _socket!.send(jsonEncode(map));
//           print("sjbj");
//           notifyListeners();
//         }
//       });
//     } catch (e) {}
//   }

//   /// <---------- Clear Chat Function -------> ///
//   // void clearChat() {
//   //   final ctx = navigatorKey.currentContext;
//   //   if (ctx != null && (ctx.mounted)) {
//   //     final d =
//   //         Provider.of<ReceiptScrerenProvider>(ctx, listen: false).receiptModel;
//   //     final map = {
//   //       'serviceType': "ClearChat",
//   //       'user_id': customerId,
//   //       'type': 'Customer',
//   //       "other_user_id": d?.orderReceipt?.driverId ?? "",
//   //     };

//   //     try {
//   //       _socket!.connection.listen((event) {
//   //         if (event is Connected) {
//   //           _socket!.send(json.encode(map));
//   //           print("************Clear Chat***********");
//   //           print(map.toString());

//   //           notifyListeners();
//   //         }
//   //       });
//   //     } catch (e) {
//   //       print(e.toString());
//   //     }
//   //   }
//   // }

//   bool timerReached = false;
//   late Timer _timer;
//   int seconds = 0;

//   void startCountdown(int durationInSeconds) {
//     seconds = durationInSeconds;
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (seconds == 0) {
//           timerReached = false;
//           notifyListeners();
//         } else {
//           timerReached = true;
//           seconds--;
//           notifyListeners();
//         }
//       },
//     );
//   }

// /* UserID
//  roomID
//  type=Customer||Driver
// serviceType=Join



// userID
// recieverID
// msg
// room
// MessageType
// SenderType=Customer|| Driver
// RecieverType=Customer|| Driver
// type=Chat || read

//  joinExitRoom({int? receiverId, String type = 'Join'}) {
//    // markMessageAsRead(receiverId: receiverId);
//     print("join socket called $type");
//     if (type == 'Join') {
//     } else if (type == 'unJoin') {
//    //   getTotalUnreadCount(receiverId);
//       // clearChatList();
//     }
//     final map = {
//       'type': 'Driver',
//       'serviceType': type,
//       'UserID': customerId,
//       'roomID': (int.parse(session.userId) > receiverId!)
//           ? '$receiverId-${session.userId}'
//           : '${session.userId}-$receiverId',
//     };
//     logMe('Join Exit room socket -- > ${map.toString()}' 'type is:-->> $type');
//     channel!.sink.add(
//       jsonEncode(map),
//     );

//     // dismissLoading();

//     // dismissLoading();
//     // listenRequests();
//   }*/
// }
