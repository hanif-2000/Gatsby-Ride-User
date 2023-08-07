import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/history/presentation/providers/history_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                DateFormat('dMMM yyyy, h:mma')
                                    .format(widget.item.orderTime)
                                    .toString(),
                                maxLines: 1,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (getHistoryStatus(widget.item.status) ==
                                          "Cancelled")
                                      ? SvgPicture.asset(
                                          'assets/icons/red_dot.svg')
                                      : SvgPicture.asset(
                                          'assets/icons/green_dot.svg'),
                                  const SizedBox(
                                    width: 10.0,
                                  ),

                                  AutoSizeText(
                                    getHistoryStatus(widget.item.status),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: (getHistoryStatus(
                                                  widget.item.status) ==
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
                      //given camera position
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          provider.originLat,
                          provider.originLang,
                        ),
                        zoom: 15,
                      ),
                      // on below line we have given map type
                      mapType: MapType.normal,
                      // specified set of markers below
                      markers: provider.markers,
                      // on below line we have enabled location
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      // on below line we have enabled compass location
                      compassEnabled: true,
                      // on below line we have added polylines
                      polylines: provider.polyline,
                      // displayed google map
                      onMapCreated: (GoogleMapController controller) {
                        provider.controller.complete(controller);
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
                                      driverId: widget.item.driverId,
                                    ),
                                  ),
                                );
                              },
                              category: widget.item.category.category,
                              driverId: widget.item.driverId,
                              driverImage: widget.item.image == ''
                                  ? ''
                                  : widget.item.image,
                              driverName: widget.item.driverName,
                              platerNumber: widget.item.plateNumber,
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
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Flexible(
                                            child: Text(
                                              widget.item.startAddress,
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
                                                  fontSize: 18),
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Flexible(
                                            child: Text(
                                              widget.item.endAddress,
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
                  Padding(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      widget.item.paymentMethod == "1"
                                          ? SvgPicture.asset(
                                              'assets/icons/cash.svg',
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.fill,
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/google.svg',
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.fill,
                                            ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        child: Text(
                                          widget.item.paymentMethod == "1"
                                              ? "Cash"
                                              : "Google Pay",
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
                            //           fontSize: 18),
                            //     ),
                            //     smallVerticalSpacing(),
                            //     Text(
                            //       getPaymentMethod(widget.item),
                            //     ),
                            //     mediumVerticalSpacing(),
                            //   ],
                            // ),

                            ),
                      )),

                  //Show Price Details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      height: 200,
                      color: whiteColor,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: constraints.maxHeight * 0.65,
                                  decoration: const BoxDecoration(
                                    color: whiteColor,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: secondaryColor, width: 0.3)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Distance
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(appLoc.distance,
                                              style: const TextStyle(
                                                  fontFamily: 'poPPinSemiBold',
                                                  fontSize: 16)),
                                          Text(
                                            mergeDistanceTxt(
                                              widget.item.distance,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "poPPinMedium",
                                            ),
                                          )
                                        ],
                                      ),

                                      //Type of Taxi/Cab Type
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Cab Type",
                                              style: TextStyle(
                                                  fontFamily: 'poPPinSemiBold',
                                                  fontSize: 16)),
                                          Text(
                                            mergeTypeTaxi(
                                              widget.item.category,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "poPPinMedium",
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(appLoc.price,
                                              style: const TextStyle(
                                                  fontFamily: 'poPPinSemiBold',
                                                  fontSize: 16)),
                                          Text(
                                            mergePriceTxt(widget.item.total),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "poPPinMedium",
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
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
                                          fontSize: 18,
                                          color: blackColor,
                                        ),
                                      ),
                                      Text(
                                        mergePriceTxt(widget.item.total),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
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
                  ),

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
                      itemCount: widget.item.ratingList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.item.ratingList[index].type == 1
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
                                  widget.item.ratingList[index].rating),
                              review: widget.item.ratingList[index].review,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Text(
                  //   appLoc.ratingGiven,
                  //   style: TextStyle(
                  //       fontSize: 16.0,
                  //       fontFamily: 'poPPinMedium',
                  //       color: grey7D7979Color),
                  // ),

                  // RatingWidget(
                  //   ratingDate: "Date",
                  //   rating: 5.0,
                  //   review: "sdf",
                  // ),
                  // SizedBox(
                  //   height: 10.0,
                  // ),

                  // //Rating Given by Driver  ---->>>> customer
                  // Text(
                  //   appLoc.ratingReceived,
                  //   style: TextStyle(
                  //       fontSize: 16.0,
                  //       fontFamily: 'poPPinMedium',
                  //       color: grey7D7979Color),
                  // ),

                  // RatingWidget(
                  //   ratingDate: "Date",
                  //   rating: 5.0,
                  //   review: "sdf",
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
