import 'dart:developer';

import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/order_provider.dart';
import 'package:GetsbyRideshare/features/testing/widgets/circular_image_container.dart';
import 'package:GetsbyRideshare/features/testing/widgets/common_text.dart';
import 'package:GetsbyRideshare/socket/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utility/helper.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/send_message_textfield.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final socketProvider = locator<SocketProvider>();
  final orderProvider = locator<OrderProvider>();

  final session = locator<Session>();
  @override
  void initState() {
    super.initState();
    socketProvider.joinExitRoom(receiverId: int.parse(session.driverId));
  }

  @override
  void dispose() {
    super.dispose();
    socketProvider.joinExitRoom(
      type: 'UnJoin',
      receiverId: int.parse(session.driverId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<OrderProvider>(
      builder: (context, OrderProvider orderProvider, child) {
        return Scaffold(
          extendBody: false,
          resizeToAvoidBottomInset: true,
          backgroundColor: greyF9F9F9Color,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    backgroundColor: transparentColor,
                    title: Row(
                      children: [
                        CommonCircularImageContainer(
                          height: 45,
                          width: 45,
                          image: orderProvider.driverImg,
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: orderProvider.driverName,
                              fontWeight: FontWeight.w500,
                              fontColor: blackColor,
                              fontFamily: "poPPinMedium",
                              fontSize: 16,
                            ),
                            CommonText(
                              text: appLoc.activeNow,
                              fontWeight: FontWeight.w400,
                              fontColor: blackColor,
                              fontFamily: "poPPinMedium",
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: blackColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        reverse: true,
                        itemCount: socketProvider.data!.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Bubble(
                            message: socketProvider.data!.data![index].message,
                            isMe:
                                socketProvider.data!.data![index].senderType ==
                                        'Customer'
                                    ? false
                                    : true,
                          );
                        },
                      ),
                      SizedBox(
                        height: 90,
                      )
                    ],
                  ),
                )),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
            child: SendMessageTextField(
              onTap: () {
                var msg = socketProvider.msgEditingController.text;
                log("---------msg------  " + msg);

                socketProvider.sendChatMessage(message: msg, receiverId: 1);
                // Provider.of<SocketProvider>(context, listen: true)
                //     .sendChatMessage(message: msg);
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        );
      },
    ));
  }
}
