import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/circular_image_container.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart' as rating;

class FeedBackScreen extends StatelessWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.of(context).size.height;
    double? width = MediaQuery.of(context).size.width;
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
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  height: 33,
                ),
                CommonText(
                  text: "How was your ride?",
                  fontWeight: FontWeight.w500,
                  fontColor: blackColor,
                  fontFamily: "poPPinMedium",
                  fontSize: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 37, left: 37),
                  child: CommonText(
                    text: "Your feedback will help improve driving experience",
                    fontWeight: FontWeight.w400,
                    fontColor: grey8A8A8FColor,
                    fontFamily: "poPPinMedium",
                    fontSize: 17,
                  ),
                ),
                rating.RatingBarIndicator(
                  rating: 4.5,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 29.0,
                  direction: Axis.horizontal,
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
                  event: () {},
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
