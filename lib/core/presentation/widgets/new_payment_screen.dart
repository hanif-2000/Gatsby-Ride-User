// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class NewPaymentScreen extends StatefulWidget {
//   const NewPaymentScreen({Key? key}) : super(key: key);

//   @override
//   State<NewPaymentScreen> createState() => _NewPaymentScreenState();
// }

// class _NewPaymentScreenState extends State<NewPaymentScreen> {
//   Future<void> openPaymentSheetWidget() async {
//     try {
//       paymentIntentData = await callPaymentIntentApi('200', 'INR');
//       await Stripe.instance
//           .initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           appearance: PaymentSheetAppearance(
//             primaryButton: const PaymentSheetPrimaryButtonAppearance(
//               colors: PaymentSheetPrimaryButtonTheme(
//                 light: PaymentSheetPrimaryButtonThemeColors(
//                   background: Colors.blue,
//                 ),
//               ),
//             ),
//             colors: PaymentSheetAppearanceColors(background: Colors.blueAccent),
//           ),
//           paymentIntentClientSecret: paymentIntentData!['client_secret'],
//           style: ThemeMode.system,
//           merchantDisplayName: 'Merchant Display Name',
//         ),
//       )
//           .then((value) {
//         showPaymentSheetWidget();
//       });
//     } catch (exe, s) {
//       debugPrint('Exception:$exe$s');
//     }
//   }

//   makingPaymentDataIntentApi(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       debugPrint("Body : $body");
//       var response = await http.post(
//           Uri.parse('https://api.stripe.com/v1/payment_intents'),
//           body: body,
//           headers: {
//             'Authorization': 'Add_Your_Authorization_Token_Here',
//             'Content-Type': 'application/x-www-form-urlencoded'
//           });
//       return jsonDecode(response.body);
//     } catch (err) {
//       debugPrint('callPaymentIntentApi Exception: ${err.toString()}');
//     }
//   }

//   showPaymentSheetWidget() async {
//     try {
//       await Stripe.instance.presentPaymentSheet(
//           // ignore: deprecated_member_use
//           parameters: PresentPaymentSheetParameters(
//         clientSecret: paymentIntentData!['client_secret'],
//         confirmPayment: true,
//       ));
//       setState(() {
//         paymentIntentData = null;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           backgroundColor: Colors.blue,
//           content: Text(
//             "Payment Successfully Completed ",
//             style: TextStyle(color: Colors.white),
//           )));
//     } on StripeException catch (e) {
//       debugPrint('StripeException:  $e');
//       showDialog(
//           context: context,
//           builder: (_) => const AlertDialog(
//                 content: Text("Get Stripe Exception"),
//               ));
//     } catch (e) {
//       debugPrint('$e');
//     }
//   }

//   @override
// initState() {
//   super.initState();
//   StripePayment.setOptions(
//       StripeOptions(        
//          publishableKey:"YOUR_PUBLISHABLE_KEY"
//           merchantId: "YOUR_MERCHANT_ID"
//           androidPayMode: 'test'
// ));
// }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
