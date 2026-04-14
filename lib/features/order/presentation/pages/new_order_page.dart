import 'dart:async';
import 'dart:developer';
import 'package:GetsbyRideshare/core/domain/entities/order_data_detail.dart';
import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';

import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/socket/test_socket_provider.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/chat_page.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/ratings.dart';
import 'package:GetsbyRideshare/features/order/presentation/widgets/driver_info_bottom_sheet.dart';
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

class _NewOrderPageState extends State<NewOrderPage> with WidgetsBindingObserver {
  final session = locator<Session>();
  final homeProvider = locator<HomeProvider>();
  Timer? _timer;
  bool _hasNavigatedToReceipt = false;
  bool _hasClosedSearchingSheet = false;

  int _lastProcessedStatus = -1;

  void _onSocketUpdate() {
    if (!mounted) return;
    final socketProvider = context.read<TestSocketProvider>();
    if (socketProvider.isOrderAccepted && !_hasClosedSearchingSheet) {
      _hasClosedSearchingSheet = true;
      _timer?.cancel();
      session.setSearchingTime = 180;
      log("Accept received — closing searching bottom sheet");
      print("******* _onSocketUpdate: isOrderAccepted=true, attempting pop *******");

      if (!mounted) return;
      final navigator = Navigator.of(context, rootNavigator: true);
      print("******* canPop: ${navigator.canPop()} *******");
      if (navigator.canPop()) {
        navigator.pop();
      }
      socketProvider.updateIsOrderAccepted(val: false);
    }

    final currentStatus = socketProvider.currentOrderStatus;
    if (currentStatus > 0 && currentStatus != _lastProcessedStatus) {
      _lastProcessedStatus = currentStatus;
      log("Status changed to: $currentStatus");

      if (currentStatus == 7 && !_hasNavigatedToReceipt && !session.isPaymentDone) {
        _hasNavigatedToReceipt = true;
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, ReceiptScreen.routeName, (route) => false);
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    dismissLoading();
    var newSocketProvider = context.read<TestSocketProvider>();
    WidgetsBinding.instance.addObserver(this);
    newSocketProvider.addListener(_onSocketUpdate);
    newSocketProvider.updateBitsImage().then((value) {
      if (session.driverId != '') {
        newSocketProvider.joinExitRoom(
            type: "unJoin",
            receiverId: int.parse(session.driverId.toString()));
      }
    });

    void startTimerAndNavigate({required int time}) {
      Duration duration = Duration(seconds: time);
      int remainingSeconds = duration.inSeconds;

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        print('Remaining time: ${remainingSeconds}');
        if (remainingSeconds <= 0) {
          timer.cancel();

          if (!mounted) return;

          newSocketProvider.cancelRideByCustomer().then((value) async {
            session.setSearchingTime = 180;
            if (value) {
              session.setIsRunningOrder = false;
              dismissLoading();

              if (!mounted) return;
              Navigator.pop(context);

              WidgetsBinding.instance.addPostFrameCallback((callback) {
                showDialog(
                  barrierDismissible: false,
                  context: locator<GlobalKey<NavigatorState>>().currentContext!,
                  builder: (BuildContext context) {
                    return PopScope(
                      canPop: false,
                      child: AlertDialog(
                        title: Text(
                          "No Nearby Driver Found",
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text("Search Again"),
                            onPressed: () async {
                              logMe("search again called-->>");
                              session.setIsRunningOrder = true;
                              final navContext = locator<GlobalKey<NavigatorState>>().currentContext!;
                              Navigator.pop(context);
                              final paymentStr = session.bookingPaymentMethod == 1 ? "cash" : "card";
                              _hasClosedSearchingSheet = false;
                              _lastProcessedStatus = -1; 
                              newSocketProvider.createRideRequest(
                                originLatLngs: "${session.originLat},${session.originLong}",
                                destinationLatLngs: "${session.destinationLat},${session.destinationLong}",
                                vehicleCatagory: session.bookingVehicleCategoryId,
                                startAddress: session.originAddress,
                                endAddress: session.destinationAddress,
                                estimatedTime: session.estimatedTime.isNotEmpty ? session.estimatedTime : "0.0",
                                distance: session.estimatedDistance,
                                total: session.rideTotal,
                                payment_method: paymentStr,
                              ).then((value) {
                                startTimerAndNavigate(time: 180);
                                showSearchingVehiclesBottomSheet(navContext);
                                if (value) {
                                  var session = locator<Session>();
                                  session.setOrderStatus = 0;
                                  session.setIsRunningOrder = true;
                                  session.setBookingTime = DateTime.now().toString();
                                } else {
                                  showToast(message: "Something went wrong Please try again");
                                }
                              });
                            },
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            child: Text("Cancel ride"),
                            onPressed: () async {
                              session.setIsRunningOrder = false;
                              Navigator.pop(context);
                              _timer?.cancel();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, HomePage.routeName, (route) => false);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
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

    log("order status is:  -->> ${session.orderStatus}");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (session.orderStatus.toString() == "0") {
        startTimerAndNavigate(time: session.searchingTime);
        showSearchingVehiclesBottomSheet(context);
      } else {
        newSocketProvider.getTotalUnreadCount(int.parse(session.driverId));
        session.setSearchingTime = 180;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    try {
      final socketProvider = context.read<TestSocketProvider>();
      socketProvider.removeListener(_onSocketUpdate);
    } catch (e) {
      log("dispose listener remove error: $e");
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = locator<Session>();
    var _deviceSize = MediaQuery.of(context).size;
    log("location in order page:--->>${widget.location}");

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Consumer<TestSocketProvider>(builder: (context, provider, _) {
            final newSocketProvider = context.read<TestSocketProvider>();


            return Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(newSocketProvider.lat, newSocketProvider.long),
                      zoom: newSocketProvider.zoom,
                      bearing: newSocketProvider.bearing),
                  onMapCreated: (GoogleMapController controller) async {
                    newSocketProvider.googleMapController = controller;
                    newSocketProvider.setCurrentLocation(widget.location);
                  },
                  onCameraMove: (val) async {
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
                        margin: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)),
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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: _deviceSize.width * .8,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0),
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
                                      padding: EdgeInsets.symmetric(vertical: 10.0),
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
                      Spacer(),
                      Visibility(
                        visible: (newSocketProvider.currentOrderStatus != 0) ||
                            (session.orderStatus != 0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: newSocketProvider.driverDetailResponseModel != null
                                ? DriverInfoBottomSheet(
                                    driverStatusText: ((newSocketProvider.currentOrderStatus == 1) ||
                                            (session.orderStatus == 1))
                                        ? "Driver is arriving"
                                        : ((newSocketProvider.currentOrderStatus == 2) ||
                                                (session.orderStatus == 2))
                                            ? "Driver is on the way"
                                            : ((newSocketProvider.currentOrderStatus == 3) ||
                                                    (session.orderStatus == 3))
                                                ? "Driver reached your location"
                                                : ((newSocketProvider.currentOrderStatus == 5) ||
                                                        (session.orderStatus == 5))
                                                    ? "Departure to your Destination"
                                                    : ((newSocketProvider.currentOrderStatus == 7) ||
                                                            (session.orderStatus == 7))
                                                        ? "Ride is Completed"
                                                        : "",
                                    newMessgeCount: newSocketProvider.unreadMessageCount,
                                    reviewEvent: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RatingsScreen(
                                                  driverId: session.driverId)));
                                    },
                                    callEvent: () {
                                      newSocketProvider.callDriver();
                                    },
                                    messageEvent: () async {
                                      log("OnClick on MESSAGE event");
                                      bool unread = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage()));
                                      if (unread) {
                                        provider.joinExitRoom(
                                          type: "unJoin",
                                          receiverId: int.parse(session.driverId),
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
                                    isReceiptVisible: ((newSocketProvider.currentOrderStatus == 7) ||
                                            (session.orderStatus == 7))
                                        ? true
                                        : false,
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

  showSearchingVehiclesBottomSheet(BuildContext context) {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        )),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (ctx) {
          return SizedBox(
            height: MediaQuery.of(ctx).size.height * .45,
            child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (_, __) => {},
                child: SearchingRideBottomSheet()),
          );
        }).whenComplete(() {
      log("THis is called after open Bottom sheet---");
    });
  }
}