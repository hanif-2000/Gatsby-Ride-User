import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/new_card_payment/presentation/providers/payment_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
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
import 'feedback_screen.dart';
import 'payment_configurations.dart' as payment_configurations;

class PaymentScreen extends StatefulWidget {
  final String name;
  final String img;
  final String carModal;
  final String carNo;
  final dynamic totalPrice;
  final int paymentMode;
  final String orderId;
  final String driverId;
  final dynamic grandTotal;
  final String vehicleCategory;

  final dynamic extraDistancePrice;
  final dynamic extraMinPrice;
  final dynamic extraDistance;
  final dynamic extraTime;
  final String distance;

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
    required this.extraDistance,
    required this.extraTime,
    required this.extraDistancePrice,
    required this.extraMinPrice,
    required this.grandTotal,
    required this.vehicleCategory,
    required this.distance,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  var sessionToken = locator<Session>().sessionToken;

  bool isPaymentSuccess = false;

  updatePaymentSuccess() {
    setState(() {
      isPaymentSuccess = true;
    });
  }

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
    // );-
  }
  //   debugPrint(paymentResult.toString());
  // }

  void onApplePayResult(paymentResult) async {
    final token =
        await stripe.Stripe.instance.createApplePayToken(paymentResult);
    log("-->>> Token id is <<<<-----" + token.id);

    var body = {
      'token': token.id,
      'order_id': int.parse(widget.orderId),
      "driver_id": int.parse(widget.driverId),
      "amount": widget.totalPrice
    };

    log("apple card body is-->>  " + body.toString());

    var response = await dio.post(
      'https://php.parastechnologies.in/taxi/public/api/webservice/driver/payment',
      data: body,
      options: Options(headers: {"Authorization": "Bearer $sessionToken"}),
    );

    if (response.data["success"] == 1) {
      updatePaymentSuccess();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Ride Payment Status "),
          content: const Text("Payment successfull"),
          actions: [
            CustomButton(
                isRounded: true,
                text: "Ok",
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
                bgColor: black080808Color)
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Payment unsuccessfull"),
          content: Text(response.data["message"]),
        ),
      );
    }
    log(paymentResult.toString());
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
                    firstText: 'Distance',
                    secondText: "${widget.distance} Km",
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Estimated Amount',
                    secondText: r'$' + widget.totalPrice.toString(),
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Extra Distance',
                    secondText: widget.extraDistance + " Km",
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: widget.vehicleCategory == "2"
                        ? r"Extra Distance Price 1.65$CA/km"
                        : r"Extra Distance Price 1.30$CA/km",
                    secondText: r'$' + widget.extraDistancePrice,
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Extra Time',
                    secondText: widget.extraTime.toString() + ' Min',
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: widget.vehicleCategory == "2"
                        ? r"Extra Time Price 0.35$CA/Min"
                        : r"Extra Time Price 0.30$CA/Min",
                    secondText: r'$' + widget.extraMinPrice,
                  ),
                  // Divider(
                  //   color: whiteAccentColor,
                  // ),

                  // TextInRow(
                  //   secondTextweight: FontWeight.w700,
                  //   firstText: 'Total Distance',
                  //   secondText: r'$' +
                  //       ((double.parse(widget.distance)) +
                  //               (double.parse(widget.extraDistance)))
                  //           .toStringAsFixed(3)
                  //           .toString(),
                  // ),
                  // Divider(
                  //   color: whiteAccentColor,
                  // ),
                  // TextInRow(
                  //   firstText: 'Service Price',
                  //   secondText: r'$0.00',
                  // ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    secondTextweight: FontWeight.w700,
                    firstText: 'Grand Total',
                    secondText: r'$' + widget.grandTotal,
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
                widget.paymentMode == 1
                    ? SvgPicture.asset('assets/icons/cash.svg')
                    : widget.paymentMode == 2
                        ? SvgPicture.asset('assets/icons/card.svg')
                        : widget.paymentMode == 3
                            ? SvgPicture.asset('assets/icons/google.svg')
                            : SvgPicture.asset('assets/icons/apple.svg'),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  widget.paymentMode == 1
                      ? "Cash"
                      : widget.paymentMode == 2
                          ? "Credit Card"
                          : widget.paymentMode == 3
                              ? "Google Pay"
                              : "Apple Pay",
                  style: TextStyle(
                    fontFamily: "poPPinRegular",
                    fontSize: 16.0,
                    color: grey7D7979Color,
                  ),
                )
              ],
            ),

            widget.paymentMode == 2
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
                                    showLoading();
                                    var headers = {
                                      'Content-Type':
                                          'application/x-www-form-urlencoded',
                                      'Authorization':
                                          'Bearer pk_test_51NbHA8L2KkuOUsISsCEKwg1fsZIDBCSHwtMvk9rJXj5fuG8owddgm518RSVnEsyDV1r7sv8KuEf1aXGUh1FgeLcD006NL53v2U',
                                    };
                                    try {
                                      var body = {
                                        "card[number]":
                                            Provider.of<PaymentProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedCardNumber,
                                        "card[exp_month]":
                                            Provider.of<PaymentProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedCardExpiry
                                                .split('/')
                                                .last,
                                        "card[exp_year]":
                                            Provider.of<PaymentProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedCardExpiry
                                                .split('/')
                                                .first,
                                        "card[cvc]": int.parse(
                                            textEditingController.text)
                                      };

                                      log("card token body :===>> $body");
                                      var res = await dio.request(
                                        'https://api.stripe.com/v1/tokens',
                                        options: Options(
                                          method: 'POST',
                                          headers: headers,
                                        ),
                                        data: body,
                                      );

                                      if (res.statusCode == 200) {
                                        log(res.data.toString());
                                        log('token response :-->>${res.data["id"]}');

                                        String cardToken = res.data["id"];

                                        var body = {
                                          'token': cardToken,
                                          'order_id': int.parse(widget.orderId),
                                          "driver_id":
                                              int.parse(widget.driverId),
                                          "amount": widget.totalPrice
                                        };

                                        log(body.toString());

                                        var response = await dio.post(
                                          'https://php.parastechnologies.in/taxi/public/api/webservice/driver/payment',
                                          data: body,
                                          options: Options(headers: {
                                            "Authorization":
                                                "Bearer $sessionToken"
                                          }),
                                        );

                                        if (response.data["success"] == 1) {
                                          updatePaymentSuccess();
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text(
                                                  "Ride Payment Status"),
                                              content: const Text(
                                                  "Payment successful"),
                                              actions: [
                                                CustomButton(
                                                    isRounded: true,
                                                    text: "Ok",
                                                    event: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FeedBackScreen(
                                                            name: widget.name,
                                                            img: widget.img,
                                                            carModal:
                                                                widget.carModal,
                                                            carNo: widget.carNo,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    bgColor: black080808Color)
                                              ],
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text(
                                                  "Payment unsuccessfull"),
                                              content: Text(
                                                  response.data["message"]),
                                            ),
                                          );
                                        }
                                      }

                                      if (res.statusCode == 402) {
                                        dismissLoading();
                                        log("card details incorrect");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text("Card details Incorrect"),
                                        ));
                                      } else {
                                        dismissLoading();
                                        log(res.toString());
                                      }
                                    } catch (e) {
                                      dismissLoading();
                                      log(e.toString());
                                    }
                                  },
                                  bgColor: black080808Color)
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

            widget.paymentMode == 1
                ? CustomButton(
                    text: "Pay With Cash",
                    isRounded: true,
                    event: () async {
                      // var headers = {
                      //   'Content-Type': 'application/x-www-form-urlencoded',
                      //   'Authorization':
                      //       'Bearer pk_test_51NbHA8L2KkuOUsISsCEKwg1fsZIDBCSHwtMvk9rJXj5fuG8owddgm518RSVnEsyDV1r7sv8KuEf1aXGUh1FgeLcD006NL53v2U',
                      // };
                      // var data = {
                      //   'card[number]': '4242424242424242',
                      //   'card[exp_month]': '5',
                      //   'card[exp_year]': '25',
                      //   'card[cvc]': '123'
                      // };
                      // var response = await dio.request(
                      //   'https://api.stripe.com/v1/tokens',
                      //   options: Options(
                      //     method: 'POST',
                      //     headers: headers,
                      //   ),
                      //   data: data,
                      // );

                      // if (response.statusCode == 200) {
                      //   print(json.encode(response.data));
                      // } else {
                      //   print(response.statusMessage);
                      // }

                      // try {
                      //   dio.options.headers['content-Type'] =
                      //       'application/x-www-form-urlencoded';
                      //   dio.options.headers["Authorization"] = "Bearer +$pkToken";
                      //   var body = {
                      //     "card[number]": "4242424242424242",
                      //     "card[exp_month]": int.parse(
                      //         Provider.of<PaymentProvider>(context, listen: false)
                      //             .selectedCardExpiry
                      //             .split('/')
                      //             .last),
                      //     "card[exp_year]": int.parse(
                      //         Provider.of<PaymentProvider>(context, listen: false)
                      //             .selectedCardExpiry
                      //             .split('/')
                      //             .first),
                      //     "card[cvc]": int.parse(textEditingController.text)
                      //   };

                      //   log("card token body :===>> $body");

                      //   var res = await dio.post(
                      //     'https://api.stripe.com/v1/tokens',
                      //     data: body,
                      //   );

                      //   log(res.toString());
                      // } catch (e) {
                      //   log(e.toString());
                      // }
                      ;

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
                  )
                : SizedBox(),

            isPaymentSuccess == true
                ? CustomButton(
                    text: "Give Feedback",
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
                    bgColor: black080808Color)
                : SizedBox(),
            FutureBuilder<PaymentConfiguration>(
                future: _googlePayConfigFuture,
                builder: (context, snapshot) => snapshot.hasData
                    ? (Platform.isAndroid)
                        ? widget.paymentMode != 1
                            ? GooglePayButton(
                                paymentConfiguration: snapshot.data!,
                                paymentItems: _paymentItems,
                                type: GooglePayButtonType.pay,
                                width: _deviceSize.width,
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
                                    updatePaymentSuccess();
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title:
                                            const Text("Ride Payment Status"),
                                        content:
                                            const Text("Payment successfull"),
                                        actions: [
                                          CustomButton(
                                              isRounded: true,
                                              text: "Ok",
                                              event: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FeedBackScreen(
                                                      name: widget.name,
                                                      img: widget.img,
                                                      carModal: widget.carModal,
                                                      carNo: widget.carNo,
                                                    ),
                                                  ),
                                                );
                                              },
                                              bgColor: black080808Color)
                                        ],
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
                        width: _deviceSize.width,
                        height: 50,

                        // paymentConfigurationAsset: 'assets/icons/car.png',
                        paymentConfiguration:
                            PaymentConfiguration.fromJsonString(
                                payment_configurations.defaultApplePay),
                        paymentItems: _paymentItems,

                        style: ApplePayButtonStyle.black,
                        type: ApplePayButtonType.checkout,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: onApplePayResult,
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox()
                : SizedBox(),

            SizedBox(
              height: _deviceSize.height * .1,
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
