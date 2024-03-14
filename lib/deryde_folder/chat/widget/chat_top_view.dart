
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// import '../../booking_socket_provider.dart';

// class ChatTopView extends StatefulWidget {
//   const ChatTopView({Key? key});

//   @override
//   State<ChatTopView> createState() => _ChatTopViewState();
// }

// class _ChatTopViewState extends State<ChatTopView> {
//   void navigate() {
//     /*   navigatorKey.currentState!
//         .push(MaterialPageRoute(builder: ((context) => const CarReceiptScreen())));*/
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Consumer<SocketProvider>(builder: (context, pro, _) {
//         return Row(
//           children: [
//             InkWell(
//               onTap: () {
//                 /* Future.delayed(const Duration(seconds: 5), navigate);*/
//                 Navigator.pop(context);
//               },
//               child: const Icon(
//                 Icons.arrow_back_sharp,
//                 color: AppColors.color15141F,
//               ),
//             ),
//             context.sizeW(3),
//             Container(
//               height: context.screenHeight * 0.065,
//               width: context.screenHeight * 0.065,
//               decoration: const BoxDecoration(shape: BoxShape.circle),
//               child: ClipOval(
//                   child: Image.network(
//                 '${NetworkConstant.imageBaseUrl}${pro.driverDetailModel!.data?.profile_photo}',
//                 fit: BoxFit.fill, /*Image.asset(AppImagesPath.dummyUserImage*/
//               )),
//             ),
//             context.sizeW(3),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextWidget(
//                   msg: pro.driverDetailModel?.data?.name,
//                   font: FontMixin.mediumFamily,
//                   fontWeight: FontMixin.fontWeightMedium,
//                   textSize: 18,
//                   color: AppColors.color001E00,
//                 ),
//                 TextWidget(
//                   msg: AppStrings.activeNow,
//                   font: FontMixin.regularFamily,
//                   fontWeight: FontMixin.fontWeightRegular,
//                   textSize: 14,
//                   color: AppColors.color5E6D55,
//                 ),
//               ],
//             )
//           ],
//         );
//       }),
//     );
//   }
// }
