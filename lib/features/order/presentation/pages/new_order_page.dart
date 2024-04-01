import 'dart:async';
import 'dart:developer';
import 'package:GetsbyRideshare/core/domain/entities/order_data_detail.dart';
import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/socket/test_socket_provider.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/chat_page.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/ratings.dart';
import 'package:GetsbyRideshare/features/order/presentation/widgets/driver_info_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/widgets/searching_ride_bottom_sheet.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import 'new_receipt_page.dart';

class NewOrderPage extends StatefulWidget {
  final OrderDataDetail location;

  const NewOrderPage({Key? key, required this.location}) : super(key: key);
  static const routeName = '/OrderPage';

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage>
    with WidgetsBindingObserver {
  // Timer? checkOrderStatusTimer, trackingDriverTimer;

  final session = locator<Session>();

  final newSocketProvider = locator<TestSocketProvider>();
  final homeProvider = locator<HomeProvider>();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    dismissLoading();
    WidgetsBinding.instance.addObserver(this);
    newSocketProvider.updateBitsImage().then((value) {
      if (session.isRunningOrder) {
        newSocketProvider.callTrakingDriver(LatLng(
            double.parse(session.driverLatLng.split(',').first),
            double.parse(session.driverLatLng.split(',').last)));
      }

      if (session.driverId != '') {
        newSocketProvider.joinExitRoom(
            type: "unJoin",
            context: context,
            receiverId: int.parse(session.driverId.toString()));
      }
    });
    String formatDuration(int seconds) {
      final minutes = (seconds / 60).floor();
      final remainingSeconds = seconds % 60;
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    void startTimerAndNavigate({required int time}) {
      Duration duration = Duration(seconds: time);
      int remainingSeconds = duration.inSeconds;

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        print('Remaining time: ${remainingSeconds}');

        if (remainingSeconds <= 0) {
          timer.cancel();
          newSocketProvider.cancelRideByCustomer().then((value) async {
            session.setSearchingTime = 300;
            if (value) {
              var homeProvider =
                  Provider.of<HomeProvider>(context, listen: false);
              await homeProvider.clearState();
              session.setIsRunningOrder = false;

              dismissLoading();

              Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.routeName,
                (route) => false,
              );
            } else {
              dismissLoading();
              showToast(message: "Something went wrong");
            }
          });
        } else {
          session.setSearchingTime = remainingSeconds;
          remainingSeconds--;
        }
      });
    }

    // void startTimerAndNavigate({time}) {

    //   Duration duration = Duration(minutes: time);

    //   _timer = Timer(duration, () {
    //     newSocketProvider.cancelRideByCustomer().then((value) async {
    //       if (value) {
    //         var homeProvider =
    //             Provider.of<HomeProvider>(context, listen: false);
    //         await homeProvider.clearState();
    //         dismissLoading();

    //         Navigator.pushNamedAndRemoveUntil(
    //           context,
    //           HomePage.routeName,
    //           (route) => false,
    //         );
    //       } else {
    //         dismissLoading();
    //         showToast(message: "Something went wrong");
    //       }
    //     });
    //     // );
    //   });
    // }

    // var orderProvider = Provider.of<OrderProvider>(context, listen: false);

    log("order status is:  -->> ${session.orderStatus}");

    // if (session.orderStatus != 0) {
    //   log("session order status is not ==== 0");
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // homeProvider.clearOldRideData();
      if (session.orderStatus.toString() == "0") {
        startTimerAndNavigate(time: session.searchingTime);
        showSearchingVehiclesBottomSheet(
          context,
        );
      } else {
        newSocketProvider.getTotalUnreadCount(int.parse(session.driverId));
        session.setSearchingTime = 300;

        _timer?.cancel();
        log("else called ");

        // newSocketProvider.getDriverDetailsById();
      }
    });

    log("location in orde page is:-->> ${widget.location.originAddress}");
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();

    // checkOrderStatusTimer?.cancel();%
    // trackingDriverTimer?.cancel();
    // newSocketProvider.disconnectSocket();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final session = locator<Session>();
    var _deviceSize = MediaQuery.of(context).size;

    log("location in order page:--->>${widget.location}");

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) => {},
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Consumer<TestSocketProvider>(builder: (context, provider, _) {
            if (newSocketProvider.isOrderAccepted) {
              _timer?.cancel();
              session.setSearchingTime = 300;

              Navigator.pop(context, true);
              // newSocketProvider.updateIsOrderAccepted(val: false);

              log("order status is: ${newSocketProvider.currentOrderStatus}");
            } else {}

            return Stack(
              children: <Widget>[
                //Google Maps
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(newSocketProvider.lat, newSocketProvider.long),
                      zoom: 14,
                      bearing: newSocketProvider.bearing),
                  onMapCreated: (GoogleMapController controller) async {
                    newSocketProvider.googleMapController = controller;
                    await newSocketProvider.setCurrentLocation(widget.location);
                  },
                  onCameraMove: (val)async{
                    newSocketProvider.updateZoom(val);
                    await newSocketProvider.googleMapController.getVisibleRegion();
                  },
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: true,
                  polylines: newSocketProvider.polylines,
                  markers: Set<Marker>.of(newSocketProvider.markers.values),
                ),

                // Address Text Fields
                SafeArea(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20,),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
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
                                  Container(
                                    margin: EdgeInsets.zero,
                                    width: _deviceSize.width * .8,
                                    height: 1.0,
                                    color: whiteEFEFEFColor,
                                  ),
                                  SizedBox(
                                    width: _deviceSize.width * .8,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
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
                                ],
                              ),
                            ],
                          )),
                        ),
                      ),
                      // ElevatedButton(
                      //     onPressed: () {}, child: Text("New Chat Screen")),
                      Spacer(),
                      Visibility(
                        visible: (newSocketProvider.currentOrderStatus != 0) ||
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
                            child: newSocketProvider
                                        .driverDetailResponseModel !=
                                    null
                                ? DriverInfoBottomSheet(
                                    driverStatusText: ((newSocketProvider
                                                    .currentOrderStatus ==
                                                1) ||
                                            (session.orderStatus == 1))
                                        ? "Driver is arriving"
                                        : ((newSocketProvider
                                                        .currentOrderStatus ==
                                                    2) ||
                                                (session.orderStatus == 2))
                                            ? "Driver is on the way"
                                            : ((newSocketProvider
                                                            .currentOrderStatus ==
                                                        3) ||
                                                    (session.orderStatus == 3))
                                                ? "Driver reached your location"
                                                : ((newSocketProvider
                                                                .currentOrderStatus ==
                                                            5) ||
                                                        (session.orderStatus ==
                                                            5))
                                                    ? "Departure to your Destination"
                                                    : ((newSocketProvider
                                                                    .currentOrderStatus ==
                                                                7) ||
                                                            (session.orderStatus ==
                                                                7))
                                                        ? "Ride is Completed"
                                                        : "",

                                    newMessgeCount:
                                        newSocketProvider.unreadMessageCount,
                                    reviewEvent: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RatingsScreen(
                                                      driverId:
                                                          session.driverId)));
                                    },

                                    callEvent: () {
                                      newSocketProvider.callDriver();
                                    },
                                    messageEvent: () async {
                                      log("OnClick on MESSAGE event");

                                      bool unread = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatPage()));

                                      if (unread) {
                                        provider.joinExitRoom(
                                          type: "unJoin",
                                          context: context,
                                          receiverId:
                                              int.parse(session.driverId),
                                        );
                                      }
                                    },
                                    viewReceiptEvent: () async {
                                      log("On Click on view receipt");

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReceiptScreen(),
                                        ),
                                      );
                                    },

                                    category: newSocketProvider
                                            .driverDetailResponseModel
                                            ?.message
                                            .carModel
                                            .toString() ??
                                        '',

                                    isReceiptVisible: ((newSocketProvider
                                                    .currentOrderStatus ==
                                                7) ||
                                            (session.orderStatus == 7))
                                        ? true
                                        : false,
                                    // isReceiptVisible: true,
                                  )
                                : Text("Fetching Driver Data...")),
                      ),
                    ])),
              ],
            );
          }),
        ),
      ),
    );
  }

  showSearchingVehiclesBottomSheet(
    BuildContext context,
  ) {
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
          return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) => {},
              child: SearchingRideBottomSheet());
        }).whenComplete(() {
      log("THis is called after open Bottom sheet");
    }).then((value) {
      if (value) {
        newSocketProvider.updateIsOrderAccepted(val: false);
      }
    });
  }
}
