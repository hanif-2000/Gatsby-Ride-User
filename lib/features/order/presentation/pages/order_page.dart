import 'dart:async';
import 'dart:developer';
import 'package:GetsbyRideshare/core/domain/entities/order_data_detail.dart';
import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/chat_page.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/ratings.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/get_order_detail_state.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/get_status_order_state.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/order_provider.dart';
import 'package:GetsbyRideshare/features/order/presentation/widgets/driver_info_bottom_sheet.dart';
import 'package:GetsbyRideshare/socket/latest_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/providers/home_provider.dart';
import '../../../../core/presentation/widgets/searching_ride_bottom_sheet.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/order_status.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../providers/get_driver_detail_state.dart';
import '../providers/update_status_order_state.dart';
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

  final session = locator<Session>();
  final newSocketProvider = locator<LatestSocketProvider>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // newSocketProvider.connectToSocket(context);
    // Provider.of<SocketProvider>(context, listen: false).connectToSocket();
    // newSocketProvider.connectToSocket();q

    var orderProvider = Provider.of<OrderProvider>(context, listen: false);

    log("order status is:  -->> ${session.orderStatus}");

    if (session.orderStatus != 0) {
      log("session order status is not ==== 0");

      // orderProvider.fetchDriverDetail().listen((eventDriverDetail) async {
      //   if (eventDriverDetail is GetDriverDetailLoaded) {
      //     orderProvider.updateDriverDetails(data: eventDriverDetail.data);
      //     newSocketProvider.getTotalUnreadCount(int.parse(session.driverId));
      //   }
      // });
      // newSocketProvider.listenRequests();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (session.orderStatus == 0) {
        showSearchingVehiclesBottomSheet(context);

        //Automatically cancel order ride request after 5 minutes

        Future.delayed(Duration(seconds: 300), () {
          if (session.orderStatus == 0) {
            orderProvider.submitStatusOrder(Order.cancel).listen((event) async {
              if (event is UpdateStatusOrderLoading) {
                showLoading();
                log("Order Status LOADING");
              } else if (event is UpdateStatusOrderLoaded) {
                log("Order Status LOADED--------");

                var homeProvider =
                    Provider.of<HomeProvider>(context, listen: false);
                await homeProvider.clearState();
                session.setOrderStatus = 100;
                dismissLoading();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomePage.routeName,
                  (route) => false,
                );
              } else if (event is UpdateStatusOrderFailure) {
                log("Update Order Status Failed.......");
                dismissLoading();
              }
            });
          }
        });
      } else {
        log("else called ");
        newSocketProvider.getTotalUnreadCount(int.parse(session.driverId));
      }
    });

    log("location in orde page is:-->> ${widget.location.originAddress}");
  }

  @override
  void dispose() {
    super.dispose();
    checkOrderStatusTimer?.cancel();
    trackingDriverTimer?.cancel();
    newSocketProvider.disconnectSocket();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final session = locator<Session>();
    var _deviceSize = MediaQuery.of(context).size;

    log("location in order page:--->>${widget.location}");

    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Consumer<OrderProvider>(builder: (context, provider, _) {
              // newSocketProvider
              //     .getTotalUnreadCount(int.parse(session.driverId));
              if (checkOrderStatusTimer != null) {
                checkOrderStatusTimer!.cancel();
              }

              checkOrderStatusTimer = Timer.periodic(const Duration(seconds: 4),
                  (Timer timer) async {
                provider.fetchOrderStatus().listen((state) async {
                  log("called every 3 seconds");

                  if (state is GetStatusOrderLoaded) {
                    int sessionStatusOrder = session.orderStatus;
                    int statusOrder = state.data.status;

                    log("state data status is: ${state.data.status}");

                    if (statusOrder != sessionStatusOrder) {
                      log("sesstion or real order different ");
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

                                  provider
                                      .updateOrderId(eventDriverDetail.data);

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
                          log("status is --2");

                          break;

                        /** Arrived at Customer Place (Status 3) */
                        case Order.arriveAtCustomerPlace:
                          provider.updateDriverStatus(
                              appLoc.driverReachYourLocation);
                          await provider.removeMarker();
                          log("status is --3");

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

/** Ride canceled by DRIVER (Status 8)*/

                        case Order.cancel:
                          provider.isCanceledByDriver
                              ? showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          Text("Ride cancelled by the Driver"),
                                      actions: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: black15141FColor,
                                            ),
                                            onPressed: () async {
                                              var homeProvider =
                                                  Provider.of<HomeProvider>(
                                                      context,
                                                      listen: false);
                                              await homeProvider.clearState();
                                              await provider.clearState();
                                              Navigator.pop(context);

                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  HomePage.routeName,
                                                  (route) => false);
                                            },
                                            child: Text("Find new Driver"))
                                      ],
                                    );
                                  },
                                )
                              : SizedBox();
                          log("status is --8");

                          break;

                        /** Departure to Destination  (Status 5)*/

                        case Order.departureToDestination:
                          provider.updateDriverStatus(
                              appLoc.departureToYourDestination);
                          log("status is --5");

                          break;

                        /** Arrived at Destination (Status 6) */
                        case Order.arriveAtDestination:
                          provider.updateDriverStatus(
                              appLoc.youHaveReachedYourDestination);
                          await provider.removeMarker();
                          log("status is --6");

                          timer.cancel();

                          if (trackingDriverTimer != null) {
                            trackingDriverTimer!.cancel();
                          }
                          provider.updateReachedDestination();

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
                          provider.updateDriverStatus(appLoc.complete);
                          provider.orderReceiptApi();
                          log("status is --7");
                          timer.cancel();

                          if (trackingDriverTimer != null) {
                            trackingDriverTimer!.cancel();
                          }

                          provider.updateReachedDestination();
                          break;
                      }
                    } else {
                      log("sesstion or real order are same ");

                      // log("else called==========>>>>>>>>>>>>>>>>>>>>>>>>>> when restart app");
                      if ((session.orderStatus == 1) ||
                          (session.orderStatus == 2) ||
                          (session.orderStatus == 3) ||
                          (session.orderStatus == 5) ||
                          (session.orderStatus == 6)) {
                        log("current order session is:----${session.orderStatus}");
                        // trackingDriverTimer =
                        //     Timer.periodic(const Duration(seconds: 5), (timer) {
                        //   logMe("Tracking Driver");
                        provider
                            .fetchDriverLocation()
                            .listen((eventDriverLocation) async {});
                        // });
                        ;
                      } else if (session.orderStatus == 7) {
                        checkOrderStatusTimer?.cancel();
                        trackingDriverTimer?.cancel();
                      }

                      if ((session.orderStatus == 2) ||
                          (session.orderStatus == 3) ||
                          (session.orderStatus == 5) ||
                          (session.orderStatus == 6)) {
                        provider.changeFirstTracking = false;
                      }

                      // if (session.orderStatus == 2) {
                      //   provider
                      //       .updateDriverStatus(appLoc.yourDriverIsOnTheWay);
                      // } else if (session.orderStatus == 3) {
                      //   provider
                      //       .updateDriverStatus(appLoc.driverReachYourLocation);
                      //   await provider.removeMarker();
                      // } else if (session.orderStatus == 5) {
                      //   provider.updateDriverStatus(appLoc.departToDestination);
                      // } else if (session.orderStatus == 6) {
                      //   provider.updateDriverStatus(appLoc.arriveAtDestination);
                      // } else if (session.orderStatus == 7) {
                      //   checkOrderStatusTimer?.cancel();
                      //   trackingDriverTimer?.cancel();
                      //   provider.updateDriverStatus(appLoc.complete);
                      // }

                      // session.setOrderStatus = state.data.status;

                      log("session and real order status same");
                    }
                  }
                });
              });

              return Stack(
                children: <Widget>[
                  //Google Maps
                  GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(provider.lat, provider.long),
                      zoom: 19,
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
                            : SizedBox(
                                height: 10,
                              ),

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
                                  // mainAxisAlignment: MainAxisAlignment.center,
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
                                    SizedBox(
                                      width: _deviceSize.width * .8,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Text(
                                          widget.location.originAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'poPPinRegular',
                                              fontSize: 17.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    // OriginWidget(
                                    //   deviceWidth: _deviceSize.width,
                                    //   isFromOrder: false,
                                    // ),

                                    // Flexible(
                                    //   child: Container(
                                    //     width: _deviceSize.width,
                                    //     child: Text(
                                    //       widget.location.originAddress,
                                    //       softWrap: false,
                                    //       overflow: TextOverflow.ellipsis,
                                    //       style: const TextStyle(
                                    //           fontFamily: 'poPPinRegular',
                                    //           fontSize: 17.0,
                                    //           color: Colors.black),
                                    //     ),
                                    //   ),
                                    // ),

                                    // Text(widget.location.originAddress),

                                    Container(
                                      margin: EdgeInsets.zero,
                                      width: _deviceSize.width * .8,
                                      height: 1.0,
                                      color: whiteEFEFEFColor,
                                    ),

                                    SizedBox(
                                      width: _deviceSize.width * .8,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Text(
                                          widget.location.destinationAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'poPPinRegular',
                                              fontSize: 17.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),

                                    // Flexible(
                                    //   child: Container(
                                    //     width: _deviceSize.width,
                                    //     child: Text(
                                    //       widget.location.destinationAddress,
                                    //       softWrap: false,
                                    //       overflow: TextOverflow.fade,
                                    //       style: const TextStyle(
                                    //           fontFamily: 'poPPinRegular',
                                    //           fontSize: 17.0,
                                    //           color: Colors.black),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   child: Text(
                                    //       widget.location.destinationAddress),

                                    //  DestinationWidget(
                                    //   deviceWidth: _deviceSize.width,
                                    //   isFromOrder: false,
                                    // ),
                                    // ),
                                  ],
                                )
                              ],
                            )),
                          ),
                        ),

                        // Column(
                        //   children: [
                        //     Text(
                        //         "Driver latlong realtime: ${provider.driverLat}" +
                        //             " , " +
                        //             "${provider.driverLng}"),
                        //     Text(
                        //         "Polyline is: ${provider.polylineCoordinates}"),
                        //   ],
                        // ),

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
                          visible: (provider.isOrderAccepted) ||
                              (session.orderStatus != 0),
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
                              newMessgeCount: Provider.of<LatestSocketProvider>(
                                      context,
                                      listen: true)
                                  .unreadMessageCount,
                              reviewEvent: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RatingsScreen(
                                            driverId: session.driverId)));
                              },

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
                                        builder: (context) => ChatPage()));
                              },
                              viewReceiptEvent: () async {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => RatingsScreen(
                                //       driverId: session.driverId,
                                //     ),
                                //   ),
                                // );
                                log("On Click on view receipt");
                                // provider.orderReceiptApi().listen((event) {
                                //   // log("Event :----------s  " +
                                //   //     event.);
                                // });

                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) =>
                                //         ReceiptScreen(),
                                //   ),
                                //   (route) => false,
                                // );
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
                              isReceiptVisible:
                                  ((session.orderStatus == 7)) ? true : false,
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
          maxHeight: MediaQuery.of(context).size.height * .45,
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
        }).whenComplete(() {
      log("THis is called after open Bottom sheet");
    });
  }

  // showDriverFoundBottomSheet(
  //     {required BuildContext context,
  //     required DriverDetail driverDetails,
  //     required String driverStatusText,
  //     required OrderProvider provider}) {
  //   showModalBottomSheet(
  //       isDismissible: false,
  //       isScrollControlled: false,
  //       backgroundColor: whiteColor,
  //       context: context,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(20.0),
  //         topLeft: Radius.circular(20.0),
  //       )),
  //       clipBehavior: Clip.antiAliasWithSaveLayer,
  //       builder: (context) {
  //         return Wrap(children: [
  //           DriverInfoBottomSheet(
  //             reviewEvent: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) =>
  //                           RatingsScreen(driverId: session.driverId)));
  //             },
  //             callEvent: () {
  //               provider.callDriver();
  //             },
  //             messageEvent: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => ChatScreen(),
  //                 ),
  //               );
  //             },
  //             viewReceiptEvent: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => ReceiptScreen(),
  //                 ),
  //               );
  //             },
  //             driverStatusText: driverStatusText,
  //             category: driverDetails.model,
  //             driverId: '4',
  //             driverImage: '',
  //             driverName: driverDetails.name,
  //             platerNumber: driverDetails.plat,
  //             rating: "4.5",
  //             isReceiptVisible:
  //                 (provider.session.orderStatus == (6)) ? true : false,
  //           ),
  //         ]);
  //       });
  // }
}
