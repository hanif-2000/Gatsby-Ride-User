import 'dart:async';
import 'dart:developer';

import 'package:appkey_taxiapp_user/core/domain/entities/order_data_detail.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/destination_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/origin_widget.dart';
import 'package:appkey_taxiapp_user/core/static/enums.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/get_order_detail_state.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/get_status_order_state.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/widgets/driver_info_bottom_sheet.dart';
import 'package:appkey_taxiapp_user/socket/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/widgets/searching_ride_bottom_sheet.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/order_status.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../domain/entities/driver_detail.dart';
import '../providers/get_driver_detail_state.dart';
import 'components/chat_screen.dart';
import 'components/receipt_screen.dart';

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

    Provider.of<SocketProvider>(context, listen: false).sendRequest();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSearchingVehiclesBottomSheet(context);
    });
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

    log("location in order page:--->>${widget.location}");

    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Consumer<OrderProvider>(builder: (context, provider, _) {
              if (checkOrderStatusTimer != null) {
                checkOrderStatusTimer!.cancel();
              }

              checkOrderStatusTimer = Timer.periodic(const Duration(seconds: 3),
                  (Timer timer) async {
                provider.fetchOrderStatus().listen((state) async {
                  if (state is GetStatusOrderLoaded) {
                    int sessionStatusOrder = session.orderStatus;
                    int statusOrder = state.data.status;
                    if (statusOrder != sessionStatusOrder) {
                      session.setOrderStatus = state.data.status;
                      switch (statusOrder) {
                        /** Driver Accepted the Order (Status 1) */
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
                                if (eventDriverDetail
                                    is GetDriverDetailLoaded) {
                                  log(' Get Driver Details Loaded');

                                  provider.changeOrderStatus =
                                      OrderStatus.driverAccept;
                                  dismissLoading();

                                  Navigator.pop(context);
                                  provider.updateOrderAccepted();

                                  // Timer timerDialogFoundDriver = Timer(
                                  //     const Duration(milliseconds: 3000), () {
                                  //   Navigator.pop(context);
                                  // });

                                  //Show dialog when Driver Found

                                  //New Code to show bottom sheet when Driver Found

                                  // showDriverFoundBottomSheet(
                                  //     context, eventDriverDetail.data);

                                  // provider
                                  //     .updateOrderId(eventDriverDetail.data);

                                  provider.updateDriverDetails(
                                      data: eventDriverDetail.data);

                                  // showDriverFoundBottomSheet(
                                  //     context: context,
                                  //     driverDetails: eventDriverDetail.data,
                                  //     driverStatusText: statusOrder == 1
                                  //         ? "Your Driver is arriving in 5 minutes"
                                  //         : statusOrder == 2
                                  //             ? "Your Driver is on the way"
                                  //             : statusOrder == 3
                                  //                 ? "Driver has reached your location"
                                  //                 : statusOrder == 4
                                  //                     ? ""
                                  //                     : statusOrder == 5
                                  //                         ? ""
                                  //                         : statusOrder == 6
                                  //                             ? "You have reached your destination"
                                  //                             : statusOrder == 7
                                  //                                 ? ""
                                  //                                 : "",
                                  //     provider: provider);

                                  /** Old Code Showing pop when Driver found */
                                  // showDialog(
                                  //   barrierDismissible: false,
                                  //   context: context,
                                  //   builder: (context) {
                                  //     return DriverFoundDialog(
                                  //       driverDetail: eventDriverDetail.data,
                                  //       onTap: () {
                                  //         timerDialogFoundDriver.cancel();
                                  //         Navigator.pop(context);
                                  //       },
                                  //     );
                                  //   },
                                  // );
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

                        /** Departure to Customer Place (Status 2) */
                        case Order.departureToCustomerplace:
                          provider.changeFirstTracking = false;

                          provider
                              .updateDriverStatus(appLoc.yourDriverIsOnTheWay);

                          break;

                        /** Arrived at Customer Place (Status 3) */
                        case Order.arriveAtCustomerPlace:
                          provider.updateDriverStatus(
                              appLoc.driverReachYourLocation);

                          // showDialog(
                          //     barrierDismissible: false,
                          //     context: context,
                          //     builder: (context) {
                          //       return DepartDialog(
                          //         callback: (b, call) {
                          //           if (b) {
                          //             provider
                          //                 .submitStatusOrder(
                          //                     Order.customerConfirmation)
                          //                 .listen((event) async {
                          //               if (event is UpdateStatusOrderLoading) {
                          //                 showLoading();
                          //               } else if (event
                          //                   is UpdateStatusOrderLoaded) {
                          //                 await provider.removeMarker();
                          //                 dismissLoading();
                          //               } else if (event
                          //                   is UpdateStatusOrderFailure) {
                          //                 dismissLoading();
                          //               }
                          //             });
                          //           } else {
                          //             if (call) {
                          //               provider.callDriver();
                          //             }
                          //           }
                          //         },
                          //       );
                          //     });

                          break;

                        /** Departure to Destination  (Status 5)*/

                        case Order.departureToDestination:
                          provider.updateDriverStatus(
                              appLoc.departureToYourDestination);
                          break;

                        /** Arrived at Destination (Status 6) */
                        case Order.arriveAtDestination:
                          provider.updateDriverStatus(
                              appLoc.youHaveReachedYourDestination);

                          timer.cancel();

                          if (trackingDriverTimer != null) {
                            trackingDriverTimer!.cancel();
                          }
//                           provider
//                               .submitStatusOrder(Order.complete)
//                               .listen((event) async {
//                             if (event is UpdateStatusOrderLoading) {
//                               showLoading();
//                             } else if (event is UpdateStatusOrderLoaded) {
//                               var homeProvider = Provider.of<HomeProvider>(
//                                   context,
//                                   listen: false);
//                               await homeProvider.clearState();

//                               dismissLoading();
//                               Future.delayed(const Duration(milliseconds: 3000),
//                                   () async {
//                                 // await provider.clearState();

//                                 await provider.orderReceiptApi();

// //Redirect to Receipt Screen when Ride completed
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => ReceiptScreen(),
//                                 //   ),
//                                 // );
//                                 // Navigator.pushNamedAndRemoveUntil(
//                                 //   context,
//                                 //   HomePage.routeName,
//                                 //   (route) => false,
//                                 // );
//                               });
//                               // showDialog(
//                               //   barrierDismissible: false,
//                               //   context: context,
//                               //   builder: (context) {
//                               //     return ThankYouDialog();
//                               //   },
//                               // );
//                             } else if (event is UpdateStatusOrderFailure) {
//                               dismissLoading();
//                             }
//                           });
                          break;

                        case Order.complete:
                          provider.orderReceiptApi();

                          provider.updateReachedDestination();
                          break;
                      }
                    }
                  }
                });
              });
              return Stack(
                children: <Widget>[
                  //Google Maps
                  GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(provider.lat, provider.long),
                      zoom: 14.4746,
                    ),
                    onMapCreated: (GoogleMapController controller) async {
                      provider.googleMapController = controller;
                      await provider.setCurrentLocation(widget.location);
                    },
                    polylines: provider.polylines,
                    markers: Set<Marker>.of(provider.markers.values),
                  ),

                  // Address Text Fields
                  SafeArea(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        /** New code  */

                        provider.orderStatus != OrderStatus.lookingDriver
                            ? SizedBox(
                                height: 10,
                              )
                            : Container(
                                color: whiteColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
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
                                            locationPngIcon,
                                            height: 24.0,
                                            width: 24.0,
                                            fit: BoxFit.cover,
                                          ),
                                          SvgPicture.asset(dottedLine),
                                          SvgPicture.asset(
                                            destinationSvgIcon,
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
                        Spacer(),

                        Visibility(
                          visible: provider.isOrderAccepted,
                          // visible: true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: DriverInfoBottomSheet(
                              callEvent: () {
                                provider.callDriver();
                              },
                              messageEvent: () {
                                log("OnClick on MESSAGE event");

                                // showBottomSheet(
                                //   context: context,
                                //   builder: (context) {
                                //     return Text("asdfs");
                                //   },
                                // );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen()));
                              },
                              viewReceiptEvent: () {
                                log("On Click on view receipt");
                                // provider.orderReceiptApi().listen((event) {
                                //   // log("Event :----------s  " +
                                //   //     event.);
                                // });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReceiptScreen(),
                                  ),
                                );
                              },
                              driverStatusText: provider.driverStatus,
                              category: provider.carModal,
                              driverId: provider.driverId,
                              driverImage: provider.driverImg,
                              driverName: provider.driverName,
                              platerNumber: provider.plateNumber,
                              rating: provider.ratings,
                              isReceiptVisible: provider.isReachedToDestination,
                              // isReceiptVisible: true,
                            ),
                          ),
                        ),
                      ])),
                ],
              );
            }),
          ),
        ));
  }

  showSearchingVehiclesBottomSheet(BuildContext context) {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .4,
        ),
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        )),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return SearchingRideBottomSheet();
        });
  }

  showDriverFoundBottomSheet(
      {required BuildContext context,
      required DriverDetail driverDetails,
      required String driverStatusText,
      required OrderProvider provider}) {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: false,
        backgroundColor: whiteColor,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        )),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Wrap(children: [
            DriverInfoBottomSheet(
              callEvent: () {
                provider.callDriver();
              },
              messageEvent: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
              viewReceiptEvent: () {},
              driverStatusText: driverStatusText,
              category: driverDetails.model,
              driverId: '4',
              driverImage: '',
              driverName: driverDetails.name,
              platerNumber: driverDetails.plat,
              rating: "4.5",
              isReceiptVisible:
                  (provider.session.orderStatus == (6)) ? true : false,
            ),
          ]);
        });
  }
}
