// import 'package:GetsbyRideshare/features/order/presentation/widgets/info_driver_widget.dart';
// import 'package:GetsbyRideshare/socket/deryde_folder/chat/provider/test_socket_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BottomContaineOrder extends StatelessWidget {
//   const BottomContaineOrder({
//     Key? key,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TestSocketProvider>(builder: (context, provider, _) {
//       if (provider.currentOrderStatus == 0) {
//         // return Column(
//         //   mainAxisAlignment: MainAxisAlignment.end,
//         //   children: const [ButtonCancelOrder()],
//         // );
//         return SizedBox();
//       } else {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: const [DriverInfoWidget()],
//         );
//       }
//     });
//   }
// }
