import 'dart:io';

import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/enums.dart' as enums;
import 'package:GetsbyRideshare/core/static/enums.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/new_card_payment/presentation/pages/card_payment_page.dart';
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
          return SizedBox(
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
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: _deviceSize.height,
                          child: Column(
                            children: [
                              SizedBox(
                                  child: PaymentTile(
                                title: "Cash",
                                assets: 'assets/icons/cash.svg',
                                onTap: () {
                                  provider.setPaymentMethod = enums.PaymentMethod.cash;
                                },
                                selected: provider.paymentMethod == null
                                    ? false
                                    : provider.paymentMethod == enums.PaymentMethod.cash
                                        ? true
                                        : false,
                              )),

                              ///// Card payment ////

                              SizedBox(
                                  child: CardPaymentExpansionTile(
                                title: "Debit/Credit Card",
                                assets: 'assets/icons/mastercard.svg',
                                onTap: () {
                                  // provider.setPaymentMethod =
                                  //     PaymentMethod.creditCard;
                                  // Navigator.pop(context);
                                },
                                selected: provider.paymentMethod == null
                                    ? false
                                    : provider.paymentMethod ==
                                            PaymentMethod.creditCard
                                        ? true
                                        : false,
                                provider: provider,
                              )),
                              (Platform.isIOS)
                                  ? SizedBox(
                                      child: PaymentTile(
                                      title: "",
                                      assets: 'assets/icons/apple_pay_logo.svg',
                                      onTap: () {
                                        provider.setPaymentMethod =
                                            enums.PaymentMethod.applePay;
                                        // Navigator.pop(context);
                                      },
                                      selected: provider.paymentMethod == null
                                          ? false
                                          : provider.paymentMethod ==
                                                  enums.PaymentMethod.applePay
                                              ? true
                                              : false,
                                    ))
                                  : SizedBox(),

                              //Google pay button

                              Platform.isAndroid
                                  ? SizedBox(
                                      child: PaymentTile(
                                      title: "Google Pay",
                                      assets: 'assets/icons/google.svg',
                                      onTap: () {
                                        provider.setPaymentMethod =
                                            enums.PaymentMethod.googlePay;
                                        // Navigator.pop(context);
                                      },
                                      selected: provider.paymentMethod == null
                                          ? false
                                          : provider.paymentMethod ==
                                                  enums.PaymentMethod.googlePay
                                              ? true
                                              : false,
                                    ))
                                  : SizedBox(),

                              // SizedBox(
                              //   height: _deviceSize.height * .5,
                              // ),

                              // const Spacer(),

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
                                  event: () {
                                    Navigator.pop(context);
                                    // try {
                                    //   // Navigator.push(
                                    //   //   context,
                                    //   //   MaterialPageRoute(
                                    //   //     builder: (context) =>
                                    //   //         // NewPaymentScreen(),
                                    //   //         PayMaterialApp(),
                                    //   //   ),
                                    //   // );
                                    // } catch (e) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     SnackBar(
                                    //       content: Text('Error: $e'),
                                    //     ),
                                    //   );
                                    //   rethrow;
                                    // }
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
                    ),
                  ));
            }),
          );
          // });
        },
      ),
    );
    // );
    // });
  }
}
