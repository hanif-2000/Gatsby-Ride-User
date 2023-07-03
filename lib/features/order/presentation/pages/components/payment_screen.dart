import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../testing/widgets/common_text.dart';
import '../../../../testing/widgets/text_in_row.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

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
                    secondText: r'$80.00',
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Service Price',
                    secondText: r'$4.00',
                  ),
                  Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    secondTextweight: FontWeight.w700,
                    firstText: 'Total Price',
                    secondText: r'$84.00',
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
                  "Cash",
                  style: TextStyle(
                    fontFamily: "poPPinRegular",
                    fontSize: 16.0,
                    color: grey7D7979Color,
                  ),
                )
              ],
            ),
            Spacer(),
            CustomButton(
              text: "Pay Now",
              isRounded: true,
              event: () {},
              bgColor: blackColor,
            ),

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
