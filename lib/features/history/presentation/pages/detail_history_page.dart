import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/history/presentation/providers/history_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/utility/app_settings.dart';
import '../../../../core/utility/helper.dart';
import '../../../order/presentation/pages/components/ratings.dart';
import '../../../testing/widgets/rating_widget.dart';
import '../../data/models/history_response_model.dart';
import 'package:provider/provider.dart';

import '../widgets/driver_profile.dart';

class DetailHistoryPage extends StatefulWidget {
  final HistoryOrder item;
  static const String routeName = "DetailHistoryPage";
  const DetailHistoryPage({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  var extraTimeTaken = "0 hr 0 Min 0 Sec";

  convertSecondsToMinutes() {
    if (widget.item.actual_time != '') {
      int seconds = double.parse(widget.item.actual_time)
          .toInt(); // Replace this with your desired number of seconds

      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;

      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;

      print('$seconds seconds is equivalent to:');
      print(
          '$hours hours, $remainingMinutes minutes, and $remainingSeconds seconds');

      setState(() {
        extraTimeTaken = "$hours"
            ' hr '
            '$remainingMinutes'
            ' min '
            '$remainingSeconds'
            ' sec ';
      });
    } else {}
  }

  @override
  void initState() {
    convertSecondsToMinutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: blackColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Trip Detail",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, HistoryProvider provider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //Show Trip Date/time and status
                  Container(
                    height: 50,
                    color: yellowF9EACCColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Trip Date and Time
                            Flexible(
                              flex: 2,
                              child: AutoSizeText(
                                "${DateFormat.yMMMd().format(
                                  (DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                                          widget.item.orderTime.toString(),
                                          true))
                                      .toLocal(),
                                )} ${DateFormat.jm().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.item.orderTime.toString(), true)).toLocal())}",
                                // DateFormat('dMMM yyyy, h:mma')
                                //     .format(widget.item.orderTime)
                                //     .toString(),
                                maxLines: 1,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (getHistoryStatus(widget.item.status!) ==
                                          "Cancelled")
                                      ? SvgPicture.asset(
                                          'assets/icons/red_dot.svg')
                                      : SvgPicture.asset(
                                          'assets/icons/green_dot.svg'),
                                  const SizedBox(
                                    width: 10.0,
                                  ),

