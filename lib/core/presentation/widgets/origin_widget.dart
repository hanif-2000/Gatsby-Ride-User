import 'package:GetsbyRideshare/core/presentation/pages/menu_page.dart';
import 'package:GetsbyRideshare/core/presentation/pages/place_picker_page/place_picker_page.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../features/login/presentation/pages/login_page.dart';
import '../../static/colors.dart';
import '../../static/enums.dart';
import '../../utility/global_function.dart';
import '../../utility/helper.dart';
import '../providers/home_provider.dart';

class OriginWidget extends StatelessWidget {
  final bool isFromOrder;
  final double deviceWidth;

  const OriginWidget({
    Key? key,
    required this.deviceWidth,
    required this.isFromOrder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isFromOrder) {
      return Consumer<OrderProvider>(builder: (context, map, _) {
        if (map.originAddress == '') {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: SizedBox(
                width: deviceWidth * .8,
                height: 60,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                      width: deviceWidth * .8,
                      height: 80,
                      child: Card(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  appLoc.pickUp,
                                  style: TextStyle(
                                      fontFamily: "poPPinRegular",
                                      fontSize: 13.0,
                                      color: greyC8C7CCColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Image.asset(
                                    //   'assets/icons/location.png',
                                    //   height: 24.0,
                                    //   width: 24.0,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    Flexible(
                                      child: Text(
                                        map.originAddress,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontFamily: 'poPPinRegular',
                                            fontSize: 17.0,
                                            color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ))));
        }
      });
    } else {
      return Consumer<HomeProvider>(builder: (context, map, _) {
        if (map.originAddress == '') {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: SizedBox(
                width: deviceWidth * .8,
                height: 60,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: GestureDetector(
                  onTap: () async {
                    checkUserSession().then((value) async {
                      if (value) {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerPage(
                                  addressType: AddressType.origin,
                                  address: map.originAddress,
                                  latLng: map.originLatLng),
                            ));
                        map.displayResult(result['pickUpCoordinate'],
                            result['pickUpName'], result['addressType']);
                        if (map.destinationIsFilled && map.originIsFilled) {
                          // map.fetchTotalPrice().listen((event) {});
                        }
                      } else {
                        Navigator.pushNamed(context, LoginPage.routeName);
                      }
                    });
                  },
                  child: SizedBox(
                      width: deviceWidth * .8,
                      height: 70,
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  appLoc.pickUp,
                                  style: TextStyle(
                                      fontFamily: "poPPinRegular",
                                      fontSize: 13.0,
                                      color: greyC8C7CCColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // Image.asset(
                                    //   'assets/icons/location.png',
                                    //   height: 24.0,
                                    //   width: 24.0,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    // // const Icon(Icons.my_location,
                                    // //     color: primaryColor, size: 30),
                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    Flexible(
                                      child: Text(
                                        map.originAddress,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'poPPinRegular',
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.menu,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.leftToRight,
                                            child: const HomeDrawerPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ))));
        }
      });
    }
  }
}
