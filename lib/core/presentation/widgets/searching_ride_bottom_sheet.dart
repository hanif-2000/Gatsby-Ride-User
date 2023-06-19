import 'package:appkey_taxiapp_user/core/presentation/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../features/order/presentation/widgets/button_cancel_order.dart';
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
            color: Colors.yellow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
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

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: LinearProgressIndicator(
                        backgroundColor: greyECECECColor,
                        valueColor: AlwaysStoppedAnimation(yellowE5A829Color),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  // LinearPercentIndicator(
                  //   barRadius: Radius.circular(
                  //     50.0,
                  //   ),
                  //   lineHeight: 8.0,
                  //   percent: 0.5,
                  //   progressColor: Colors.orange,
                  // ),

                  Text(
                    "Please wait...",
                    style: TextStyle(
                      fontFamily: "poPPinRegular",
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "we are searching for nearby driver for you",
                      style: TextStyle(
                          fontFamily: "poPPinRegular", fontSize: 15.0),
                    ),
                  ),

                  ButtonCancelOrder()
                  // CustomButton(
                  //   text: const Text(
                  //     "Cancel Ride",
                  //     style: TextStyle(
                  //       fontFamily: 'poPPinSemiBold',
                  //       fontWeight: FontWeight.w600,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   event: onCancel,
                  //   buttonHeight: 50,
                  //   // isRounded: true,
                  //   bgColor: black080809Color,
                  // ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
