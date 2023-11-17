import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../features/order/presentation/widgets/button_cancel_order.dart';
import '../../static/assets.dart';
import '../../static/colors.dart';

class SearchingRideBottomSheet extends StatelessWidget {
  const SearchingRideBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<HomeProvider>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(searchingRideSvg),
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
              Text(
                appLoc.pleaseWait,
                style: TextStyle(
                    fontFamily: "poPPinRegular",
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: black080809Color),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 30.0,
                ),
                child: Text(
                  appLoc.weAreSearchingNearByDriver,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "poPPinRegular",
                    fontSize: 15.0,
                    color: black28272FColor,
                  ),
                ),
              ),
              ButtonCancelOrder(),
              SizedBox(
                height: 6.0,
              )
            ],
          ),
        );
      }),
    );
  }
}
