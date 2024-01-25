import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:GetsbyRideshare/socket/latest_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import '../../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../../core/presentation/providers/home_provider.dart';
import '../../../../../core/static/assets.dart';

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
          body: Consumer<LatestSocketProvider>(builder: (BuildContext context,
              LatestSocketProvider orderProvider, Widget? child) {
            return Container(
              width: size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(checkIconSvg),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * .05, bottom: size.height * .01),
                      child: Text(appLoc.ratingSubmitted,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: "poPPinSemiBold",
                          )),
                    ),
                    Text(appLoc.yourRatingHasBeenSubmitted,
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
                      text: appLoc.done,
                      event: () async {
                        var session = locator<Session>();
                        // orderProvider.submitRatingsReview();
                        session.setIsRunningOrder = false;
                        session.setOrderStatus = 100;
                        session.clearOrderSession();

                        var homeProvider =
                            Provider.of<HomeProvider>(context, listen: false);
                        await homeProvider.clearState();
                        await orderProvider.clearState();

                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      },
                      bgColor: blackColor,
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
