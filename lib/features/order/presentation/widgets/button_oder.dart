
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
// import '../../../../core/static/colors.dart';
// import '../../../../core/utility/helper.dart';
// import '../providers/order_provider.dart';


// class ChatDetail {
//   String? userName;
//   String? userPhoto;
//   int? userId;

//   ChatDetail(this.userName, this.userPhoto, this.userId);
// }

// class ButtonOrder extends StatelessWidget {
//   const ButtonOrder({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<OrderProvider>(
//       builder: (context, provider, _) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//             // color: const Color.fromRGBO(0, 0, 0, 0.2),
//             color: whiteColor,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               // provider.orderDetail != null
//               //     ? Padding(
//               //         padding: const EdgeInsets.symmetric(
//               //           vertical: 8.0,
//               //           horizontal: 8.0,
//               //         ),
//               //         child: Card(
//               //           child: Padding(
//               //             padding: const EdgeInsets.symmetric(
//               //               vertical: 8.0,
//               //               horizontal: 20.0,
//               //             ),
//               //             child: SizedBox(
//               //               height: 50,
//               //               child: Row(
//               //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               //                 children: <Widget>[
//               //                   Expanded(
//               //                     flex: 5,
//               //                     child: Row(
//               //                       children: [
//               //                         Expanded(
//               //                           child: AutoSizeText(
//               //                             appLoc.distance,
//               //                             style: const TextStyle(
//               //                               fontWeight: FontWeight.normal,
//               //                             ),
//               //                             minFontSize: 15,
//               //                             maxFontSize: 18,
//               //                             maxLines: 1,
//               //                             overflow: TextOverflow.ellipsis,
//               //                           ),
//               //                         ),
//               //                         Expanded(
//               //                           child: AutoSizeText(
//               //                             mergeDistanceTxt(
//               //                                 provider.orderDetail!.distance),
//               //                             style: const TextStyle(
//               //                               fontWeight: FontWeight.bold,
//               //                               color: primaryColor,
//               //                             ),
//               //                             minFontSize: 16,
//               //                             maxFontSize: 20,
//               //                             maxLines: 1,
//               //                             overflow: TextOverflow.ellipsis,
//               //                           ),
//               //                         )
//               //                       ],
//               //                     ),
//               //                   ),
//               //                   Padding(
//               //                     padding:
//               //                         const EdgeInsets.symmetric(horizontal: 5),
//               //                     child: SizedBox(
//               //                       width: 1,
//               //                       child: Container(
//               //                         color: Colors.grey[350],
//               //                       ),
//               //                     ),
//               //                   ),
//               //                   const SizedBox(
//               //                     width: 8,
//               //                   ),
//               //                   Expanded(
//               //                     flex: 5,
//               //                     child: Container(
//               //                       child: Align(
//               //                         alignment: Alignment.centerLeft,
//               //                         child: Row(
//               //                           children: [
//               //                             Expanded(
//               //                               child: AutoSizeText(
//               //                                 appLoc.price,
//               //                                 style: const TextStyle(
//               //                                   fontWeight: FontWeight.normal,
//               //                                 ),
//               //                                 minFontSize: 15,
//               //                                 maxFontSize: 18,
//               //                                 maxLines: 1,
//               //                                 overflow: TextOverflow.ellipsis,
//               //                               ),
//               //                             ),
//               //                             Expanded(
//               //                               child: AutoSizeText(
//               //                                 mergePriceTxt(provider
//               //                                     .orderDetail!.totalPrice
//               //                                     .toString()),
//               //                                 style: const TextStyle(
//               //                                   fontWeight: FontWeight.bold,
//               //                                   color: primaryColor,
//               //                                 ),
//               //                                 minFontSize: 16,
//               //                                 maxFontSize: 20,
//               //                                 maxLines: 1,
//               //                                 overflow: TextOverflow.ellipsis,
//               //                               ),
//               //                             )
//               //                           ],
//               //                         ),
//               //                       ),
//               //                     ),
//               //                   )
//               //                 ],
//               //               ),
//               //             ),
//               //           ),
//               //         ),
//               //       )
//               //     : const SizedBox(),
//               // const UserProfileTile(),
//               mediumVerticalSpacing(),
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomButton(
//                       image: 'assets/icons/order/ic_call.svg',
//                       text: Text(
//                         'Call now',
//                         style: txtButtonStyle,
//                       ),
//                       event: () {
//                         provider.callCustomer();
//                       },
//                       buttonHeight: 48,
//                       isRounded: true,
//                       bgColor: green2DAA5F,
//                     ),
//                   ),
//                   smallHorizontalSpacing(),
//                   Expanded(
//                     child: CustomButton(
//                       image: 'assets/icons/order/ic_message.svg',
//                       text: Text(
//                         'Message',
//                         style: txtButtonStyle,
//                       ),
//                       event: () {
//                         Navigator.pushNamed(context, ChatPage.routeName,
//                             arguments: ChatDetail(
//                               provider.customerDetail!.data.name,
//                               provider.customerDetail!.data.photo,
//                               provider.customerDetail!.data.id,
//                             ));
//                       },
//                       buttonHeight: 48,
//                       isRounded: true,
//                       bgColor: blue249DE0,
//                     ),
//                   ),
//                 ],
//               ),
//               mediumVerticalSpacing(),
//               CustomButton(
//                   text: Text(
//                     provider.orderStatus.getString(),
//                     style: txtButtonStyle,
//                   ),
//                   event: () {
//                     provider.submitStatusOrder().listen(
//                       (event) async {
//                         if (event is UpdateStatusOrderLoaded) {
//                           if (provider.orderStatus ==
//                               OrderStatus.arriveAtCustomerPlace) {
//                             // showDialog(
//                             //   barrierDismissible: false,
//                             //   context: context,
//                             //   builder: (context) {
//                             //     return WillPopScope(
//                             //       onWillPop: () async => false,
//                             //       child: DepartDialog(
//                             //         callback: (b, call) {
//                             //           if (call) {
//                             //             provider.callCustomer();
//                             //           }
//                             //         },
//                             //       ),
//                             //     );
//                             //   },
//                             // );
//                           }
//                         }
//                       },
//                     );
//                   },
//                   buttonHeight: 48,
//                   isRounded: true,
//                   bgColor: Colors.black),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
