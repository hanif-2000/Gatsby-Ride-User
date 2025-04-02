// ================ NewPaymentScreen ================

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class NewPaymentScreen extends StatefulWidget {
  const NewPaymentScreen({Key? key}) : super(key: key);

  @override
  State<NewPaymentScreen> createState() => _NewPaymentScreenState();
}

class _NewPaymentScreenState extends State<NewPaymentScreen> {
  Map<String, dynamic>? paymentIntent;
  var clientkey =
      "sk_test_51NbHA8L2KkuOUsISb7LUBs3SVvCSJO5fNUgfc0YqzZlnKUdF6nFECHw75PMkYAxHPopJToObrFXu1z445rC7jI6P00H8ZXzRRz"; // Secret Key

  var publishableKey =
      'pk_live_51NbHA8L2KkuOUsISLMZg8rgdOQ4Po3VKyiOsWjmxY2N5FQUM0ggbFdXFoJ0H06sdaCVj1yGCw9Qcf6CvjhTF3erW00Q1GUJ0sH';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Buy Premium Membership at 10 INR"),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.teal,
              margin: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () => createCardToken(),
                child: const Text(
                  'Pay',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      // TODO: Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        // 'payment_method_types[]': 'card'
      };

      // TODO: POST request to stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ' + clientkey,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      log('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      log('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  Future<void> makePayment() async {
    try {
      // TODO: Create Payment intent
      paymentIntent = await createPaymentIntent('1000', 'INR');

      // TODO: Initialte Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          // applePay: PaymentSheetApplePay(merchantCountryCode: 'usd'),

          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'IN',
            testEnv: true,
          ),

          style: ThemeMode.light,
          merchantDisplayName: 'someMerchantName',
        ),
      )
          .then((value) {
        log("Success");
      });

      // TODO: now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      String ss = "exception 1 :$e";
      String s2 = "reason :$s";
      log("exception 1:$e");
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    Text("Payment Successfull"),
                  ],
                ),
              ],
            ),
          ),
        );

        // TODO: update payment intent to null
        paymentIntent = null;
      }).onError((error, stackTrace) {
        String ss = "exception 2 :$error";
        String s2 = "reason :$stackTrace";
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      String ss = "exception 3 :$e";
    } catch (e) {
      log('$e');
    }
  }

  /** New stripe */

  Future<void> createCardToken() async {
    // Replace with your actual secret API key

    var publishableKey =
        'pk_live_51NbHA8L2KkuOUsISLMZg8rgdOQ4Po3VKyiOsWjmxY2N5FQUM0ggbFdXFoJ0H06sdaCVj1yGCw9Qcf6CvjhTF3erW00Q1GUJ0sH';
    final String apiKey =
        'sk_test_51NbHA8L2KkuOUsISb7LUBs3SVvCSJO5fNUgfc0YqzZlnKUdF6nFECHw75PMkYAxHPopJToObrFXu1z445rC7jI6P00H8ZXzRRz';

    // Set the API endpoint
    final String apiUrl = 'https://api.stripe.com/v1/tokens';

    // Replace with actual card details
    final Map<String, dynamic> cardDetails = {
      'card': {
        'number': '4242424242424242',
        'exp_month': 8,
        'exp_year': 2024,
        'cvc': '314',
      },
    };

    // Encode card details to JSON
    final String cardJson = jsonEncode(cardDetails);

    // Create headers with the Stripe API key
    final Map<String, String> headers = {
      'Authorization': 'Basic c2tfdGVzdF80ZUMzOUhxTHlqV0Rhcmp0VDF6ZHA3ZGM6',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: {
          'card[number]': '4242424242424242',
          'card[exp_month]': '08',
          'card[exp_year]': '2030',
          'card[cvc]': '315'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['id'];
        print('Card Token: $token');
      } else {
        print('Error creating card token. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error creating card token: $error');
    }
  }

  createCardTokenNew() async {
// CreateTokenParams createTokenParams ={
//             'number': '4242424242424242',
//                 'exp_month': 8,
//                 'exp_year': 2024,
//                 'cvc': '314',
// };
    var publishableKey =
        'pk_live_51NbHA8L2KkuOUsISLMZg8rgdOQ4Po3VKyiOsWjmxY2N5FQUM0ggbFdXFoJ0H06sdaCVj1yGCw9Qcf6CvjhTF3erW00Q1GUJ0sH';
    final String apiKey =
        'sk_test_51NbHA8L2KkuOUsISb7LUBs3SVvCSJO5fNUgfc0YqzZlnKUdF6nFECHw75PMkYAxHPopJToObrFXu1z445rC7jI6P00H8ZXzRRz';

    Stripe.stripeAccountId = apiKey;
    Stripe.publishableKey = publishableKey;

    var token = await Stripe.instance
        .createToken(
      CreateTokenParams.card(
        params: CardTokenParams.fromJson({
          'number': '4242424242424242',
          'exp_month': 11,
          'exp_year': 2024,
          'cvc': '314',
        }),
      ),
    )
        .then((value) {
      log(value.toString());
    });

    //  await Stripe.tokens.create({
    //   card: {
    //     number: '4242424242424242',
    //     exp_month: 8,
    //     exp_year: 2024,
    //     cvc: '314',
    //   },
    // });
  }

  // Future<void> onGooglePayResult(paymentResult) async {
  //   final response = await fetchPaymentIntentClientSecret();
  //   final clientSecret = response['clientSecret'];
  //   final token =
  //       paymentResult['paymentMethodData']['tokenizationData']['token'];
  //   final tokenJson = Map.castFrom(json.decode(token));

  //   final params = PaymentMethodParams.cardFromToken(
  //     token: tokenJson['id'],
  //   );
  //   // Confirm Google pay payment method
  //   await Stripe.instance.confirmPayment(
  //     clientSecret,
  //     params,
  //   );
  // }
}
