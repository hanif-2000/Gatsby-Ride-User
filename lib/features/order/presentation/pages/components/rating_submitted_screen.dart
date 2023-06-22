import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RatingSubmittedScreen extends StatelessWidget {
  const RatingSubmittedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: blackColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          width: size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/check.svg'),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * .05, bottom: size.height * .01),
                  child: Text("Rating Submitted",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: "poPPinSemiBold",
                      )),
                ),
                Text("your rating has been submitted",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: "poPPinRegular",
                      color: grey767676Color,
                    )),
                SizedBox(
                  height: size.height * .05,
                ),
                CustomButton(
                  isRounded: true,
                  text: "Done",
                  event: () {},
                  bgColor: blackColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
