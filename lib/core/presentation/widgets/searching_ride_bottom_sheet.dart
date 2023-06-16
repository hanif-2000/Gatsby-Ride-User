import 'package:appkey_taxiapp_user/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../static/colors.dart';

class SearchingRideBottomSheet extends StatelessWidget {
  const SearchingRideBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<HomeProvider>(builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(
            // color: Colors.yellow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/searching_ride.svg'),
                  LinearPercentIndicator(
                    barRadius: Radius.circular(
                      50.0,
                    ),
                    lineHeight: 8.0,
                    percent: 0.5,
                    progressColor: Colors.orange,
                  ),
                  Text(
                    "Please wait...",
                    style:
                        TextStyle(fontFamily: "poPPinRegular", fontSize: 15.0),
                  ),
                  Text(
                    "we are searching for nearby driver for you",
                    style:
                        TextStyle(fontFamily: "poPPinRegular", fontSize: 15.0),
                  ),
                  CustomButton(
                    text: const Text(
                      "Cancel Ride",
                      style: TextStyle(
                        fontFamily: 'poPPinSemiBold',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    event: () {},
                    buttonHeight: 50,
                    // isRounded: true,
                    bgColor: black080809Color,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
