import 'dart:async';

import 'package:appkey_taxiapp_user/core/presentation/widgets/bottom_sheet_book_ride.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/destination_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/origin_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () {
          return Future.value(false); // if true allow back else block it
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // appBar: const CustomAppBar(
            //   centerTitle: false,
            // ),
            body: Consumer<HomeProvider>(builder: (context, map, _) {
              return Stack(
                children: <Widget>[
                  GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: map.kJapanCoordinate,
                    onMapCreated: (GoogleMapController controller) async {
                      map.googleMapController = controller;
                      await map.setCurrentLocation();
                      // }
                    },
                    polylines: map.polylines,
                    markers: Set<Marker>.of(map.markers.values),
                  ),
                  SafeArea(
                      child: Stack(children: [
                    Container(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: [
                                  OriginWidget(
                                    deviceWidth: _deviceSize.width,
                                    isFromOrder: false,
                                  ),
                                  DestinationWidget(
                                    deviceWidth: _deviceSize.width,
                                    isFromOrder: false,
                                  ),
                                ],
                              ),
                            ),

                            /** Below is the new UI*/

                            const Spacer(),
                            Visibility(
                              visible: map.isDestinationSelected,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomButton(
                                  text: const Text(
                                    "Confirm",
                                    style: TextStyle(
                                      fontFamily: 'poPPinSemiBold',
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor,
                                    ),
                                  ),
                                  event: () {
                                    showModalBottomSheet(
                                      useRootNavigator: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      // backgroundColor: ,
                                      context: context,
                                      builder: (context) {
                                        return const BottomSheetBookRide();
                                      },
                                    );
                                  },
                                  buttonHeight: 50,
                                  isRounded: true,
                                  bgColor: black080809Color,
                                ),
                              ),
                            ),

                            // /** Below is the old ui  */

                            // SizedBox(
                            //   height: _deviceSize.height * .01,
                            // ),
                            // Expanded(
                            //     child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.end,
                            //         mainAxisAlignment: MainAxisAlignment.end,
                            //         children: const [
                            //       CurrentLocationWidget(),
                            //       BottomContainerHome()
                            //     ]))
                          ]),
                    )
                  ]))
                ],
              );
            }),
          ),
        ));
  }
}
