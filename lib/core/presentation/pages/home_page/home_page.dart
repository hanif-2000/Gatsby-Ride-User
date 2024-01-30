import 'dart:async';
import 'dart:developer';
import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/destination_widget.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/origin_widget.dart';
import 'package:GetsbyRideshare/core/static/assets.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:GetsbyRideshare/socket/latest_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../features/order/presentation/pages/new_order_page.dart';
import '../../../domain/entities/order_data_detail.dart';
import '../../providers/home_provider.dart';
import '../../widgets/bottom_sheet_book_ride.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  //  OrderDetail previousOrderDetails = OrderDetail();
  // late OrderDataDetail _orderDataDetail;

  var socketProvider = locator<LatestSocketProvider>();

  // late DriverDetailModel previousDriverDetails;

  // Future<void> convertOrderAndDriverDetailsIntoObject() async {
  // log("session order details are:-->. ${session.orderDetails}");
  // // Decode JSON into a Map
  // Map<String, dynamic> jsonOrderMap = json.decode(session.orderDetails);
  // Map<String, dynamic> jsonDriverMap = json.decode(session.DriverDetails);

  // log("session order details are jsonOrderMap:-->. ${jsonOrderMap}");
  // log("session driver details are jsonOrderMap:-->. ${jsonDriverMap}");

  // setState(() {
  //   // _orderDataDetail = OrderDataDetail.fromJson(jsonOrderMap);
  //   previousOrderDetails = OrderDetail.fromJson(jsonOrderMap);

  //   previousDriverDetails = DriverDetailModel.fromJson(jsonDriverMap);
  // });
  // socketProvider.updateDriverDetails(
  //   rating = previousDriverDetails.rating.toString(),
  // );
  // }

  @override
  void initState() {
    log("************ IS ORDER RUNNING ${session.isRunningOrder}**********--------->>..");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Provider.of<SocketProvider>(context, listen: false).connectToSocket();
    // Provider.of<NewSocketProvider>(context, listen: false).connectToSocket();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      if (session.isRunningOrder) {
        socketProvider
            .fetchOrderDetails(int.parse(session.orderId))
            .then((value) {
          logMe(" order details are:::::::::::::: ${value}");

          socketProvider.updateOrderDetailsModel(data: value);

          socketProvider
              .fetchDriverDetails(int.parse(session.driverId))
              .then((value) {
            socketProvider.updateDriverDetailsModel(data: value);
            logMe(" driver details are:::::::::::::: ${value}");

            Navigator.pushNamedAndRemoveUntil(
                context, NewOrderPage.routeName, (route) => false,
                arguments: OrderDataDetail(
                    originAddress: socketProvider
                        .orderDetailResponseModel!.data.startAddress,
                    destinationAddress: socketProvider
                        .orderDetailResponseModel!.data.endAddress,
                    originLatLng: LatLng(
                        double.parse(socketProvider
                            .orderDetailResponseModel!.data.startCoordinate
                            .split(',')
                            .first),
                        double.parse(socketProvider
                            .orderDetailResponseModel!.data.startCoordinate
                            .split(',')
                            .last)),
                    destinationLatLng: LatLng(
                        double.parse(socketProvider.orderDetailResponseModel!.data.endCoordinate.split(',').first),
                        double.parse(socketProvider.orderDetailResponseModel!.data.endCoordinate.split(',').first))));
          });
        });
        // // log(" session order id :--> ${session.orderId}");
        // // log(" session driver id :--> ${session.driverId}");

        // // log("driver dsdfbadhsfladsf*----${session.driverName}");
        // // log("origin lat long *----${session.originLat},${session.originLong}");
        // // log("origin lat long *----${session.destinationLat},${session.destinationLong}");
        // // log("driver lat long *----${session.driverLatLng}");
        // // socketProvider.fetchOrderDetail().listen((event) async {
        // //   if (event is GetOrderDetailLoading) {
        // //     log(' Get Order Details Loading');
        // //     showLoading();
        // //   } else if (event is GetOrderDetailLoaded) {
        // //     log(' Get Order Details Loaded');

        // //     logMe("ORDER DETAILS ARE:-->> ${event.data}");

        // //     socketProvider
        // //         .fetchDriverDetails();

        // //   }
        // // });

        // socketProvider.updateDriverLatLng(
        //   driverLtLng: LatLng(
        //     double.parse(session.driverLatLng.split(',').first),
        //     double.parse(session.driverLatLng.split(',').last),
        //   ),
        // );

        // // socketProvider.updateDriverDetails(
        // //     driverNam: session.driverName,
        // //     rating: session.driverRating,
        // //     carModa: session.vehicleModel,
        // //     plateNumbe: session.vehiclePlate,
        // //     driverI: session.driverRating,
        // //     phoneNumbe: session.driverPhn,
        // //     driverIm: session.driverImg,
        // //     driverRate: session.driverRating,
        // //     vehicleNam: session.vehicleName,
        // //     totalPrice: session.rideTotal);

        // Navigator.pushNamedAndRemoveUntil(
        //     context, NewOrderPage.routeName, (route) => false,
        //     arguments: OrderDataDetail(
        //         originAddress: session.originAddress,
        //         destinationAddress: session.destinationAddress,
        //         originLatLng: LatLng(session.originLat, session.originLong),
        //         destinationLatLng:
        //             LatLng(session.destinationLat, session.destinationLong)));

        // // convertOrderAndDriverDetailsIntoObject().then((value) {

        // // });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Session session = locator<Session>();

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
                    initialCameraPosition: CameraPosition(
                      target: LatLng(map.lat, map.long),
                      zoom: 14.4746,
                    ),
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
                              child: map.originAddress == ''
                                  ? Center(
                                      child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: CircularProgressIndicator(),
                                    ))
                                  : Padding(
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
                                                  deviceWidth:
                                                      _deviceSize.width,
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
                                  text: Text(
                                    appLoc.confirm,
                                    style: TextStyle(
                                      fontFamily: 'poPPinSemiBold',
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor,
                                    ),
                                  ),
                                  event: () async {
                                    log("origin" + map.originLatLng.toString());
                                    log("destination" +
                                        map.destinationLatLng.toString());
                                    log(map.distance.toString());

                                    log(map.originIsFilled.toString());
                                    log(map.destinationIsFilled.toString());

                                    if (!map.originIsFilled ||
                                        !map.destinationIsFilled) {
                                      showToast(message: "Select Address");
                                    } else {
                                      // try {
                                      //   // Get real distance
                                      //   var response = await Dio().get(
                                      //       'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${map.destinationLatLng.latitude},${map.destinationLatLng.longitude}&origins=${map.originLatLng.latitude},${map.originLatLng.longitude}&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs');
                                      //   log(" response of real distance:--->>> ${response.data}");

                                      //   var data = routeModal
                                      //           .GoogleRouteDistanceResponseModal
                                      //       .fromJson(response.data);
                                      // } catch (e) {
                                      //   print(e);
                                      // }
                                      map
                                          .fetchVehicleCategory()
                                          .listen((event) {
                                        log("========>>>>>>" +
                                            event.toString());
                                      });

                                      showModalBottomSheet(
                                        barrierColor: Colors.transparent,
                                        useRootNavigator: true,
                                        // isScrollControlled: true,
                                        constraints: BoxConstraints(
                                            maxHeight:
                                                _deviceSize.height * .45),
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
                                    }
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
