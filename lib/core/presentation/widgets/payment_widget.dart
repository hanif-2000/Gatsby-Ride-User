import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/static/enums.dart';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';
import 'payment_tile_widget.dart';

class PaymentOption extends StatelessWidget {
  const PaymentOption({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return

              // Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              //     child: GestureDetector(
              //       onTap: () {
              //         showModalBottomSheet(
              //             useRootNavigator: true,
              //             isScrollControlled: true,
              //             useSafeArea: true,
              //             context: context,
              //             builder: (BuildContext context) {
              //               return

              SizedBox(
            // height: _deviceSize.height,
            child: LayoutBuilder(builder: (context, constaints) {
              return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Scaffold(
                    backgroundColor: whiteColor,
                    appBar: AppBar(
                      elevation: 0.0,
                      backgroundColor: whiteColor,
                      centerTitle: true,
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: blackColor,
                        ),
                      ),
                      title: const Text(
                        "Payment Method",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: blackColor),
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: _deviceSize.height,
                        child: Column(
                          children: [
                            // SizedBox(
                            //   // height: constaints.maxHeight * 0.25,
                            //   child: Padding(
                            //       padding: const EdgeInsets.only(
                            //           top: 8.0, left: 15.0, bottom: 0.0),
                            //       child: Row(
                            //         children: const [
                            //           Icon(Icons.arrow_back),
                            //           Text(
                            //             "Payment Method",

                            //           )
                            //         ],
                            //       )

                            //       //  Text(
                            //       //   appLoc.selectPaymentMethod,
                            //       //   style: selectPamyemntStyle,
                            //       // ),
                            //       ),
                            // ),
                            SizedBox(
                                child: PaymentTile(
                              title: "Cash",
                              assets: 'assets/icons/cash.svg',
                              onTap: () {
                                provider.setPaymentMethod = PaymentMethod.cash;
                              },
                              selected: provider.paymentMethod == null
                                  ? false
                                  : provider.paymentMethod == PaymentMethod.cash
                                      ? true
                                      : false,
                            )),

                            // SizedBox(
                            //     child: CreditCardExpansionTile(
                            //   title: "Debit/Credit Card",
                            //   assets: 'assets/icons/mastercard.svg',
                            //   onTap: () {
                            //     provider.setPaymentMethod =
                            //         PaymentMethod.creditCard;
                            //     // Navigator.pop(context);
                            //   },
                            //   selected: provider.paymentMethod == null
                            //       ? false
                            //       : provider.paymentMethod ==
                            //               PaymentMethod.creditCard
                            //           ? true
                            //           : false,
                            //   provider: provider,
                            // )),
                            // SizedBox(
                            //     child: PaymentTile(
                            //   title: "Debit/Credit Card",
                            //   assets: 'assets/icons/mastercard.svg',
                            //   onTap: () {
                            //     provider.setPaymentMethod =
                            //         PaymentMethod.creditCard;
                            //     // Navigator.pop(context);
                            //   },
                            //   selected: provider.paymentMethod == null
                            //       ? false
                            //       : provider.paymentMethod ==
                            //               PaymentMethod.creditCard
                            //           ? true
                            //           : false,
                            // )),

                            // SizedBox(
                            //     child: CreditCardTile(
                            //   title: "*** *** *** 14 15 25",
                            //   assets:
                            //       'assets/icons/logos_mastercard.svg',
                            //   onTap: () {
                            //     provider.setPaymentMethod =
                            //         PaymentMethod.creditCard;
                            //     // Navigator.pop(context);
                            //   },
                            //   selected: provider.paymentMethod == null
                            //       ? false
                            //       : provider.paymentMethod ==
                            //               PaymentMethod.creditCard
                            //           ? true
                            //           : false,
                            // )),

                            SizedBox(
                                child: PaymentTile(
                              title: "Apple Pay",
                              assets: 'assets/icons/apple.svg',
                              onTap: () {
                                provider.setPaymentMethod =
                                    PaymentMethod.applePay;
                                // Navigator.pop(context);
                              },
                              selected: provider.paymentMethod == null
                                  ? false
                                  : provider.paymentMethod ==
                                          PaymentMethod.applePay
                                      ? true
                                      : false,
                            )),
                            SizedBox(
                                child: PaymentTile(
                              title: "Google Pay",
                              assets: 'assets/icons/google.svg',
                              onTap: () {
                                provider.setPaymentMethod =
                                    PaymentMethod.googlePay;
                                // Navigator.pop(context);
                              },
                              selected: provider.paymentMethod == null
                                  ? false
                                  : provider.paymentMethod ==
                                          PaymentMethod.googlePay
                                      ? true
                                      : false,
                            )),

                            const Spacer(),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _deviceSize.width * .05),
                              child: CustomButton(
                                text: const Text(
                                  "Done",
                                  style: TextStyle(
                                    fontFamily: 'poPPinSemiBold',
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                  ),
                                ),
                                event: () async {
                                  try {
                                    await stripe.Stripe.instance
                                        .initPaymentSheet(
                                            paymentSheetParameters: const stripe
                                                .SetupPaymentSheetParameters(
                                      customFlow: true,
                                      merchantDisplayName:
                                          'Flutter Stripe Demo',
                                      paymentIntentClientSecret: "",
                                      customerEphemeralKeySecret: "",
                                      customerId: "",
                                      setupIntentClientSecret: "",
                                      style: ThemeMode.light,
                                    ));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                    rethrow;
                                  }

                                  // Navigator.pop(context);
                                },
                                buttonHeight: 50,
                                isRounded: true,
                                bgColor: black080809Color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            }),
          );
          // });
        },
        // child: Card(
        //     child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: SizedBox(
        //           height: 40,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               const Padding(
        //                 padding: EdgeInsets.only(
        //                     left: 10, top: 10, bottom: 10, right: 12),
        //                 child: Icon(
        //                   Icons.payment,
        //                   color: primaryColor,
        //                 ),
        //               ),
        //               Flexible(
        //                 flex: 5,
        //                 fit: FlexFit.tight,
        //                 child: Text(
        //                   provider.paymentMethod == null
        //                       ? appLoc.selectPaymentMethod
        //                       : provider.paymentMethod!.getString(),
        //                   style: selectPamyemntStyle,
        //                 ),
        //               ),
        //               Expanded(
        //                   child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.end,
        //                 children: const [
        //                   Icon(
        //                     Icons.arrow_forward_ios,
        //                     color: primaryColor,
        //                   ),
        //                 ],
        //               ))
        //             ],
        //           ),
        //         ))),
      ),
    );
    // );
    // });
  }
}
