import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:GetsbyRideshare/core/utility/app_settings.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/new_card_payment/presentation/providers/payment_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utility/duration_helper.dart';
import '../../../../../core/utility/dynamic_toasstring_helper.dart';
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
  final String vehicleCategory;
  final dynamic pendingAmount;
  final dynamic newTotal;

  final dynamic extraDistancePrice;
  final dynamic actualDistancePrice;

  final dynamic extraTimePrice;
  final dynamic extraDistance;
  final dynamic extraTime;
  final String distance;
  final dynamic pricePerMin;
  final dynamic pricePerKm;
  final dynamic techFee;
  final dynamic baseFare;
  final dynamic minimumFare;
  final dynamic timeTaken;
  final dynamic distanceTravelled;

  const PaymentScreen(
      {Key? key,
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
      required this.extraTimePrice,
      required this.actualDistancePrice,
      required this.vehicleCategory,
      required this.distance,
      required this.pricePerKm,
      required this.pricePerMin,
      this.pendingAmount,
      this.newTotal,
      this.baseFare,
      this.minimumFare,
      this.techFee,
      this.distanceTravelled,
      this.timeTaken})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  var sessionToken = locator<Session>().sessionToken;

  bool isPaymentSuccess = false;

  var session = locator<Session>();


  updatePaymentSuccess() {
    setState(() {
      isPaymentSuccess = true;
    });
  }

  late String totalAmountToPay;

  updateTotalAmount({tip}) {
    setState(() {
      totalAmountToPay = (double.parse(widget.newTotal) + double.parse(tip))
          .toStringAsFixed(2);
    });
  }

  TextEditingController tipsTextEditingController =
      TextEditingController(text: "0.0");


  var _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  TextEditingController textEditingController = TextEditingController();


  void onApplePayResult(paymentResult) async {
   try{
     final token = await stripe.Stripe.instance.createApplePayToken(paymentResult);
     log("-->>> Token id is <<<<-----" + token.id);

     var body = {
       'tip': tipsTextEditingController.text,
       'token': token.id,
       'order_id': int.parse(widget.orderId),
       "driver_id": int.parse(widget.driverId),
       "amount": totalAmountToPay
     };

     log("apple card body is-->>  " + body.toString());

     var response = await dio.post(
       '${BASE_URL}api/webservice/driver/payment',
       data: body,
       options: Options(headers: {"Authorization": "Bearer $sessionToken"}),
     );

     if (response.data["success"] == 1||kDebugMode) {
       updatePaymentSuccess();
       showDialog(
         context: context,
         builder: (ctx) => AlertDialog(
           title: const Text("Ride Payment Status "),
           content: const Text("Payment completed successfully"),
           actions: [
             CustomButton(
                 isRounded: true,
                 text: "Ok",
                 event: () {
                   session.setIsPaymentDone = true;
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
           title: const Text("Payment unsuccessfully"),
           content: Text(response.data["message"]),
         ),
       );
     }
     log(paymentResult.toString());
   }catch(e, s){
     log("$e, $s",name: "STRIPE LOG");
     showToast(message: e.toString());
   }
  }

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture = PaymentConfiguration.fromAsset('default_google_pay_config.json');
    var cardNumber = Provider.of<PaymentProvider>(context, listen: false).selectedCardNumber;
    log("selected card number is :$cardNumber");
    totalAmountToPay = widget.newTotal;
    _getTotalAmount();
    setState(() {
    });
  }

  void _getTotalAmount()async{
    _paymentItems.clear();
    _paymentItems.add(PaymentItem(
      label: 'Total',
      amount: '${totalAmountToPay}',
      status: PaymentItemStatus.final_price,
    ));
  }

  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    log("total amount to pay:-->> ${widget.totalPrice}");
    log("total amount to pay:-->> ${totalAmountToPay}");
    log("new amount to pay:-->> ${widget.newTotal}");
    log("vehicle category is :-->> ${widget.vehicleCategory}");
    log("actual distance priceis :-->> ${widget.actualDistancePrice}");

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
        child: SingleChildScrollView(
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
                      firstText: 'Total Distance',
                      secondText:
                          "${double.parse(widget.distanceTravelled.toString()).toStringAsFixed(2)} Km",
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    // TextInRow(
                    //   firstText: 'Extra Distance',
                    //   // secondText: widget.extraDistance + " Km",
                    //   secondText: widget.extraDistance.toString() + " Km",
                    // ),
                    // Divider(
                    //   color: whiteAccentColor,
                    // ),
                    TextInRow(
                      firstText: "Per Km Price ",
                      secondText:
                          r'CA$ ' + convertToFixedTwoDecimal(widget.pricePerKm),
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    TextInRow(
                      firstText: "Total Distance Price ",
                      secondText: r'CA$ ' +
                          convertToFixedTwoDecimal(widget.actualDistancePrice),
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    TextInRow(
                        firstText: 'Total Time Taken',
                        secondText: formatDuration(double.parse(widget.timeTaken.toString()).toInt()),
                        ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                /*    TextInRow(
                        firstText: 'Extra Time',
                        // secondText: widget.extraDistance + " Km",
                        secondText: extraTimeTaken
                        //  (widget.extraTime == '')
                        //     ? "0 Min"
                        //     : "${(int.parse(widget.extraTime)) / 60}" + " min",
                        ),
                    Divider(
                      color: whiteAccentColor,
                    ),*/
                    TextInRow(
                      firstText: "Per Minute Price",
                      secondText: ((widget.pricePerMin != null) ||
                              (widget.pricePerMin != '') ||
                              (widget.pricePerMin != '0'))
                          ? r'CA$ ' +
                              convertToFixedTwoDecimal(widget.pricePerMin)
                          : r'CA$ 0',
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    TextInRow(
                      firstText: "Total Time Price",
                      secondText: ((widget.extraTimePrice != null) ||
                              (widget.extraTimePrice != '') ||
                              (widget.extraTimePrice != '0'))
                          ? r'CA$ ' +
                              convertToFixedTwoDecimal(widget.extraTimePrice)
                          : r'CA$ 0',
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    TextInRow(
                      firstText: 'Minimum Fare',
                      secondText: 'CA\$ ' +
                          convertToFixedTwoDecimal(widget.minimumFare),
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    TextInRow(
                      firstText: 'Tech Fee',
                      secondText:
                          'CA\$ ' + convertToFixedTwoDecimal(widget.techFee),
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    TextInRow(
                      firstText: 'Base Fare',
                      secondText:
                          'CA\$ ' + convertToFixedTwoDecimal(widget.baseFare),
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    TextInRow(
                      secondTextweight: FontWeight.w700,
                      titleFontWeight: FontWeight.w700,
                      firstText: 'Grand Total',
                      secondText:
                          r'CA$ ' + convertToFixedTwoDecimal(widget.newTotal),
                    ),
                    Divider(
                      color: whiteAccentColor,
                    ),
                    TextInRow(
                      secondTextweight: FontWeight.w700,
                      titleFontWeight: FontWeight.w700,
                      firstText: 'Pending Amount',
                      // secondText: widget.extraDistance + " Km",
                      secondText: "CA\$ " +
                          convertToFixedTwoDecimal(widget.pendingAmount),
                    ),
                  ],
                ),
              ),

              widget.paymentMode.toString() != "1"
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: _deviceSize.height * .02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              // decoration: BoxDecoration(
                              //     color: Colors.black,
                              //     borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "Add Tips",
                                      style: TextStyle(
                                        fontFamily: "poPPinMedium",
                                        fontSize: 15.0,
                                        color: black15141FColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: _deviceSize.width * .3,
                            child: Row(
                              children: [
                                Text(r"CA$ "),
                                Expanded(
                                  child: TextField(
                                    inputFormatters: [
                                      // FilteringTextInputFormatter.allow(

                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                      // RegExp(r'^[0-9]+.?[0-9]*')),
                                      // WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),

                                      // FilteringTextInputFormatter.allow(
                                      //     RegExp(r'[0-9]'))
                                    ],
                                    controller: tipsTextEditingController,
                                    onChanged: (value) {
                                      log("test value is-->> $value");
                                      log("length is ::_>> ${value.length}");

                                      if (value != '') {
                                        setState(() {
                                          updateTotalAmount(tip: value);
                                        });
                                      } else {
                                        setState(() {
                                          updateTotalAmount(tip: "0.0");
                                        });
                                      }
                                    },
                                    onTapOutside: (event) {
                                      setState(() {
                                        // updateTotalAmount(tip: "0.0");
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 10.0,
                    ),

              TextInRow(
                firstText: 'Total amount to Pay',
                secondText:
                    "CA\$ ${convertToFixedTwoDecimal(totalAmountToPay)} ",
              ),
              widget.paymentMode == 2
                  ? CustomButton(
                      borderRadius: 50.0,
                      borderColor: black080808Color,
                      text: Provider.of<PaymentProvider>(context, listen: false)
                                  .selectedCardNumber
                                  .length !=
                              0
                          ? "Pay With Card *******" +
                              (Provider.of<PaymentProvider>(context,
                                          listen: false)
                                      .selectedCardNumber)
                                  .substring(Provider.of<PaymentProvider>(
                                              context,
                                              listen: false)
                                          .selectedCardNumber
                                          .length -
                                      4)
                          : "Pay With Card ",
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
                                            'Bearer pk_live_51NbHA8L2KkuOUsISLMZg8rgdOQ4Po3VKyiOsWjmxY2N5FQUM0ggbFdXFoJ0H06sdaCVj1yGCw9Qcf6CvjhTF3erW00Q1GUJ0sH',
                                      };
                                      try {
                                        var body = {
                                          "card[number]": Provider.of<
                                                              PaymentProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedCardNumber
                                                      .length !=
                                                  0
                                              ? Provider.of<PaymentProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedCardNumber
                                              : '4242424242424242',
                                          "card[exp_month]": Provider.of<
                                                              PaymentProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedCardNumber
                                                      .length !=
                                                  0
                                              ? Provider.of<PaymentProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedCardExpiry
                                                  .split('/')
                                                  .first
                                              : '10',
                                          "card[exp_year]": Provider.of<
                                                              PaymentProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedCardNumber
                                                      .length !=
                                                  0
                                              ? Provider.of<PaymentProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedCardExpiry
                                                  .split('/')
                                                  .last
                                              : '36',
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

                                        log("card payment response code is:-->> ${res.statusCode}");
                                        log("card payment response code is:-->>${res.data}");

                                        if (res.statusCode == 200) {
                                          log(res.data.toString());
                                          log('token response :-->>${res.data["id"]}');

                                          String cardToken = res.data["id"];

                                          var body = {
                                            'tip':
                                                tipsTextEditingController.text,
                                            'token': cardToken,
                                            'order_id':
                                                int.parse(widget.orderId),
                                            "driver_id":
                                                int.parse(widget.driverId),
                                            "amount": totalAmountToPay
                                          };

                                          log(body.toString());
                                          log("session token is:-->> ${sessionToken}");

                                          var response = await dio.post(
                                            '${BASE_URL}api/webservice/driver/payment',
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
                                                        session.setIsPaymentDone =
                                                            true;
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                FeedBackScreen(
                                                              name: widget.name,
                                                              img: widget.img,
                                                              carModal: widget
                                                                  .carModal,
                                                              carNo:
                                                                  widget.carNo,
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
                                          Navigator.pop(context);
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text("Card details Incorrect"),
                                        ));
                                        log("Card error is " + e.toString());
                                      }
                                    },
                                    bgColor: blackColor)
                              ],
                            );
                          },
                        );
                      },
                      bgColor: grey606060Color,
                    )
                  : SizedBox(),

              // Spacer(),
              SizedBox(
                height: _deviceSize.height * .05,
              ),

              widget.paymentMode.toString() == "1"
                  ? CustomButton(
                      borderRadius: 50.0,
                      text: "Pay With Cash",
                      isRounded: true,
                      event: () async {
                        session.setIsPaymentDone = true;
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
                        session.setIsPaymentDone = true;
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
                                      'tip': tipsTextEditingController.text,
                                      'token': cardToken,
                                      'order_id': int.parse(widget.orderId),
                                      "driver_id": int.parse(widget.driverId),
                                      "amount": totalAmountToPay
                                    };

                                    log(body.toString());
                                    try {
                                      var response = await dio.post(
                                        '${BASE_URL}api/webservice/driver/payment',
                                        data: body,
                                        options: Options(headers: {
                                          "Authorization":
                                              "Bearer $sessionToken"
                                        }),
                                      );

                                      if (response.data["success"] == 1) {
                                        log("payment successful");

                                        updatePaymentSuccess();
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text(
                                                "Ride Payment Status"),
                                            content: const Text(
                                                "Payment successfull"),
                                            actions: [
                                              CustomButton(
                                                  isRounded: true,
                                                  text: "Ok",
                                                  event: () {
                                                    session.setIsPaymentDone =
                                                        true;
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
                                        log("payment unsuccessful");
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text(
                                                "Payment unsuccessfull"),
                                            content:
                                                Text(response.data["message"]),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  },
                                  loadingIndicator: Center(
                                    child: LottieBuilder.asset(
                                        'assets/icons/lottie_animation.json'),
                                    // CircularProgressIndicator(),
                                  ),
                                )
                              : SizedBox()
                          : SizedBox()
                      : const SizedBox.shrink()),
              // Example pay button configured using a string
              if(Platform.isIOS && widget.paymentMode != 1)...{
                ApplePayButton(
                  width: double.infinity, // or a fixed width if necessary
                  height: 50,
                  paymentConfiguration: PaymentConfiguration.fromJsonString(
                    payment_configurations.defaultApplePay,
                  ),
                  paymentItems: _paymentItems,
                  style: ApplePayButtonStyle.black, // Adjust based on app design
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onApplePayResult,
                  onPressed: () {
                    if (_paymentItems.isEmpty) {
                      return;
                    }
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                SizedBox(
                  height: _deviceSize.height * .05,
                ),
                Row(
                  children: [
                    Expanded(child: Divider(color: blue242E42Color,)),
                    TextInRow(
                      secondTextweight: FontWeight.w700,
                      titleFontWeight: FontWeight.w700,
                      firstText: '   OR     ',
                      // secondText: widget.extraDistance + " Km",
                      secondText: ""
                    ),
                    Expanded(child: Divider(color: blue242E42Color,))
                  ],
                ),
              },
              SizedBox(
                height: _deviceSize.height * .05,
              ),

              CustomButton(
                  borderRadius: 50.0,
                  isRounded: true,
                  text: "Pay outside the app",
                  event: () {
                    session.setIsPaymentDone = true;
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
                  bgColor: black080808Color),

              SizedBox(
                height: _deviceSize.height * .05,
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
      ),
    );
  }
}
