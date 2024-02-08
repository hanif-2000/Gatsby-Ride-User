// import 'package:GetsbyRideshare/core/utility/helper.dart';
// import 'package:GetsbyRideshare/socket/deryde_folder/booking_socket_provider.dart';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ChatBottomTextfeildView extends StatelessWidget {
//   const ChatBottomTextfeildView({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SocketProvider>(builder: (context, sendMesasgs, _) {
//       return Column(
//         children: [
//           Container(
//             height: 1,
//             width: MediaQuery.of(context).size.width,
//             color: Colors.white,
//           ),
//           Container(
//             color: Colors.amber,
//             child: Padding(
//               padding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 10, bottom: 10),
//               child: Column(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.06,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                         color: Colors.white12,
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: sendMesasgs.messageCnt,
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Enter message...",
//                                   hintStyle: TextStyle(
//                                       // fontFamily: FontMixin.regularFamily,
//                                       // fontWeight: FontMixin.fontWeightRegular,
//                                       fontSize: 16,
//                                       color: Colors.black)),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               if (sendMesasgs.messageCnt.text
//                                   .trim()
//                                   .isNotEmpty) {
//                                 sendMesasgs.sendMessage(
//                                     message:
//                                         sendMesasgs.messageCnt.text.trim());
//                               } else {
//                                 showToast(message: "enter message");
//                               }
//                             },
//                             child: SizedBox(
//                               height: 25,
//                               width: 25,
//                               child: Icon(Icons.send),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
