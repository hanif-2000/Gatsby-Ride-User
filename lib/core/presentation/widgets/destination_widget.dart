import 'dart:developer';

import 'package:appkey_taxiapp_user/core/static/enums.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../features/login/presentation/pages/login_page.dart';
import '../../utility/global_function.dart';
import '../pages/place_picker_page/place_picker_page.dart';
import '../providers/home_provider.dart';

class DestinationWidget extends StatelessWidget {
  final double deviceWidth;
  final bool isFromOrder;

  const DestinationWidget({
    Key? key,
    required this.deviceWidth,
    required this.isFromOrder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isFromOrder) {
      return Consumer<OrderProvider>(builder: (context, map, _) {
        if (map.originAddress == '') {
          return const SizedBox();
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                      width: deviceWidth,
                      height: 60,
                      child: Card(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/icons/destination_logo.svg',
                                  height: 30.0,
                                  width: 30.0,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    map.destinationAddress,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                )
                              ],
                            )),
                      ))));
        }
      });
    } else {
      return Consumer<HomeProvider>(builder: (context, map, _) {
        if (map.originAddress == '') {
          return const SizedBox();
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: GestureDetector(
                  onTap: () async {
                    log("On CLick on Destination field");
                    checkUserSession().then((value) async {
                      if (value) {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerPage(
                                  address: map.destinationAddress,
                                  addressType: AddressType.destination,
                                  latLng: map.destinationLatLng),
                            ));
                        map.displayResult(result['pickUpCoordinate'],
                            result['pickUpName'], result['addressType']);
                        if (map.selectedCategory != null) {
                          map.fetchTotalPrice().listen((event) {});
                        }

                        if (result != null) {
                          map.toggleIsDestinationSelected();
                        }

                        // log("Result" + result.toString());
                      } else {
                        Navigator.pushNamed(context, LoginPage.routeName);
                      }
                    });
                  },
                  child: SizedBox(
                      width: deviceWidth,
                      height: 60,
                      child: Card(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // SvgPicture.asset(
                                //   'assets/icons/destination.svg',
                                //   currentColor: Colors.red,
                                // ),
                                SvgPicture.asset(
                                  'assets/icons/destination_logo.svg',
                                  height: 30.0,
                                  width: 30.0,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    map.destinationIsFilled
                                        ? map.destinationAddress
                                        : appLoc.destination,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: map.destinationIsFilled
                                            ? Colors.black
                                            : Colors.grey),
                                  ),
                                )
                              ],
                            )),
                      ))));
        }
      });
    }
  }
}
