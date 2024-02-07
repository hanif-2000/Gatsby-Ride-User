import 'dart:developer';

import 'package:GetsbyRideshare/socket/latest_socket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  var socketProvider = Provider.of<LatestSocketProvider>(
      locator<GlobalKey<NavigatorState>>().currentContext!,
      listen: false);

  // var orderProvider = locator<OrderProvider>();
  // var chatProvider = locator<ChatProvider>();
  var session = locator<Session>();

  @override
  void initState() {
    super.initState();
    socketProvider.connectToSocket(context);

    WidgetsBinding.instance.addObserver(this);

    print("init in chat page called");

    socketProvider..JoinExitRoomListen(context: context);

    // socketProvider.joinExitRoom(
    //     context: context,
    //     receiverId: int.parse(session.driverId),
    //     type: "Join");
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

  @override
  void dispose() {
    log("dispoase called");

    super.dispose();

    socketProvider.joinExitRoom(
      context: context,
      type: 'unJoin',
      receiverId: int.parse(session.driverId),
    );
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<LatestSocketProvider>(
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
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    backgroundColor: transparentColor,
                    title: Row(
                      children: [
                        Text(
                          "fasd",
                          style: TextStyle(color: Colors.black),
                        ),
                        CommonCircularImageContainer(
                          height: 45,
                          width: 45,
                          image: Provider.of<LatestSocketProvider>(context,
                                          listen: true)
                                      .acceptResponseModel
                                      ?.data
                                      .profilePhoto !=
                                  null
                              ? Provider.of<LatestSocketProvider>(context,
                                      listen: true)
                                  .acceptResponseModel!
                                  .data
                                  .profilePhoto
                              : '',
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: Provider.of<LatestSocketProvider>(context,
                                      listen: true)
                                  .driverDetailResponseModel!
                                  .message
                                  .name
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
                        Text(
                          socketProvider.connectionStatus.toString(),
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: blackColor,
                      ),
                      onPressed: () {
                        log("on click on go back");

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // backgroundColor: Colors.grey,
          body: Consumer<LatestSocketProvider>(builder: (context, provider, _) {
            return Visibility(
              visible: Provider.of<LatestSocketProvider>(context, listen: true)
                  .isLoading,
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
                  // Container(
                  //   padding: const EdgeInsets.only(top: 40),
                  //   decoration: const BoxDecoration(
                  //     color: Colors.white,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(top: 20, bottom: 16),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             IconButton(
                  //               onPressed: () {
                  //                 Navigator.pop(context);
                  //               },
                  //               icon: SvgPicture.asset(
                  //                 'assets/icons/auth/ic_back.svg',
                  //               ),
                  //             ),
                  //             smallHorizontalSpacing(),
                  //             Container(
                  //               height: 50,
                  //               width: 50,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: Colors.red,
                  //                 //   image: DecorationImage(
                  //                 //       image: NetworkImage(
                  //                 //         '$BASE_URL${widget.chatDetail!.userPhoto}',
                  //                 //       ),
                  //                 //       fit: BoxFit.cover
                  //                 // ),
                  //               ),
                  //             ),
                  //             mediumHorizontalSpacing(),
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text('${orderProvider.driverName}',
                  //                     textAlign: TextAlign.center,
                  //                     style: titleStyle.copyWith(
                  //                       fontSize: 16,
                  //                     )
                  //                     // .usePoppinsW5Font(),
                  //                     ),
                  //                 // Text(
                  //                 //   'Active now',
                  //                 //   textAlign: TextAlign.center,
                  //                 //   style: titleStyle
                  //                 //       .copyWith(fontSize: 12, color: greyB6B6B6)
                  //                 //       .usePoppinsW4Font(),
                  //                 // ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  Expanded(
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: provider.chatMessageList.isEmpty
                            ? const Center(
                                child: Text('No messages'),
                              )
                            : ListView.builder(
                                reverse: true,
                                itemCount: provider.chatMessageList.length,
                                itemBuilder: (context, index) {
                                  return provider.chatMessageList[index]
                                              .senderType ==
                                          'Driver'
                                      ? ReceiverTile(
                                          title: provider
                                              .chatMessageList[index].message,
                                        )
                                      : SenderTile(
                                          title: provider
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: provider.chatController,
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
                            if (provider.chatController.text.trim().isEmpty) {
                              showToast(message: "Please enter your message");
                            } else {
                              ///TODO: send the message
                              Provider.of<LatestSocketProvider>(context,
                                      listen: true)
                                  .sendChatMessage(
                                      message:
                                          provider.chatController.text.trim(),
                                      receiverId: int.parse(session.driverId));
                              provider.chatController.text = '';
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
            );
          }),
        );
      },
    ));
  }
}
