import 'dart:async';
import 'dart:developer';

import 'package:appkey_taxiapp_user/core/domain/entities/order_data_detail.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/destination_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/origin_widget.dart';
import 'package:appkey_taxiapp_user/core/static/app_config.dart';
import 'package:appkey_taxiapp_user/core/static/enums.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/get_order_detail_state.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/get_status_order_state.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/providers/home_provider.dart';
import '../../../../core/presentation/widgets/searching_ride_bottom_sheet.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/order_status.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../providers/get_driver_detail_state.dart';
import '../providers/update_status_order_state.dart';
import '../widgets/button_cancel_order.dart';
import '../widgets/depart_dialog.dart';
import '../widgets/dialog_driver_detail.dart';
import '../widgets/thank_you_dialog.dart';
import '../widgets/waiting_driver_dialog.dart';

class OrderPage extends StatefulWidget {
  final OrderDataDetail location;

  const OrderPage({Key? key, required this.location}) : super(key: key);
  static const routeName = '/OrderPage';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with WidgetsBindingObserver {
  Timer? checkOrderStatusTimer, trackingDriverTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
    checkOrderStatusTimer?.cancel();
    trackingDriverTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final session = locator<Session>();
    var _deviceSize = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: const CustomAppBar(
          //   centerTitle: false,
          // ),
          body: Consumer<OrderProvider>(builder: (context, provider, _) {
            if (checkOrderStatusTimer != null) {
              checkOrderStatusTimer!.cancel();
            }

            checkOrderStatusTimer =
                Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
              provider.fetchOrderStatus().listen((state) async {
                if (state is GetStatusOrderLoaded) {
                  int sessionStatusOrder = session.orderStatus;
                  int statusOrder = state.data.status;
                  if (statusOrder != sessionStatusOrder) {
                    session.setOrderStatus = state.data.status;
                    switch (statusOrder) {
                      case Order.driverAccept:
                        provider.fetchOrderDetail().listen((event) async {
                          if (event is GetOrderDetailLoading) {
                            log(' Get Order Details Loading');
                            showLoading();
                          } else if (event is GetOrderDetailLoaded) {
                            log(' Get Order Details Loaded');

                            provider
                                .fetchDriverDetail()
                                .listen((eventDriverDetail) async {
                              if (eventDriverDetail is GetDriverDetailLoaded) {
                                log(' Get Driver Details Loaded');

                                provider.changeOrderStatus =
                                    OrderStatus.driverAccept;
                                dismissLoading();
                                Timer timerDialogFoundDriver = Timer(
                                    const Duration(milliseconds: 3000), () {
                                  Navigator.pop(context);
                                });

                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return DriverFoundDialog(
                                      driverDetail: eventDriverDetail.data,
                                      onTap: () {
                                        timerDialogFoundDriver.cancel();
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                                trackingDriverTimer = Timer.periodic(
                                    const Duration(seconds: 5), (timer) {
                                  logMe("Tracking Driver");
                                  provider
                                      .fetchDriverLocation()
                                      .listen((eventDriverLocation) async {});
                                });
                              }
                            });
                          }
                        });
                        break;
                      case Order.departureToCustomerplace:
                        provider.changeFirstTracking = false;
                        break;
                      case Order.arriveAtCustomerPlace:
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return DepartDialog(
                                callback: (b, call) {
                                  if (b) {
                                    provider
                                        .submitStatusOrder(
                                            Order.customerConfirmation)
                                        .listen((event) async {
                                      if (event is UpdateStatusOrderLoading) {
                                        showLoading();
                                      } else if (event
                                          is UpdateStatusOrderLoaded) {
                                        await provider.removeMarker();
                                        dismissLoading();
                                      } else if (event
                                          is UpdateStatusOrderFailure) {
                                        dismissLoading();
                                      }
                                    });
                                  } else {
                                    if (call) {
                                      provider.callDriver();
                                    }
                                  }
                                },
                              );
                            });
                        break;
                      case Order.arriveAtDestination:
                        timer.cancel();
                        if (trackingDriverTimer != null) {
                          trackingDriverTimer!.cancel();
                        }
                        provider
                            .submitStatusOrder(Order.complete)
                            .listen((event) async {
                          if (event is UpdateStatusOrderLoading) {
                            showLoading();
                          } else if (event is UpdateStatusOrderLoaded) {
                            var homeProvider = Provider.of<HomeProvider>(
                                context,
                                listen: false);
                            await homeProvider.clearState();

                            dismissLoading();
                            Future.delayed(const Duration(milliseconds: 3000),
                                () async {
                              await provider.clearState();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                HomePage.routeName,
                                (route) => false,
                              );
                            });
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return ThankYouDialog();
                              },
                            );
                          } else if (event is UpdateStatusOrderFailure) {
                            dismissLoading();
                          }
                        });
                        break;
                    }
                  }
                }
              });
            });
            return Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: provider.kJapanCoordinate,
                  onMapCreated: (GoogleMapController controller) async {
                    provider.googleMapController = controller;
                    await provider.setCurrentLocation(widget.location);
                  },
                  polylines: provider.polylines,
                  markers: Set<Marker>.of(provider.markers.values),
                ),
                SafeArea(
                    child: Stack(children: [
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /** New code  */
                        Container(
                          color: whiteColor,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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

                        /**Old Code  */

                        // OriginWidget(
                        //   deviceWidth: _deviceSize.width,
                        //   isFromOrder: true,
                        // ),
                        // DestinationWidget(
                        //   deviceWidth: _deviceSize.width,
                        //   isFromOrder: true,
                        // ),

                        // // Top Section Drop And Pick up
                        // Expanded(
                        //     child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //       provider.orderStatus == OrderStatus.lookingDriver
                        //           ? const SizedBox()
                        //           : const CurrentLocationOrderWidget(),
                        //       const BottomContaineOrder()
                        //     ]))
                      ]),

                  // Searching Drivers
                  Container(
                    color: Colors.black12,
                    height: double.infinity,
                    child: provider.orderStatus == OrderStatus.lookingDriver
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: App(context).appHeight(25)),
                                    child: WaitingDriverDialog(
                                      size: constraints,
                                    ),
                                  ),
                                  const ButtonCancelOrder()
                                ],
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ]))
              ],
            );
          }),
        ));
  }

  show(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .5,
        ),
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0),
          ),
        ),
        builder: (context) {
          return SearchingRideBottomSheet();
        });
  }
}
