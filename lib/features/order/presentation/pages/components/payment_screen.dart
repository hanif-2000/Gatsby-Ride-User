import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:GetsbyRideshare/features/new_card_payment/presentation/providers/payment_provider.dart';
import 'package:provider/provider.dart';

import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utility/injection.dart';
import '../../../../../core/utility/session_helper.dart';
import '../../../../testing/widgets/common_text.dart';
import '../../../../testing/widgets/text_in_row.dart';
import 'package:pay/pay.dart';
import 'payment_configurations.dart' as payment_configurations;
import 'feedback_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String name;
  final String img;
  final String carModal;
  final String carNo;
  final int totalPrice;
  final int paymentMode;
  final String orderId;
  final String driverId;

  const PaymentScreen({
    Key? key,
    required this.name,
    required this.img,
    required this.carModal,
    required this.carNo,
    required this.totalPrice,
    required this.paymentMode,
    required this.orderId,
    required this.driverId,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  var sessionToken = locator<Session>().sessionToken;

  var _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  TextEditingController textEditingController = TextEditingController();

  var pkToken =
      "pk_test_51NbHA8L2KkuOUsISsCEKwg1fsZIDBCSHwtMvk9rJXj5fuG8owddgm518RSVnEsyDV1r7sv8KuEf1aXGUh1FgeLcD006NL53v2U";

  Future<void> onGooglePayResult(paymentResult) async {
    // final response = await fetchPaymentIntentClientSecret();
    // final clientSecret = response['clientSecret'];
    // final token = paymentResult['paymentMethodData']['tokenizationData']['token'];
    // final tokenJson = Map.castFrom(json.decode(token));

    // final params = PaymentMethodParams.cardFromToken(
    //   token: tokenJson['id'],
    // );
    // // Confirm Google pay payment method
    // await Stripe.instance.confirmPayment(
    //   clientSecret,
    //   params,
    // );
  }
  //   debugPrint(paymentResult.toString());
  // }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');
  }

  var dio = Dio();
  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          "Payment",
          style: TextStyle(
              fontFamily: "poPPinSemiBold", fontSize: 18.0, color: blackColor),
        ),
        centerTitle: true,
        elevation: 1.0,
        shadowColor: whiteColor.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: "Payment Information",
              fontWeight: FontWeight.w600,
              fontColor: blackColor,
              fontFamily: "poPPinMedium",
              fontSize: 16,
            ),
            Container(
              decoration: BoxDecoration(
                color: greyB2B2B2Color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  EdgeInsets.only(top: 13, bottom: 13, left: 11, right: 11),
              child: Column(
                children: [
                  TextInRow(
                    firstText: 'Price',
                    secondText: r'$' + widget.totalPrice.toString(),
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Service Price',
                    secondText: r'$0.00',
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    secondTextweight: FontWeight.w700,
                    firstText: 'Total Price',
                    secondText: r'$' + widget.totalPrice.toString(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _deviceSize.height * .02),
              child: Text(
                "Payment Through",
                style: TextStyle(
                  fontFamily: "poPPinMedium",
                  fontSize: 13.0,
                  color: grey7D7979Color,
                ),
              ),
            ),
            Row(
              children: [
                SvgPicture.asset('assets/icons/cash.svg'),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  widget.paymentMode == 0 ? "Cash" : "Online",
                  style: TextStyle(
                    fontFamily: "poPPinRegular",
                    fontSize: 16.0,
                    color: grey7D7979Color,
                  ),
                )
              ],
            ),

            widget.paymentMode != 1
                ? CustomButton(
                    borderColor: black080808Color,
                    text: "Pay With Card *******" +
                        (Provider.of<PaymentProvider>(context, listen: false)
                                .selectedCardNumber)
                            .substring(Provider.of<PaymentProvider>(context,
                                        listen: false)
                                    .selectedCardNumber
                                    .length -
                                4),
                    isRounded: true,
                    event: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Enter CVC'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {},
                              controller: textEditingController,
                              decoration:
                                  InputDecoration(hintText: "Enter CVC"),
                            ),
                            actions: [
                              CustomButton(
                                  text: "Pay",
                                  event: () async {
                                    var body = {
                                      "card[number]":
                                          Provider.of<PaymentProvider>(context,
                                                  listen: false)
                                              .selectedCardNumber,
                                      "card[exp_month]":
                                          Provider.of<PaymentProvider>(context,
                                                  listen: false)
                                              .selectedCardExpiry
                                              .split('/')
                                              .first,
                                      "card[exp_year]":
                                          Provider.of<PaymentProvider>(context,
                                                  listen: false)
                                              .selectedCardExpiry
                                              .split('/')
                                              .last,
                                      "card[cvc]":
                                          int.parse(textEditingController.text)
                                    };

                                    var res = await dio.post(
                                        'https://api.stripe.com/v1/tokens',
                                        data: body,
                                        options: Options(headers: {
                                          "Authorization": "Bearer $pkToken"
                                        }));

                                    log(res.toString());
                                  },
                                  bgColor: bgGreyColor)
                            ],
                          );
                        },
                      );
                      // var body = {
                      //   "card[number]":
                      //       Provider.of<PaymentProvider>(context, listen: false)
                      //           .selectedCardNumber,
                      //   "card[exp_month]":
                      //       Provider.of<PaymentProvider>(context, listen: false)
                      //           .selectedCardExpiry
                      //           .split('/')
                      //           .first,
                      //   "card[exp_year]":
                      //       Provider.of<PaymentProvider>(context, listen: false)
                      //           .selectedCardExpiry
                      //           .split('/')
                      //           .last,
                      //   "card[cvc]": 123
                      // };

                      // var res = await dio.post(
                      //     'https://api.stripe.com/v1/tokens',
                      //     data: body,
                      //     options: Options(
                      //         headers: {"Authorization": "Bearer $pkToken"}));

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => FeedBackScreen(
                      //       name: widget.name,
                      //       img: widget.img,
                      //       carModal: widget.carModal,
                      //       carNo: widget.carNo,
                      //     ),
                      //   ),
                      // );
                    },
                    bgColor: grey606060Color,
                  )
                : SizedBox(),

            Spacer(),
            CustomButton(
              text: "Pay Now",
              isRounded: true,
              event: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedBackScreen(
                      name: widget.name,
                      img: widget.img,
                      carModal: widget.carModal,
                      carNo: widget.carNo,
                    ),
                  ),
                );
              },
              bgColor: blackColor,
            ),

            FutureBuilder<PaymentConfiguration>(
                future: _googlePayConfigFuture,
                builder: (context, snapshot) => snapshot.hasData
                    ? (Platform.isAndroid)
                        ? widget.paymentMode != 1
                            ? GooglePayButton(
                                paymentConfiguration: snapshot.data!,
                                paymentItems: _paymentItems,
                                type: GooglePayButtonType.buy,
                                margin: const EdgeInsets.only(top: 15.0),
                                onPaymentResult: (result) async {
                                  log("result is: $result");

                                  log(snapshot.data.toString());

                                  String token = result['paymentMethodData']
                                      ['tokenizationData']['token'];
                                  log("token is-->>>$token");

                                  final tokenJson =
                                      Map.castFrom(json.decode(token));

                                  log("token json is ${tokenJson['id']}");

                                  var cardToken = tokenJson['id'];

                                  var body = {
                                    'token': cardToken,
                                    'order_id': int.parse(widget.orderId),
                                    "driver_id": int.parse(widget.driverId),
                                    "amount": widget.totalPrice
                                  };

                                  log(body.toString());

                                  var response = await dio.post(
                                    'https://php.parastechnologies.in/taxi/public/api/webservice/driver/payment',
                                    data: body,
                                    options: Options(headers: {
                                      "Authorization": "Bearer $sessionToken"
                                    }),
                                  );

                                  if (response.data["success"] == 1) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Ride Payment"),
                                        content:
                                            const Text("Payment successfull"),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title:
                                            const Text("Payment unsuccessfull"),
                                        content: Text(response.data["message"]),
                                      ),
                                    );
                                  }
                                },
                                loadingIndicator: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : SizedBox()
                        : SizedBox()
                    : const SizedBox.shrink()),
            // Example pay button configured using a string
            (Platform.isIOS)
                ? widget.paymentMode != 1
                    ? ApplePayButton(
                        // paymentConfigurationAsset: 'assets/icons/car.png',
                        paymentConfiguration:
                            PaymentConfiguration.fromJsonString(
                                payment_configurations.defaultApplePay),
                        paymentItems: _paymentItems,

                        style: ApplePayButtonStyle.black,
                        type: ApplePayButtonType.buy,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: onApplePayResult,
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox()
                : SizedBox(),

            SizedBox(
              height: 0,
            )

            // GooglePayButton(
            //   paymentConfigurationAsset: 'google_pay_config.json',
            //   paymentItems: _paymentItems,
            //   style: GooglePayButtonStyle.black,
            //   type: GooglePayButtonType.pay,
            //   margin: const EdgeInsets.only(top: 15.0),
            //   onPaymentResult: onGooglePayResult,
            //   loadingIndicator: const Center(
            //     child: CircularProgressIndicator(),
            //   ),
            // )

            // // Example pay button configured using an asset
            // FutureBuilder<PaymentConfiguration>(
            //     future: _googlePayConfigFuture,
            //     builder: (context, snapshot) => snapshot.hasData
            //         ? GooglePayButton(
            //             paymentConfiguration: snapshot.data!,
            //             paymentItems: _paymentItems,
            //             type: GooglePayButtonType.buy,
            //             margin: const EdgeInsets.only(top: 15.0),
            //             onPaymentResult: onGooglePayResult,
            //             loadingIndicator: const Center(
            //               child: CircularProgressIndicator(),
            //             ),
            //           )
            //         : const SizedBox.shrink()),
            // // Example pay button configured using a string
            // ApplePayButton(
            //   paymentConfiguration: PaymentConfiguration.fromJsonString(
            //       payment_configurations.defaultApplePay),
            //   paymentItems: _paymentItems,
            //   style: ApplePayButtonStyle.black,
            //   type: ApplePayButtonType.buy,
            //   margin: const EdgeInsets.only(top: 15.0),
            //   onPaymentResult: onApplePayResult,
            //   loadingIndicator: const Center(
            //     child: CircularProgressIndicator(),
            //   ),
            // ),
            // const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
