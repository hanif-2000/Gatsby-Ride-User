import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/circular_image_container.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';

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
        body: Container(
          height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: SingleChildScrollView(
              child: Container(
                color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CommonCircularImageContainer(
                      height: 120,
                      width: 120,
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
                        text:
                            "Your feedback will help improve driving experience",
                        fontWeight: FontWeight.w400,
                        fontColor: grey8A8A8FColor,
                        fontFamily: "poPPinMedium",
                        fontSize: 17,
                      ),
                    ),
                    CustomButton(
                      text: const Text(
                        "Sumbit",
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
        ),
      ),
    );
  }
}
