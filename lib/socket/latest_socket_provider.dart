import 'dart:convert';
import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/pages/home_page/home_page.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/order_provider.dart';
import 'package:GetsbyRideshare/socket/modals/accept_response_model.dart';
import 'package:GetsbyRideshare/socket/modals/order_status_response_model.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../core/presentation/providers/home_provider.dart';
import '../core/utility/helper.dart';
import '../core/utility/injection.dart';
import '../features/order/data/models/chat_modal.dart';
import 'modals/booking_response_model.dart';

class LatestSocketProvider extends ChangeNotifier {
  static final LatestSocketProvider _provider = LatestSocketProvider.internal();

  factory LatestSocketProvider() {
    return _provider;
  }

  LatestSocketProvider.internal();
  final session = locator<Session>();
  var _homeProvider = locator<HomeProvider>();
  var _orderProvider = locator<OrderProvider>();

  var unreadCount = '0';
  final chatController = TextEditingController();
  BuildContext currentCxt =
      locator<GlobalKey<NavigatorState>>().currentContext!;

  List<ChatModel> _chatMessagesList = [];
  int currentOrderStatus = 0;

  int unreadMessageCount = 0;
  bool isLoading = false;
  BookingDataModel? bookingDataModel;
  AcceptResponseModel? acceptResponseModel;

  List<ChatModel> get chatMessageList => _chatMessagesList;
  OrderStatusResponseModel? orderStatusResponseModel;

  updateUnreadCount(val) {
    unreadCount = val;
    notifyListeners();

    log("unrad count :-->> $unreadCount");
  }

  //
  WebSocket? _socket;

