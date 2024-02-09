import 'dart:developer';

import 'package:GetsbyRideshare/socket/deryde_folder/chat/provider/test_socket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../../core/static/assets.dart';
import '../../../../../core/static/colors.dart';
import '../../../../../core/static/styles.dart';
import '../../../../../core/utility/helper.dart';
import '../../../../../core/utility/injection.dart';
import '../../../../../core/utility/session_helper.dart';
import '../../../../testing/widgets/circular_image_container.dart';
import '../../../../testing/widgets/common_text.dart';
import '../../widgets/receiver_tile.dart';
import '../../widgets/sender_tile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    // this.chatDetail
  }) : super(key: key);
  // final ChatDetail? chatDetail;
  static const routeName = '/ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  var socketProvider = locator<TestSocketProvider>();

  // var orderProvider = locator<OrderProvider>();
  // var chatProvider = locator<ChatProvider>();
  var session = locator<Session>();

  @override
  void initState() {
    super.initState();

    // socketProvider.connectToSocket(context);

    WidgetsBinding.instance.addObserver(this);

    print("init in chat page called");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("WidgetsBinding");
      socketProvider.joinExitRoom(
          context: context,
          receiverId: int.parse(session.driverId),
          type: "Join");
    });

    // socketProvider.JoinExitRoomListen(context: context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log(" app lifecycle state is ------>>>>>>>   $state");
    if (state == AppLifecycleState.paused) {
      socketProvider.joinExitRoom(
        context: context,
        type: 'unJoin',
        receiverId: int.parse(session.driverId),
      );
    } else if (state == AppLifecycleState.resumed) {
      socketProvider.joinExitRoom(
          context: context,
          receiverId: int.parse(session.driverId),
          type: 'Join');
    }
  }

  // @override
  // void dispose() {
  //   log("dispoase called");

  //   super.dispose();

  //   // socketProvider.joinExitRoom(
  //   //   context: context,
  //   //   type: 'unJoin',
  //   //   receiverId: int.parse(session.driverId),
  //   // );
  //   // socketProvider.updateUnReadMessages(count: 0);

  //   WidgetsBinding.instance.removeObserver(this);
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TestSocketProvider(),
      child: SafeArea(
        child: Consumer<TestSocketProvider>(
            builder: (context, latestSocketProvider, _) {
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
                        automaticallyImplyLeading: true,
                        centerTitle: false,
                        backgroundColor: transparentColor,
                        title: Row(
                          children: [
                            // Text(
                            //   "fasd",
                            //   style: TextStyle(color: Colors.black),
                            // ),
                            CommonCircularImageContainer(
                              height: 45,
                              width: 45,
                              image: socketProvider.acceptResponseModel?.data
                                          .profilePhoto !=
                                      null
                                  ? latestSocketProvider
                                      .acceptResponseModel!.data.profilePhoto
                                  : '',
                            ),
                            SizedBox(
                              width: 11,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  text: latestSocketProvider
                                      .driverDetailResponseModel!.message.name
                                      .toString(),
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
                            // Text(
                            //   socketProvider.connectionStatus.toString(),
                            //   style: TextStyle(color: Colors.black),
                            // )
                          ],
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: blackColor,
                          ),
                          onPressed: () {
                            socketProvider.joinExitRoom(
                                type: 'unJoin',
                                context: context,
                                receiverId: int.parse(session.driverId));
                            socketProvider.updateUnReadMessages(count: 0);

                            log("on click on go back");

                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // backgroundColor: Colors.grey,
              body:
                  // Consumer<LatestSocketProvider>(builder: (context, provider, _) {

                  //   return
                  Visibility(
                visible: latestSocketProvider.isLoading,
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CupertinoActivityIndicator(
                      color: black15141FColor,
                    ),
                  ),
                ),
                replacement: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: latestSocketProvider.chatMessageList.isEmpty
                              ? Center(
                                  child: Lottie.asset(
                                      'assets/lottie_animation/chat_empty_animation.json'))
                              : ListView.builder(
                                  reverse: true,
                                  itemCount: latestSocketProvider
                                      .chatMessageList.length,
                                  itemBuilder: (context, index) {
                                    return latestSocketProvider
                                                .chatMessageList[index]
                                                .senderType ==
                                            'Driver'
                                        ? ReceiverTile(
                                            title: latestSocketProvider
                                                .chatMessageList[index].message,
                                          )
                                        : SenderTile(
                                            title: latestSocketProvider
                                                .chatMessageList[index].message,
                                          );
                                  },
                                ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 26),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 6),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: latestSocketProvider.chatController,
                              decoration: InputDecoration(
                                  hintText: 'Enter message...',
                                  hintStyle: titleStyle.copyWith(
                                    fontSize: 14,
                                    color: blackColor,
                                  )
                                  // .usePoppinsW4Font(),
                                  // border: InputBorder.none,
                                  ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (latestSocketProvider.chatController.text
                                  .trim()
                                  .isEmpty) {
                                showToast(message: "Please enter your message");
                              } else {
                                ///TODO: send the message
                                latestSocketProvider.sendChatMessage(
                                    message: latestSocketProvider
                                        .chatController.text
                                        .trim(),
                                    receiverId: int.parse(session.driverId));
                                latestSocketProvider.chatController.text = '';
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset(
                                sendIcon,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
    // },
    // ));
  }
}
