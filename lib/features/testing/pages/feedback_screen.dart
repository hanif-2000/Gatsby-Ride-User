import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/testing/pages/payment_screen.dart';
import 'package:appkey_taxiapp_user/features/testing/pages/rating_submitted_screen.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/circular_image_container.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart' as rating;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedBackScreen extends StatelessWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: whiteColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
            ),
            color: blackColor,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: _deviceSize.width * .05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: green63BA6BColor.withOpacity(.15)),
                    height: 140,
                    width: 140.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CommonCircularImageContainer(),
                    ),
                  ),
                ),
                CommonText(
                  text: "Alex Robin",
                  fontWeight: FontWeight.w500,
                  fontColor: blackColor,
                  fontFamily: "poPPinMedium",
                  fontSize: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      text: "Sedan  - ",
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
                ),
                SizedBox(
                  height: _deviceSize.height * .015,
                ),
                CommonText(
                  text: "How was your ride?",
                  fontWeight: FontWeight.w500,
                  fontColor: blackColor,
                  fontFamily: "poPPinMedium",
                  fontSize: 24,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _deviceSize.width * .15, vertical: 10.0),
                  child: CommonText(
                    text: "Your feedback will help improve driving experience",
                    fontWeight: FontWeight.w400,
                    fontColor: grey8A8A8FColor,
                    fontFamily: "poPPinMedium",
                    fontSize: 17,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: _deviceSize.height * .01),
                  child: RatingBar.builder(
                    updateOnDrag: true,
                    unratedColor: greyEFEFF4Color,
                    glow: false,
                    initialRating: 3,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: yellowFFCC00Color,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 1.0, color: greyEFEFF2Color),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 5,
                        autofocus: false,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Additional comments...",
                          hintStyle: TextStyle(
                              fontSize: 17.0,
                              fontFamily: "poPPinRegular",
                              color: greyC8C7CCColor),
                        ),
                      ),
                    )),
                SizedBox(
                  height: _deviceSize.height * .05,
                ),
                CustomButton(
                  text: const Text(
                    "Submit",
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
                            builder: (context) => RatingSubmittedScreen()));
                  },
                  buttonHeight: 50,
                  // buttonHeight: MediaQuery.of(context)._deviceSize.height * 0.080,
                  isRounded: true,
                  bgColor: black080809Color,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: _deviceSize.height * .03,
                  ),
                  child: CustomButton(
                    buttonHeight: 50.0,
                    text: Text(
                      "Skip",
                      style: TextStyle(
                        color: blackColor,
                      ),
                    ),
                    event: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(),
                        ),
                      );
                    },
                    bgColor: whiteColor,
                    isRounded: true,
                    borderColor: blackColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
