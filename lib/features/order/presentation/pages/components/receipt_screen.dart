import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/assets.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/pages/components/feedback_screen.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/circular_image_container.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/text_in_row.dart';
import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.of(context).size.height;
    double? width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: whiteColor,
          centerTitle: true,
          title: CommonText(
            text: "Receipt",
            fontWeight: FontWeight.w600,
            fontColor: blackColor,
            fontFamily: "poPPinMedium",
            fontSize: 18,
          ),
        ),
        body: Container(
          height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CommonCircularImageContainer(
                          height: 45,
                          width: 45,
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Alex Robin",
                              fontWeight: FontWeight.w500,
                              fontColor: blackColor,
                              fontFamily: "poPPinMedium",
                              fontSize: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(starImage),
                                CommonText(
                                  text: "4.5",
                                  fontWeight: FontWeight.w600,
                                  fontColor: blackColor,
                                  fontFamily: "poPPinMedium",
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CommonText(
                          text: "Chevrolet Trail...",
                          fontWeight: FontWeight.w400,
                          fontColor: grey585858Color,
                          fontFamily: "poPPinMedium",
                          fontSize: 12,
                        ),
                        CommonText(
                          text: "GJZ 0196",
                          fontWeight: FontWeight.w500,
                          fontColor: blackColor,
                          fontFamily: "poPPinMedium",
                          fontSize: 12,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 43,
                ),
                CommonText(
                  text: "Fare Breakdown",
                  fontWeight: FontWeight.w600,
                  fontColor: blackColor,
                  fontFamily: "poPPinMedium",
                  fontSize: 16,
                ),
                TextInRow(
                  firstText: 'Date',
                  secondText: '09 May 2023',
                ),
                TextInRow(
                  firstText: 'Time',
                  secondText: '12:00 PM',
                ),
                TextInRow(
                  firstText: 'Total Distance',
                  secondText: '12 km',
                ),
                TextInRow(
                  firstText: 'time taken',
                  secondText: '30 min',
                ),
                CommonText(
                  text: "Payment Information",
                  fontWeight: FontWeight.w600,
                  fontColor: blackColor,
                  fontFamily: "poPPinMedium",
                  fontSize: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      text: "Payment Information",
                      fontWeight: FontWeight.w500,
                      fontColor: grey7D7979Color,
                      fontFamily: "poPPinMedium",
                      fontSize: 13,
                    ),
                    Row(
                      children: [
                        Image.asset(cardImage),
                        CommonText(
                          text: "Card",
                          fontWeight: FontWeight.w400,
                          fontColor: grey7D7979Color,
                          fontFamily: "poPPinMedium",
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ],
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
                CustomButton(
                  text: const Text(
                    "Continue",
                    // appLoc.login.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'poPPinSemiBold',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  event: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedBackScreen()));
                  },
                  buttonHeight: 50,
                  // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                  isRounded: true,
                  bgColor: black080809Color,
                ),
                SizedBox(
                  height: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
