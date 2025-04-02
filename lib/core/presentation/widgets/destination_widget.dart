import 'dart:developer';

import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/socket/test_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      return Consumer<TestSocketProvider>(builder: (context, map, _) {
        if (map.originAddress == '') {
          return const SizedBox();
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                      width: deviceWidth * .8,
                      height: 60,
                      child: Card(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  appLoc.dropOff,
                                  style: TextStyle(
                                      fontFamily: "poPPinRegular",
                                      fontSize: 13.0,
                                      color: greyC8C7CCColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // SvgPicture.asset(
                                    //   'assets/icons/destination_logo.svg',
                                    //   height: 30.0,
                                    //   width: 30.0,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    Flexible(
                                      child: Text(
                                        map.destinationAddress,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'poPPinRegular',
                                          fontSize: 17.0,
                                        ),
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
          return const SizedBox();
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: GestureDetector(
                  onTap: () async {
                    log("On CLick on Destination field");
                    checkUserSession().then((value) async {
                      if (value) {
                        final result = await Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => PlacePickerPage(
                                  address: map.destinationAddress,
                                  addressType: AddressType.destination,
                                  latLng: map.destinationLatLng),
                            ));
                        if(result != null){
                          map.displayResult(result['pickUpCoordinate'], result['pickUpName'], result['addressType']);
                          map.toggleIsDestinationSelected();
                        }
                      }
                    });
                  },
                  child: SizedBox(
                      width: deviceWidth * .8,
                      height: 60,
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appLoc.dropOff,
                                  style: TextStyle(
                                      fontFamily: "poPPinRegular",
                                      fontSize: 13.0,
                                      color: greyC8C7CCColor),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        map.destinationIsFilled
                                            ? map.destinationAddress
                                            : appLoc.destination,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'poPPinRegular',
                                            fontSize: 17.0,
                                            color: map.destinationIsFilled
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                    )
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
