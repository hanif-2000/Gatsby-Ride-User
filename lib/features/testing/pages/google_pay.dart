// import 'package:flutter/material.dart';
// import 'package:pay/pay.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: GooglePayButton(
//           paymentConfigurationAsset: 'gpay.json',
//           paymentItems: const [
//             PaymentItem(
//               label: 'Total',
//               amount: '10.00',
//               status: PaymentItemStatus.final_price,
//             )
//           ],
//           type: GooglePayButtonType.pay,
//           margin: const EdgeInsets.only(top: 15.0),
//           onPaymentResult: (result) {
//             log(result.toString());
//           },
//           loadingIndicator: const Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     );
//   }
// }
