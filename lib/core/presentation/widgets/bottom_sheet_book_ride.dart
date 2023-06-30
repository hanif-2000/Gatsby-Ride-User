import 'dart:developer';

import 'package:appkey_taxiapp_user/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_vehicle_info.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/payment_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/injection.dart';
import 'package:appkey_taxiapp_user/core/utility/session_helper.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../features/order/presentation/pages/order_page.dart';
import '../../domain/entities/order_data_detail.dart';
import '../../static/enums.dart';
import '../../utility/helper.dart';
import '../providers/create_order_state.dart';
import '../providers/vehicle_category_state.dart';
import 'custom_button/custom_button_widget.dart';

class BottomSheetBookRide extends StatelessWidget {
  const BottomSheetBookRide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;

    return StreamBuilder<VehiclesCategoryState>(
        stream: context.read<HomeProvider>().fetchVehicleCategory(),
        builder: (context, state) {
          switch (state.data.runtimeType) {
            case VehiclesCategoryLoading:
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            case VehiclesCategoryLoaded:
              final data = (state.data as VehiclesCategoryLoaded).data;
              return Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                child: Scaffold(
                  body: Consumer<HomeProvider>(builder: (context, provider, _) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      height: _deviceSize.height * .5,
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: _deviceSize.height * .02),
                                child: SvgPicture.asset(
                                  'assets/icons/grey-dropdown-icon.svg',
                                ),
                              ),
                            ),
                            Container(
                              color: whiteColor,
                              height: _deviceSize.height * .22,
                              child: ListView.builder(
                                itemCount: data.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0.0),
                                    child: InkWell(
                                      onTap: () {
                                        provider.updatePriceAndCatagortId(
                                            fare: data[index]
                                                .totalFare
                                                .toString(),
                                            catagoryId: data[index]
                                                .categoryId
                                                .toString());

                                        log(index.toString());
                                        log(data[index].totalFare.toString());
                                        log(data[index].categoryCar.toString());
                                        log(data[index].seat.toString());
                                        log(data[index].categoryId.toString());

                                        provider.updateSelectedVehicleIndex(
                                            index: index);
                                      },
                                      child: CustomVehicleInfo(
                                        index: index,
                                        vehicleImage:
                                            'assets/icons/car-dropdown.png',
                                        time: "${data[index].time} Min",
                                        price: data[index].totalFare.toString(),
                                        vehicleType: data[index].categoryCar,
                                        capacity: data[index].seat.toString(),
                                        provider: provider,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: _deviceSize.height * .01),
                              child: const DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: greyB6B6B6Color,
                                // dashGradient: const [Colors.red, Colors.blue],
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                // dashGapGradient: const [Colors.red, Colors.blue],
                                dashGapRadius: 0.0,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                provider.setPaymentMethod = PaymentMethod.cash;

                                showModalBottomSheet(
                                  barrierColor: Colors.transparent,
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  // constraints: BoxConstraints(
                                  //     maxHeight: _deviceSize.height * .45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                  ),
                                  backgroundColor: whiteColor,
                                  context: context,
                                  builder: (context) {
                                    return Container(child: PaymentOption());
                                  },
                                );

                                //  selected: provider.paymentMethod == null
                                //           ? false
                                //           : provider.paymentMethod == PaymentMethod.cash
                                //               ? true
                                //               : false,

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const PaymentOption(),
                                //   ),
                                // );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _deviceSize.width * .05),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                  right:
                                                      _deviceSize.width * .05,
                                                ),
                                                child: provider.paymentMethod ==
                                                        null
                                                    ? SvgPicture.asset(
                                                        'assets/icons/cash.svg')
                                                    : provider.paymentMethod ==
                                                            PaymentMethod
                                                                .applePay
                                                        ? SvgPicture.asset(
                                                            'assets/icons/apple.svg')
                                                        : provider.paymentMethod ==
                                                                PaymentMethod
                                                                    .googlePay
                                                            ? SvgPicture.asset(
                                                                'assets/icons/google.svg')
                                                            : SvgPicture.asset(
                                                                'assets/icons/cash.svg')),
                                            Text(
                                              provider.paymentMethod == null
                                                  ? "Select Payment"
                                                  : provider
                                                      .paymentMethod!.name,
                                              style: TextStyle(
                                                fontFamily: 'poPPinMedium',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: _deviceSize.width * .02),
                                          child: SvgPicture.asset(
                                              'assets/icons/grey-disclosure.svg'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: _deviceSize.height * .03,
                                    ),
                                    CustomButton(
                                      text: const Text(
                                        "Book Now",
                                        style: TextStyle(
                                          fontFamily: 'poPPinSemiBold',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      event: () {
                                        if (provider.paymentMethod != null) {
                                          if (provider.price.isEmpty ||
                                              provider
                                                  .selectedVehicleId.isEmpty) {
                                            showToast(
                                                message:
                                                    appLoc.taxiTypeNotSelected);
                                            // showDialog(
                                            //   barrierDismissible: false,
                                            //   context: context,
                                            //   builder: (context) {
                                            //     return CustomSimpleDialog(
                                            //         text: appLoc
                                            //             .taxiTypeNotSelected,
                                            //         onTap: () {
                                            //           Navigator.pop(context);
                                            //         });
                                            //   },
                                            // );
                                          } else {
                                            // Navigator.pop(context);

                                            provider
                                                .submitOrder()
                                                .listen((event) async {
                                              if (event is CreateOrderLoading) {
                                                showLoading();
                                              } else if (event
                                                  is CreateOrderLoaded) {
                                                dismissLoading();
                                                showToast(
                                                    message: appLoc
                                                        .orderCreatedSuccessfully);
                                                final OrderDataDetail
                                                    orderDataDetail = OrderDataDetail(
                                                        originLatLng: provider
                                                            .originLatLng,
                                                        destinationLatLng: provider
                                                            .destinationLatLng,
                                                        originAddress: provider
                                                            .originAddress,
                                                        destinationAddress: provider
                                                            .destinationAddress);

                                                // provider.sendRequest();
                                                var session =
                                                    locator<Session>();
                                                session.setOriginAddress =
                                                    provider.originAddress;
                                                session.setDestinationAddress =
                                                    provider.destinationAddress;
                                                session.setOriginLat = provider
                                                    .originLatLng.latitude;
                                                session.setOriginLong = provider
                                                    .originLatLng.longitude;
                                                session.setDestinationLat =
                                                    provider.destinationLatLng
                                                        .latitude;
                                                session.setDestinationLong =
                                                    provider.destinationLatLng
                                                        .longitude;

                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        OrderPage.routeName,
                                                        (route) => false,
                                                        arguments:
                                                            orderDataDetail);
                                              } else if (event
                                                  is CreateOrderFailure) {
                                                dismissLoading();
                                              }
                                            });
                                          }

                                          log(provider.originAddress
                                              .toString());
                                          log(provider.destinationAddress
                                              .toString());
                                          log(provider.distance.toString());
                                          log(provider.price.toString());

                                          // showModalBottomSheet(
                                          //     isScrollControlled: true,
                                          //     constraints: BoxConstraints(
                                          //         maxHeight:
                                          //             _deviceSize.height * .5),
                                          //     context: context,
                                          //     shape:
                                          //         const RoundedRectangleBorder(
                                          //       borderRadius:
                                          //           BorderRadius.vertical(
                                          //         top: Radius.circular(50.0),
                                          //       ),
                                          //     ),
                                          //     builder: (context) {
                                          //       return SearchingRideBottomSheet();
                                          //     });
                                        } else {
                                          showToast(
                                              message:
                                                  "Please Select Payment Method");
                                        }
                                        // showModalBottomSheet(
                                        //     useRootNavigator: true,
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.vertical(
                                        //         top: Radius.circular(100),
                                        //       ),
                                        //     ),
                                        //     // backgroundColor: ,
                                        //     context: context,
                                        //     builder: (context) {
                                        //       return const SearchingRideBottomSheet();
                                        //     },
                                        //   )

                                        ;
                                        // showBottomSheet(
                                        //   context: context,
                                        //   builder: (context) {
                                        //     return const BottomSheetBookRide();
                                        //   },
                                        // );
                                      },
                                      buttonHeight: 50,
                                      isRounded: true,
                                      bgColor: black080809Color,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
          }
          return const SizedBox.shrink();
        });

    // Scaffold(
    //   body: Consumer<HomeProvider>(builder: (context, provider, _) {
    //     return Container(
    //       decoration: const BoxDecoration(
    //         color: whiteColor,
    //         borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(16.0),
    //           topRight: Radius.circular(16.0),
    //         ),
    //       ),
    //       height: _deviceSize.height * .5,
    //       child: SingleChildScrollView(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             GestureDetector(
    //               onTap: () {
    //                 Navigator.pop(context);
    //               },
    //               child: Padding(
    //                 padding: EdgeInsets.symmetric(
    //                     vertical: _deviceSize.height * .02),
    //                 child: SvgPicture.asset(
    //                   'assets/icons/grey-dropdown-icon.svg',
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               height: _deviceSize.height * .22,
    //               child: ListView.builder(
    //                 itemCount: 6,
    //                 shrinkWrap: true,
    //                 itemBuilder: (context, index) {
    //                   return const Padding(
    //                     padding: EdgeInsets.symmetric(horizontal: 8.0),
    //                     child: CustomVehicleInfo(
    //                       vehicleImage: 'assets/icons/car-dropdown.png',
    //                       time: "2 min",
    //                       price: r'$ 40.00',
    //                       vehicleType: 'Economy',
    //                       capacity: "4",
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //             Padding(
    //               padding:
    //                   EdgeInsets.symmetric(vertical: _deviceSize.height * .01),
    //               child: const DottedLine(
    //                 direction: Axis.horizontal,
    //                 lineLength: double.infinity,
    //                 lineThickness: 1.0,
    //                 dashLength: 4.0,
    //                 dashColor: greyB6B6B6Color,
    //                 // dashGradient: const [Colors.red, Colors.blue],
    //                 dashRadius: 0.0,
    //                 dashGapLength: 4.0,
    //                 dashGapColor: Colors.transparent,
    //                 // dashGapGradient: const [Colors.red, Colors.blue],
    //                 dashGapRadius: 0.0,
    //               ),
    //             ),
    //             InkWell(
    //               onTap: () {
    //                 provider.setPaymentMethod = PaymentMethod.cash;

    //                 //  selected: provider.paymentMethod == null
    //                 //           ? false
    //                 //           : provider.paymentMethod == PaymentMethod.cash
    //                 //               ? true
    //                 //               : false,

    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) => const PaymentOption(),
    //                   ),
    //                 );
    //               },
    //               child: Padding(
    //                 padding: EdgeInsets.symmetric(
    //                     horizontal: _deviceSize.width * .05),
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Row(
    //                           children: [
    //                             Padding(
    //                                 padding: EdgeInsets.only(
    //                                   right: _deviceSize.width * .05,
    //                                 ),
    //                                 child: provider.paymentMethod == null
    //                                     ? SvgPicture.asset(
    //                                         'assets/icons/cash.svg')
    //                                     : provider.paymentMethod ==
    //                                             PaymentMethod.applePay
    //                                         ? SvgPicture.asset(
    //                                             'assets/icons/apple.svg')
    //                                         : provider.paymentMethod ==
    //                                                 PaymentMethod.googlePay
    //                                             ? SvgPicture.asset(
    //                                                 'assets/icons/google.svg')
    //                                             : SvgPicture.asset(
    //                                                 'assets/icons/cash.svg')),
    //                             Text(
    //                               provider.paymentMethod == null
    //                                   ? "Select Payment"
    //                                   : provider.paymentMethod!.name,
    //                               style: TextStyle(
    //                                 fontFamily: 'poPPinMedium',
    //                                 fontSize: 16.0,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.only(
    //                               right: _deviceSize.width * .02),
    //                           child: SvgPicture.asset(
    //                               'assets/icons/grey-disclosure.svg'),
    //                         ),
    //                       ],
    //                     ),
    //                     SizedBox(
    //                       height: _deviceSize.height * .05,
    //                     ),
    //                     CustomButton(
    //                       text: const Text(
    //                         "Book Now",
    //                         style: TextStyle(
    //                           fontFamily: 'poPPinSemiBold',
    //                           fontWeight: FontWeight.w600,
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                       event: () {
    //                         if (provider.paymentMethod != null) {
    //                           Navigator.pop(context);
    //                           showModalBottomSheet(
    //                               isScrollControlled: true,
    //                               constraints: BoxConstraints(
    //                                   maxHeight: _deviceSize.height * .5),
    //                               context: context,
    //                               shape: const RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.vertical(
    //                                   top: Radius.circular(50.0),
    //                                 ),
    //                               ),
    //                               builder: (context) {
    //                                 return SearchingRideBottomSheet();
    //                               });
    //                         } else {
    //                           showToast(
    //                               message: "Please Select Payment Method");
    //                         }
    //                         // showModalBottomSheet(
    //                         //     useRootNavigator: true,
    //                         //     shape: RoundedRectangleBorder(
    //                         //       borderRadius: BorderRadius.vertical(
    //                         //         top: Radius.circular(100),
    //                         //       ),
    //                         //     ),
    //                         //     // backgroundColor: ,
    //                         //     context: context,
    //                         //     builder: (context) {
    //                         //       return const SearchingRideBottomSheet();
    //                         //     },
    //                         //   )

    //                         ;
    //                         // showBottomSheet(
    //                         //   context: context,
    //                         //   builder: (context) {
    //                         //     return const BottomSheetBookRide();
    //                         //   },
    //                         // );
    //                       },
    //                       buttonHeight: 50,
    //                       isRounded: true,
    //                       bgColor: black080809Color,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   }),
    // );
  }
}