                                  AutoSizeText(
                                    getHistoryStatus(widget.item.status!),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: (getHistoryStatus(
                                                  widget.item.status!) ==
                                              "Cancelled")
                                          ? redf52d56Color
                                          : green2DAA5FColor,
                                      fontSize: 14.0,
                                      fontFamily: 'poPPinMedium',
                                    ),
                                  ),
                                  // AutoSizeText(
                                  //   getHistoryStatus(widget.item.status),
                                  //   overflow: TextOverflow.ellipsis,
                                  //   maxLines: 2,
                                  //   style: formTextFieldStyle,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //Show Trip Map

                  Container(
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      zoomGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      mapType: MapType.normal,
                      gestureRecognizers: {}
                        ..add(
                          Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer(),
                          ),
                        )
                        ..add(Factory<ScaleGestureRecognizer>(
                            () => ScaleGestureRecognizer()))
                        ..add(Factory<TapGestureRecognizer>(
                            () => TapGestureRecognizer()))
                        ..add(Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer())),
                      // myLocationButtonEnabled: true,
                      // zoomControlsEnabled: true,
                      initialCameraPosition: const CameraPosition(
                        target: DEFAULT_LATLNG,
                        zoom: 14.4746,
                      ),
                      polylines: provider.polylines,
                      markers: Set<Marker>.of(provider.markers.values),
                      onMapCreated: (GoogleMapController controller) async {
                        provider.googleMapController = controller;
                        // await provider.setCurrentLocation(
                        //     widget.orderDetail, widget.customerDetail);
                        final pickup = LatLng(
                            double.tryParse(
                                widget.item.startCoordinate!.split(',').first)!,
                            double.tryParse(
                                widget.item.startCoordinate!.split(',').last)!);
                        final drop = LatLng(
                            double.tryParse(
                                widget.item.endCoordinate!.split(',').first)!,
                            double.tryParse(
                                widget.item.endCoordinate!.split(',').last)!);

                        await provider.createPickupAndDropMarker(pickup, drop);
                        await provider.setPolylineDirection(pickup, drop);
                      },
                    ),
                  ),

                  /** 
                 * 
                 * Show Trip Starting and Ending Points 
                 * **/

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),

                    //DRIVER DETAILS SECTION
                    child: Container(
                      color: whiteColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DriverProfileWidget(
                              onClickOnReview: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RatingsScreen(
                                      driverId: widget.item.driverId!,
                                    ),
                                  ),
                                );
                              },
                              category: widget.item.category.category!,
                              driverId: widget.item.driverId!,
                              driverImage: widget.item.image! == ''
                                  ? ''
                                  : widget.item.image!,
                              driverName: widget.item.driverName!,
                              platerNumber: widget.item.plateNumber!,
                              rating: widget.item.rating.toString(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 10.0, bottom: 0, right: 0.0),
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: whiteColor,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: SvgPicture.asset(
                                            'assets/icons/color_location_logo.svg')

                                        // Icon(
                                        //   Icons.my_location,
                                        //   color: primaryColor,
                                        //   size: 35,
                                        // ),
                                        ),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: Text(
                                              "Pickup Location",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'poPPinSemiBold',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Flexible(
                                            child: Text(
                                              widget.item.startAddress!,
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'poPPinMedium',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Divider()),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 10.0, bottom: 10.0, right: 10.0),
                            child: Container(
                                color: whiteColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: SvgPicture.asset(
                                            'assets/icons/destination_logo.svg')

                                        //  Icon(
                                        //   Icons.location_on,
                                        //   color: primaryColor,
                                        //   size: 35,
                                        // ),
                                        ),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: Text(
                                              "Drop location",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontFamily: 'poPPinSemiBold',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Flexible(
                                            child: Text(
                                              widget.item.endAddress!,
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'poPPinMedium',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),

                  //Show Payment Method
                  widget.item.paymentStatus != "no"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: yellowE4AC3BColor.withOpacity(.12),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(
                                      flex: 2,
                                      child: Text(
                                        "Payment Through",
                                        style: TextStyle(
                                          fontFamily: 'poPPinMedium',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,

                                        //                   ? SvgPicture.asset('assets/icons/card.svg')
                                        // : widget.paymentMode == 3
                                        //     ? SvgPicture.asset('assets/icons/google.svg')
                                        //     : SvgPicture.asset('assets/icons/apple.svg'),
                                        children: [
                                          widget.item.paymentMethod == "1"
                                              ? SvgPicture.asset(
                                                  'assets/icons/cash.svg',
                                                  height: 40,
                                                  width: 40,
                                                  fit: BoxFit.fill,
                                                )
                                              : widget.item.paymentMethod == "2"
                                                  ? SvgPicture.asset(
                                                      'assets/icons/card.svg',
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : widget.item.paymentMethod ==
                                                          "3"
                                                      ? SvgPicture.asset(
                                                          'assets/icons/google.svg',
                                                          height: 40,
                                                          width: 40,
                                                          fit: BoxFit.fill)
                                                      : SvgPicture.asset(
                                                          'assets/icons/apple.svg',
                                                          height: 40,
                                                          width: 40,
                                                          fit: BoxFit.fill),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 10.0,
                                            ),
                                            child: Text(
                                              widget.item.paymentMethod == "1"
                                                  ? "Cash"
                                                  : widget.item.paymentMethod ==
                                                          "2"
                                                      ? "Credit Card"
                                                      : widget.item
                                                                  .paymentMethod ==
                                                              "3"
                                                          ? "Google Pay"
                                                          : "Apple Pay",
                                              style: TextStyle(
                                                  fontFamily: 'poPPinMedium',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: grey7D7979Color),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )

                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     mediumVerticalSpacing(),
                                //     Text(
                                //       appLoc.paymentMethod,
                                //       style: const TextStyle(
                                //           fontFamily: 'Yu Ghotic',
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 16),
                                //     ),
                                //     smallVerticalSpacing(),
                                //     Text(
                                //       getPaymentMethod(widget.item),
                                //     ),
                                //     mediumVerticalSpacing(),
                                //   ],
                                // ),

                                ),
                          ))
                      : SizedBox(),

                  //Show payment status

                  widget.item.status == 7
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: whiteAccentColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Payment Status",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.item.paymentStatus == "no"
                                      ? "Pending"
                                      : "Paid",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: widget.item.paymentStatus == "no"
                                          ? redf52d56Color
                                          : green2DAA5FColor),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  //Show Price Details
                  widget.item.status == 7
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            height: _deviceSize.height * .6,
                            color: whiteColor,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        // height: constraints.maxHeight,
                                        decoration: const BoxDecoration(
                                          color: whiteColor,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: secondaryColor,
                                                  width: 0.3)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /**  Cab Type  **/
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text("Cab Type",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergeTypeTaxi(
                                                    widget.item.category,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                )
                                              ],
                                            ),
                                            /** Current ride payment **/
                                            SizedBox(
                                              height: 6.0,
                                            ),
                                            /** Total Distance **/
                                            //Distance
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Total Distance",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergeDistanceTxt(
                                                    widget.item.distance!,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            /** Total Distance **/
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Per Km Price",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergeDistanceTxt(
                                                    widget.item.category
                                                                .priceKm !=
                                                            null
                                                        ? widget.item.category
                                                            .priceKm
                                                            .toString()
                                                        : "0.0",
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Total Time",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  extraTimeTaken,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Per Minute Price",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergePriceTxt(
                                                    widget.item.category
                                                                .price_min !=
                                                            null
                                                        ? "${widget.item.category.price_min ?? "0.0"}"
                                                        : "0.0",
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Minimum fare",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergePriceTxt(widget.item
                                                              .minimum_fare ==
                                                          null
                                                      ? "0.0"
                                                      : widget.item.minimum_fare
                                                          .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Base fare",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergePriceTxt(widget
                                                              .item.base_fare ==
                                                          null
                                                      ? "0.0"
                                                      : widget.item.base_fare
                                                          .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Tech Fee",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergePriceTxt(
                                                      widget.item.tech_fee ==
                                                              null
                                                          ? "0.0"
                                                          : widget.item.tech_fee
                                                              .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6.0,
                                            ),
                                            //TCurrent Ride Payment
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Current Ride Payment",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergePriceTxt(double.parse(
                                                          widget.item.newTotal
                                                              .toString())
                                                      .toStringAsFixed(2)),
                                                  // mergePriceTxt(widget.item.tip ==
                                                  //         null
                                                  //     ? "0.0"
                                                  //     : widget.item.tip.toString()),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            /** Pending/Previous ride payment **/
                                            SizedBox(
                                              height: 6.0,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Pending Ride Payment",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergePriceTxt(widget
                                                      .item.pendingAmount),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),

