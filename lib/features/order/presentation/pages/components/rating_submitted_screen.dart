import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import '../../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../../core/presentation/providers/home_provider.dart';

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
          body: Consumer<OrderProvider>(builder: (BuildContext context,
              OrderProvider orderProvider, Widget? child) {
            return Container(
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
                      event: () async {
                        // orderProvider.submitRatingsReview();
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
