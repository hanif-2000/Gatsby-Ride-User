import 'package:GetsbyRideshare/socket/deryde_folder/booking_socket_provider.dart';
import 'package:GetsbyRideshare/socket/deryde_folder/chat/widget/chat_bottom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utility/injection.dart';
import '../text_widget.dart';

class ChatView extends StatefulWidget {
  final String? image;
  final String? name;

  const ChatView({Key? key, this.image, this.name}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  var socketProvider = Provider.of<SocketProvider>(
      locator<GlobalKey<NavigatorState>>().currentContext!);

  void initState() {
    // TODO: implement initState
    super.initState();
    socketProvider.connectToSocketInBooking(context);
    socketProvider.joinRoom();
    socketProvider.listenGetChat();
    Provider.of<SocketProvider>(context, listen: false).listenGetChat();
  }

  @override
  void dispose() {
    socketProvider.ExitRoom();
    socketProvider.updateUnreadCount("0");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const ChatTopView(),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: const Offset(2, 0),
                    blurRadius: 50,
                    spreadRadius: 0,
                    color: Colors.red)
              ]),
            ),
            Expanded(
              flex: 4,
              child: Consumer<SocketProvider>(builder: (context, provider, _) {
                return Container(
                  color: Colors.green,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      provider.chatList.length < 1
                          ? Center(
                              child: Text("No New Messages"),
                            )
                          : Expanded(
                              child: CustomScrollView(
                                reverse: true,
                                slivers: [
                                  SliverList(delegate:
                                      SliverChildBuilderDelegate(
                                          (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: provider
                                                  .chatList[index].senderType !=
                                              'Driver'
                                          ? Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    15),
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15)),
                                                    color: Colors.black),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: TextWidget(
                                                    msg: provider
                                                        .chatList[index]
                                                        .message,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    15),
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15)),
                                                    color: Colors.white),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: TextWidget(
                                                    msg: provider
                                                        .chatList[index]
                                                        .message,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    );
                                  }))
                                  // SliverList(
                                  //     delegate: SliverChildBuilderDelegate(
                                  //         childCount: provider.chatList.length,
                                  //         (context, index) {
                                  //   // return Padding(
                                  //   //   padding:  EdgeInsets.all(10.0),
                                  //   //   child: provider.chatList[index].senderType !=
                                  //   //           'Driver'
                                  //   //       ? Align(
                                  //   //           alignment: Alignment.topRight,
                                  //   //           child: Container(
                                  //   //             constraints: BoxConstraints(
                                  //   //                 maxWidth:
                                  //   //                     MediaQuery.of(context).size.width * 0.7),
                                  //   //             decoration:  BoxDecoration(
                                  //   //                 borderRadius: BorderRadius.only(
                                  //   //                     topRight: Radius.circular(15),
                                  //   //                     topLeft: Radius.circular(15),
                                  //   //                     bottomLeft:
                                  //   //                         Radius.circular(0),
                                  //   //                     bottomRight:
                                  //   //                         Radius.circular(15)),
                                  //   //                 color: Colors.black),
                                  //   //             child: Padding(
                                  //   //               padding:  EdgeInsets.all(15.0),
                                  //   //               child: TextWidget(
                                  //   //                 msg: provider
                                  //   //                     .chatList[index].message,
                                  //   //                 color: Colors.white,
                                  //   //               ),
                                  //   //             ),
                                  //   //           ),
                                  //   //         )
                                  //   //       : Align(
                                  //   //           alignment: Alignment.topLeft,
                                  //   //           child: Container(
                                  //   //             constraints: BoxConstraints(
                                  //   //                 maxWidth:
                                  //   //                     MediaQuery.of(context).size.width * 0.7),
                                  //   //             decoration: const BoxDecoration(
                                  //   //                 borderRadius: BorderRadius.only(
                                  //   //                     topRight: Radius.circular(15),
                                  //   //                     topLeft: Radius.circular(15),
                                  //   //                     bottomLeft:
                                  //   //                         Radius.circular(15)),
                                  //   //                 color: Colors.white),
                                  //   //             child: Padding(
                                  //   //               padding: const EdgeInsets.all(15.0),
                                  //   //               child: TextWidget(
                                  //   //                 msg: provider
                                  //   //                     .chatList[index].message,
                                  //   //                 color: Colors.blue,
                                  //   //               ),
                                  //   //             ),
                                  //   //           ),
                                  //   //         ),
                                  //   // );

                                  // }))
                                ],
                              ),
                            ),
                      const ChatBottomTextfeildView()
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
