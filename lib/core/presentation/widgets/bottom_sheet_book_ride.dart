import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/payment_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:GetsbyRideshare/socket/test_socket_provider.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/new_order_page.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/order_data_detail.dart';
import '../../static/enums.dart';
import '../../utility/helper.dart';
import '../../utility/injection.dart';
import '../providers/vehicle_category_state.dart';
import 'custom_button/custom_button_widget.dart';
import 'custom_vehicle_info.dart';

class BottomSheetBookRide extends StatelessWidget {
  const BottomSheetBookRide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.sizeOf(context);

    return StreamBuilder<VehiclesCategoryState>(
        stream: context.read<HomeProvider>().fetchVehicleCategory(),
        builder: (context, state) {
          switch (state.data.runtimeType) {
            case VehiclesCategoryLoading:
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child:
                      LottieBuilder.asset('assets/icons/lottie_animation.json'),
                ),

                // Center(child: CircularProgressIndicator()),
              );
            case VehiclesCategoryLoaded:
              final data = (state.data as VehiclesCategoryLoaded).data;
              return Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: Scaffold(
                  backgroundColor: whiteColor,
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
                                        log("on tap on vehicle called");
                                        provider.updatePriceAndCatagortId(
                                            fare: data[index]
                                                .totalFare
                                                .toString(),
                                            catagoryId: data[index]
                                                .categoryId
                                                .toString());

                                        provider.updateSelectedVehicleIndex(
                                            index: index);
                                        provider.updateIsAvailable(
                                            val: data[index].isAvailable);
                                      },
                                      child: CustomVehicleInfo(
                                        index: index,
                                        vehicleImage:
                                            "${provider.carsImageList[index]}",
                                        // time: "${provider.estimatedTimeToShow}",
                                        time: data[index]
                                                .estimatedTime
                                                .toString() +
                                            " min",
                                        priceMin:
                                            data[index].priceMin.toString(),
                                        baseFare:
                                            data[index].base_fare.toString(),
                                        techFee:
                                            data[index].tech_fee.toString(),
                                        pricePerMin:
                                            data[index].price_min.toString(),
                                        pricePerKM:
                                            data[index].price_km.toString(),
                                        // price: data[index].totalFare.toString(),
                                        price: data[index].totalFare.toString(),
                                        vehicleType: data[index].categoryCar,
                                        capacity: data[index].seat.toString(),
                                        provider: provider,
                                        vehicleDetail:
                                            provider.vehiclesDetailsList,
                                        newTotal:
                                            data[index].newTotal.toString(),
                                        pendingAmount: data[index]
                                            .pendingAmount
                                            .toString(),
                                        isAvailable: data[index].isAvailable,
                                        estimatedDistance: data[index]
                                            .estimatedDistance
                                            .toString(),
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
                                                                .creditCard
                                                        ? SvgPicture.asset(
                                                            'assets/icons/mastercard.svg')
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
                                                  : provider.paymentMethod! ==
                                                          PaymentMethod.cash
                                                      ? "Cash"
                                                      : provider.paymentMethod! ==
                                                              PaymentMethod
                                                                  .creditCard
                                                          ? "CreditCard"
                                                          : provider.paymentMethod! ==
                                                                  PaymentMethod
                                                                      .googlePay
                                                              ? "Google Pay"
                                                              : provider.paymentMethod! ==
                                                                      PaymentMethod
                                                                          .applePay
                                                                  ? "Apple Pay"
                                                                  : "Select Payment",
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

                                    //***  --------->>>>>>> BOOK NOW BUTTON <<<<<<<<<-------------**\
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
                                        var session = locator<Session>();
                                        session.setSearchingTime = 180;
                                        var socketProvider =
                                            locator<TestSocketProvider>();
                                        if (provider.paymentMethod != null) {
                                          if (provider.price.isEmpty ||
                                              provider
                                                  .selectedVehicleId.isEmpty) {
                                            showToast(
                                                message:
                                                    appLoc.taxiTypeNotSelected);
                                          } else if ((provider.isAvailable ==
                                                  '') ||
                                              provider.isAvailable == 'no') {
                                            showToast(
                                                message:
                                                    "Selected vehicle is not available yet, Please select another");
                                          } else {
                                            final OrderDataDetail
                                                orderDataDetail = OrderDataDetail(
                                                    originLatLng:
                                                        provider.originLatLng,
                                                    destinationLatLng: provider
                                                        .destinationLatLng,
                                                    originAddress:
                                                        provider.originAddress,
                                                    destinationAddress: provider
                                                        .destinationAddress);
                                            /*** NEW RIDE REQUEST SEND VIA SOCKET */
                                            socketProvider
                                                .createRideRequest(
                                              originLatLng:
                                                  "${provider.originLatLng.latitude},${provider.originLatLng.longitude}",
                                              destinationLatLng:
                                                  "${provider.destinationLatLng.latitude},${provider.destinationLatLng.longitude}",
                                              vehicleCatagory:
                                                  provider.selectedVehicleId,
                                              startAddress:
                                                  provider.originAddress,
                                              endAddress:
                                                  provider.destinationAddress,
                                              estimatedTime: data[0]
                                                  .estimatedTime
                                                  .toString(),
                                              distance: data[0]
                                                  .estimatedDistance
                                                  .toString(),
                                              total: provider.price,
                                              payment_method: provider
                                                          .paymentMethod! ==
                                                      PaymentMethod.cash
                                                  ? 1
                                                  : provider.paymentMethod! ==
                                                          PaymentMethod
                                                              .creditCard
                                                      ? 2
                                                      : provider.paymentMethod! ==
                                                              PaymentMethod
                                                                  .googlePay
                                                          ? 3
                                                          : provider.paymentMethod! ==
                                                                  PaymentMethod
                                                                      .applePay
                                                              ? 4
                                                              : 1,
                                            )
                                                .then((value) {
                                              if (value) {
                                                var session =
                                                    locator<Session>();
                                                session.setOrderStatus = 0;
                                                session.setIsRunningOrder =
                                                    true;
                                                session.setBookingTime =
                                                    DateTime.now().toString();

                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        NewOrderPage.routeName,
                                                        (route) => false,
                                                        arguments:
                                                            orderDataDetail);
                                              } else {
                                                showToast(
                                                    message:
                                                        "Something went wrong Please try again");
                                              }
                                            });
                                          }

                                          log(provider.originAddress
                                              .toString());
                                          log(provider.destinationAddress
                                              .toString());
                                          log(provider.distance.toString());
                                          log(provider.price.toString());
                                        } else {
                                          showToast(
                                              message:
                                                  "Please Select Payment Method");
                                        }
                                        ;
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
  }
}
