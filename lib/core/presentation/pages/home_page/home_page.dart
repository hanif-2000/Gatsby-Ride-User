import 'dart:async';
import 'dart:developer';

import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/destination_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/origin_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../widgets/bottom_sheet_book_ride.dart';

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
                              color: whiteColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Container(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/location.png',
                                          height: 24.0,
                                          width: 24.0,
                                          fit: BoxFit.cover,
                                        ),
                                        SvgPicture.asset(
                                            'assets/icons/dotted_line.svg'),
                                        SvgPicture.asset(
                                          'assets/icons/destination_logo.svg',
                                          height: 30.0,
                                          width: 30.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        OriginWidget(
                                          deviceWidth: _deviceSize.width,
                                          isFromOrder: false,
                                        ),
                                        Container(
                                          margin: EdgeInsets.zero,
                                          width: _deviceSize.width * .8,
                                          height: 1.0,
                                          color: whiteEFEFEFColor,
                                        ),
                                        Container(
                                          child: DestinationWidget(
                                            deviceWidth: _deviceSize.width,
                                            isFromOrder: false,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
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
                                    log(map.originLatLng.toString());
                                    log(map.destinationLatLng.toString());
                                    log(map.distance.toString());

                                    map.fetchVehicleCategory().listen((event) {
                                      log("========>>>>>>" + event.toString());
                                    });
                                    showModalBottomSheet(
                                      barrierColor: Colors.transparent,
                                      useRootNavigator: true,
                                      // isScrollControlled: true,
                                      constraints: BoxConstraints(
                                          maxHeight: _deviceSize.height * .45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0),
                                        ),
                                      ),
                                      backgroundColor: whiteColor,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                            child: BottomSheetBookRide());
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