  // -----> function to connect the socket <--------- //
  Future<dynamic> connectToSocket(BuildContext context) async {
    log("-------->CONNECTING TO SOCKET <--------");
    log('-------> uri === ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
    _socket = WebSocket(Uri.parse(
        "ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}"));
    _socket!.connection.listen((event) {
      if (event is Connected) {
        log("************ Connectd ***********");
        listenSocketRequests(context);
      } else if (event is Connecting) {
        log("************ Connecting ***********");
      } else if (event is Disconnected) {
        log("************ DisConnectd ***********");
      } else if (event is Reconnecting) {
        log("************ ReConnecting ***********");
      } else {
        log("-----******** EVENT IS **** ${event}");
      }
    });
  }

  Future<void> disconnectSocket() async {
    _socket!.close();
  }

  joinExitRoom({int? receiverId, required String type}) {
    markMessageAsRead(receiverId: receiverId);
    log("join socket called $type");
    if (type == 'Join') {
      isLoading = true;
      notifyListeners();
    } else if (type == 'unJoin') {
      getTotalUnreadCount(receiverId);
      // clearChatList();
    }
    // if (type == 'join') {
    //   markMessageAsRead(receiverId: receiverId);
    // }
    final map = {
      'type': 'Customer',
      'serviceType': type,
      'UserID': session.userId,
      'roomID': (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
    };
    logMe('Join Exit room socket -- > ${map.toString()}');
    _socket!.send(
      jsonEncode(map),
    );
    // listenRequests();
  }

  void listenSocketRequests(BuildContext context) {
    _socket!.messages.listen((event) {
      //  Decoding data
      final response = jsonDecode(event);
      log('-----Event  ${response.toString()}');

      // <----------- Checking When request come ---------> //
      if (response['type'] == 'CustomerBookRequest') {
        bookingDataModel = BookingDataModel.fromJson(response);
        // bookingList.add(bookingDataModel!.data);

        log("order id is :--->> ${bookingDataModel!.data.id} and Customer Id  is:--->> ${bookingDataModel!.data.customerId}");
        print(
            "order id is :--->> ${bookingDataModel!.data.id} and Customer Id  is:--->> ${bookingDataModel!.data.customerId}");

        if (bookingDataModel!.data.customerId == session.userId) {
          session.setOrderId = bookingDataModel!.data.id;
        }

        notifyListeners();
      }

      /// *************** RIDE ACCEPTED ********* -------

      if (response['type'] == 'Accept') {
        log("****************************      DRIVER ACCEPTED THE RIDE *************************");
        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setDriverId = acceptResponseModel!.data.driverId;
        session.setOrderStatus = 1;
        currentOrderStatus = 1;

        notifyListeners();

        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** DEPARTURE TO CUSTOMER ********* -------
      if (response['type'] == 'DepartToCustomer') {
        log("****************************      DRIVER DEPARTURE TO CUSTOMER *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setOrderStatus = 2;
        session.setDriverId = acceptResponseModel!.data.driverId;

        currentOrderStatus = 2;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** REACH TO CUSTOMER LOCATION  ********* -------
      if (response['type'] == 'reachLocation') {
        log("****************************      DRIVER REACH YOUR LOCATION *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setOrderStatus = 3;
        session.setDriverId = acceptResponseModel!.data.driverId;

        currentOrderStatus = 3;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** START TRIP  ********* -------

      if (response['type'] == 'startTrip') {
        log("****************************      DRIVER START THE RIDE *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setOrderStatus = 5;
        session.setDriverId = acceptResponseModel!.data.driverId;

        currentOrderStatus = 5;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** END TRIP  ********* -------

      if (response['type'] == 'endTrip') {
        log("****************************      DRIVER END THE RIDE *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setOrderStatus = 7;
        currentOrderStatus = 7;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** DRIVER CANCEL THE RIDE  ********* -------

      if (response['type'] == 'Reject') {
        log("****************************      DRIVER CANCEL THE RIDE *************************");

        if (response["data"]["driverID"] != null) {
          acceptResponseModel = AcceptResponseModel.fromJson(response);
          session.setOrderId = acceptResponseModel!.data.id;
          session.setOrderStatus = 8;
          currentOrderStatus = 8;

          notifyListeners();
          showDialog(
            context: currentCxt,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("Ride is Cancelled by the Driver"),
                // content: new Text("sdf"),
                actions: [
                  // usually buttons at the bottom of the dialog
                  ElevatedButton(
                    child: Text("Find Next Driver"),
                    onPressed: () async {
                      await _homeProvider.clearState();
                      await _orderProvider.clearState();
                      Navigator.pop(context);

                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);

                      // Navigator.of(currentCxt).pop();
                      // Navigator.pushAndRemoveUntil(
                      //     currentCxt,
                      //     MaterialPageRoute(
                      //       builder: (currentCxt) => HomePage(),
                      //     ),
                      //     (route) => false);
                    },
                  ),
                ],
              );
            },
          );
          log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
        }
      }

      // <----------- Checking When request come ---------> //
      if (response['type'] == 'MessageList') {
        isLoading = false;
        notifyListeners();
        log("messgae type is MESSAGE LIST");
        log('Message list data-----> ${response['data']}');

        if (response['data'] != null) {
          addChatAll(
            List<ChatModel>.from(
              response["data"].map(
                (x) => ChatModel.fromMap(x),
              ),
            ),
          );
          // dismissLoading();
          log("chat data is :-->>${chatMessageList.length}");
        } else {
          addChatAll([]);
          // dismissLoading();
        }
      }
      if (response['type'] == 'Chat') {
        addSingleChat(
          ChatModel.fromMap(
            response['data'],
          ),
        );

        log("chat data is :-->>${chatMessageList.length}");
      }
      if (response['type'] == 'UnreadCount') {
        log("unread message count called");

        updateUnReadMessages(count: response['data']);
      }

      log('-----Event  ${response.toString()}');
    });
  }

  addChatAll(List<ChatModel> list) {
    _chatMessagesList = list;
    notifyListeners();
  }

  addSingleChat(ChatModel chat) {
    log("my single chat data is:-->> $chat");
    _chatMessagesList.insert(0, chat);
    notifyListeners();
  }

  updateUnReadMessages({required int count}) {
    unreadMessageCount = count;

    log("un read message count is:-->> $unreadMessageCount");
    notifyListeners();
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
    addSingleChat(
      ChatModel(
        id: session.orderId,
        messageType: 'Text',
        roomId: (int.parse(session.userId) > receiverId)
            ? '$receiverId-${session.userId}'
            : '${session.userId}-$receiverId',
        message: message,
        senderType: 'Customer',
        recieverType: 'Driver',
        sourceUserId: session.userId,
        targetUserId: receiverId.toString(),
        createdOn: DateTime.now(),
        modifiedOn: DateTime.now(),
      ),
    );
  }

  //   //Get total number of unread message
  getTotalUnreadCount(int? receiverId) {
    log("get total count");
    final map = {
      "userID": session.userId,
      "serviceType": "UnreadCount",
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "UserType": 'Customer'
    };
    log("get total count:" + map.toString());
    _socket!.send(jsonEncode(map));

    // listenRequests();
    // disconnectSocket();
    // connectToSocket();
    // listenRequests();
  }

  markMessageAsRead({
    int? receiverId,
  }) {
    log("mark message as read  called");
    final map = {
      "userID": session.userId,
      "serviceType": "",
      "recieverID": receiverId,
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "SenderType": "Customer",
      "RecieverType": "Driver",
      "type": "read"
    };

    log("mark as read $map");
    _socket!.send(jsonEncode(map));
  }

  clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  rejectRequestSocket() {
    final map = {
      'serviceType': 'RejectRequest',
      'driverID': session.userId,
    };
    logMe('reject request socket -- > ${map.toString()}');
    _socket!.send(
      jsonEncode(map),
    );
  }

  acceptRequestSocket() {
    final map = {
      'serviceType': 'AcceptRequest',
      'driverID': session.userId,
    };
    logMe('reject request socket -- > ${map.toString()}');
    _socket!.send(jsonEncode(map));
  }

  /** Send RIDE REQUEST to Drivers **/

  Future<bool> createRideRequest({
    required originLatLng,
    required destinationLatLng,
    required vehicleCatagory,
    required startAddress,
    required endAddress,
    required estimatedTime,
    required distance,
    required total,
    required payment_method,
  }) async {
    try {
      final map = {
        'serviceType': 'UserBookDriver',
        'UserID': session.userId,
        'vehicle_category_id': vehicleCatagory,
        'start_coordinate': originLatLng,
        'end_coordinate': destinationLatLng,
        'start_address': startAddress,
        'end_address': endAddress,
        'estimated_time': estimatedTime,
        'distance': distance,
        'total': total,
        'payment_method': payment_method,
      };

      logMe('Send New ride request -- > ${map.toString()}');
      _socket!.send(jsonEncode(map));

      return true;
    } catch (e) {
      print('Error creating ride request: $e');
      return false;
    }
  }

  // Future<bool>createRideRequest({
  //   required originLatLng,
  //   required destinationLatLng,
  //   required vehicleCatagory,
  //   required startAddress,
  //   required endAddress,
  //   required estimatedTime,
  //   required distance,
  //   required total,
  //   required payment_method,
  // }) {
  //   final map = {
  //     'serviceType': 'UserBookDriver',
  //     'UserID': session.userId,
  //     'vehicle_category_id': vehicleCatagory,
  //     'start_coordinate': originLatLng,
  //     'end_coordinate': destinationLatLng,
  //     'start_address': startAddress,
  //     'end_address': endAddress,
  //     'estimated_time': estimatedTime,
  //     'distance': distance,
  //     'total': total,
  //     'payment_method': payment_method,
  //   };

  //   logMe('Send New ride request -- > ${map.toString()}');
  //   _socket!.send(jsonEncode(map));

  // }

  /// * UPDATE LAT LONG --------->>>>>..

  updateLatLng(double lat, double long) async {
    print("current latlong:${lat},${long}");

    final map = {
      'serviceType': 'UpdatedLatLong',
      'UserID': session.userId,
      'type': 'customer',
      'Latitude': lat,
      'Longitude': long,
      'OrderID': session.orderId
    };
    logMe('UPADTE LATLONG -- > ${map.toString()}');
    print('UPADTE LATLONG -- > ${map.toString()}');

    _socket!.send(jsonEncode(map));
  }

  /** -------------------*************************** CANCEL RIDE BY CUSTOMER  ******************----------------- */

  Future<bool> cancelRideByCustomer() async {
    try {
      final map = {
        'serviceType': 'CancelByUser',
        'UserID': session.userId,
        'OrderID': session.orderId
      };
      logMe('cancelRideByCustomer -- > ${map.toString()}');
      print('cancelRideByCustomer -- > ${map.toString()}');

      _socket!.send(jsonEncode(map));

      return true;
    } catch (e) {
      return false;
    }
  }
}