//etxra timne
                                            SizedBox(
                                              height: 6.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Tip",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'poPPinSemiBold',
                                                        fontSize: 16)),
                                                Text(
                                                  mergePriceTxt(
                                                      widget.item.tip == null
                                                          ? "0.0"
                                                          : widget.item.tip
                                                              .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              appLoc.total,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: blackColor,
                                              ),
                                            ),
                                            Text(
                                              'CA\$ ${widget.item.newTotal}'
                                              // mergePriceTxt(widget.item.newTotal!)
                                              // widget.item.tip == "0"
                                              //     ? 'CA\$ ${widget.item.total} '
                                              //     : 'CA\$ ${widget.item.grandTotal}'
                                              ,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: blackColor,
                                              ),
                                            ),
                                          ])
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : SizedBox(),

                  // (getHistoryStatus(widget.item.status) == "Cancelled")
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: RateNowWidget(),
                  //       )
                  //     : SizedBox(),

                  //Rating Given by Customer ---->>> Driver

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.item.ratingList!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.item.ratingList![index].type == 1
                                ? Text(
                                    appLoc.ratingGiven,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'poPPinMedium',
                                        color: grey7D7979Color),
                                  )
                                : Text(
                                    appLoc.ratingReceived,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'poPPinMedium',
                                        color: grey7D7979Color),
                                  ),
                            RatingWidget(
                              ratingDate: "Date",
                              rating: double.parse(
                                  widget.item.ratingList![index].rating),
                              review: widget.item.ratingList![index].review,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
