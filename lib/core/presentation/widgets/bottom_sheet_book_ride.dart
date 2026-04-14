import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/providers/create_order_state.dart';
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
import 'custom_button/custom_button_widget.dart';
import 'custom_vehicle_info.dart';

class BottomSheetBookRide extends StatelessWidget {
  const BottomSheetBookRide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.sizeOf(context);

    // ✅ FIX: Consumer use kar rahe hain StreamBuilder ki jagah
    // Data pehle se loaded hai home_provider mein via _fetchVehicleCategoryWithActualValues()
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        final data = homeProvider.vehicleCategory;
        final provider = homeProvider;

        // Loading state - jab tak data nahi aata
        if (data.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: LottieBuilder.asset('assets/icons/lottie_animation.json'),
            ),
          );
        }

        // ✅ Data loaded with actual distance/time values
        log("=== VEHICLES DATA LENGTH: ${data.length} ===");
        for (var i = 0; i < data.length; i++) {
          log("Vehicle $i: ${data[i].categoryCar}");
        }

        return Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: Scaffold(
            backgroundColor: whiteColor,
            body: Container(
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
                            padding: EdgeInsets.symmetric(horizontal: 0.0),
                            child: InkWell(
                              onTap: () {
                                log("on tap on vehicle called");
                                log("Vehicle Name: ${data[index].categoryCar}");
                                provider.updatePriceAndCatagortId(
                                    fare: data[index].totalFare.toString(),
                                    catagoryId: data[index].categoryId.toString());
                                provider.updateSelectedVehicleIndex(index: index);
                                provider.updateIsAvailable(val: data[index].isAvailable);
                              },
                              child: CustomVehicleInfo(
                                index: index,
                                vehicleImage: "${provider.carsImageList[index]}",
                                time: data[index].estimatedTime.toString() + " min",
                                priceMin: data[index].priceMin.toString(),
                                baseFare: data[index].base_fare.toString(),
                                techFee: data[index].tech_fee.toString(),
                                pricePerMin: data[index].price_min.toString(),
                                pricePerKM: data[index].price_km.toString(),
                                price: data[index].totalFare.toString(),
                                vehicleType: data[index].categoryCar,
                                capacity: data[index].seat.toString(),
                                provider: provider,
                                vehicleDetail: provider.vehiclesDetailsList,
                                newTotal: data[index].newTotal.toString(),
                                pendingAmount: data[index].pendingAmount.toString(),
                                isAvailable: data[index].isAvailable,
                                estimatedDistance: data[index].estimatedDistance.toString(),
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
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                          right: _deviceSize.width * .05,
                                        ),
                                        child: provider.paymentMethod == null
                                            ? SvgPicture.asset('assets/icons/cash.svg')
                                            : provider.paymentMethod == PaymentMethod.creditCard
                                                ? SvgPicture.asset('assets/icons/mastercard.svg')
                                                : provider.paymentMethod == PaymentMethod.applePay
                                                    ? SvgPicture.asset('assets/icons/apple.svg')
                                                    : provider.paymentMethod == PaymentMethod.googlePay
                                                        ? SvgPicture.asset('assets/icons/google.svg')
                                                        : SvgPicture.asset('assets/icons/cash.svg')),
                                    Text(
                                      provider.paymentMethod == null
                                          ? "Select Payment"
                                          : provider.paymentMethod! == PaymentMethod.cash
                                              ? "Cash"
                                              : provider.paymentMethod! == PaymentMethod.creditCard
                                                  ? "CreditCard"
                                                  : provider.paymentMethod! == PaymentMethod.googlePay
                                                      ? "Google Pay"
                                                      : provider.paymentMethod! == PaymentMethod.applePay
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
                                final session = locator<Session>();
                                session.setSearchingTime = 180;
                                final socketProvider = context.read<TestSocketProvider>();
                                if (provider.paymentMethod != null) {
                                  if (provider.price.isEmpty || provider.selectedVehicleId.isEmpty) {
                                    showToast(message: appLoc.taxiTypeNotSelected);
                                  } else if ((provider.isAvailable == '') || provider.isAvailable == 'no') {
                                    showToast(message: "Selected vehicle is not available yet, Please select another");
                                  } else {
                                    final orderDataDetail = OrderDataDetail(
                                        originLatLng: provider.originLatLng,
                                        destinationLatLng: provider.destinationLatLng,
                                        originAddress: provider.originAddress,
                                        destinationAddress: provider.destinationAddress);
                                    showLoading();
                                    provider.submitOrder().listen((event) async {
                                      if (event is CreateOrderLoading) {
                                        // loading already shown
                                      } else if (event is CreateOrderLoaded) {
                                        final int paymentMethodInt = provider.paymentMethod! == PaymentMethod.cash
                                            ? 1
                                            : provider.paymentMethod! == PaymentMethod.creditCard
                                                ? 2
                                                : provider.paymentMethod! == PaymentMethod.googlePay
                                                    ? 3
                                                    : 4;
                                        final String paymentMethodStr = provider.paymentMethod! == PaymentMethod.cash
                                            ? "cash"
                                            : "card";
                                        final String estTime = data[provider.selectedVehicleIndex].estimatedTime.toString();
                                        final String estDistance = data[provider.selectedVehicleIndex].estimatedDistance.toString();
                                        // Save booking data to session for "Search Again"
                                        session.setOriginLat = provider.originLatLng.latitude;
                                        session.setOriginLong = provider.originLatLng.longitude;
                                        session.setDestinationLat = provider.destinationLatLng.latitude;
                                        session.setDestinationLong = provider.destinationLatLng.longitude;
                                        session.setOriginAddress = provider.originAddress;
                                        session.setDestinationAddress = provider.destinationAddress;
                                        session.setBookingVehicleCategoryId = provider.selectedVehicleId;
                                        session.setBookingPaymentMethod = paymentMethodInt;
                                        session.setEstimatedTime = estTime;
                                        session.setEstimatedDistance = estDistance;
                                        final serverTotal = event.data.total.toStringAsFixed(2);
                                        session.setRideTotal = serverTotal;
                                        // Fire-and-forget socket request with server's actual total (after surge)
                                        socketProvider.createRideRequest(
                                          originLatLngs: "${provider.originLatLng.latitude},${provider.originLatLng.longitude}",
                                          destinationLatLngs: "${provider.destinationLatLng.latitude},${provider.destinationLatLng.longitude}",
                                          vehicleCatagory: provider.selectedVehicleId,
                                          startAddress: provider.originAddress,
                                          endAddress: provider.destinationAddress,
                                          estimatedTime: estTime,
                                          distance: estDistance,
                                          total: serverTotal,
                                          payment_method: paymentMethodStr,
                                        );
                                        dismissLoading();
                                        session.setIsRunningOrder = true;
                                        session.setBookingTime = DateTime.now().toString();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, NewOrderPage.routeName, (route) => false,
                                            arguments: orderDataDetail);
                                      } else if (event is CreateOrderFailure) {
                                        dismissLoading();
                                        showToast(message: "Something went wrong Please try again");
                                      }
                                    });
                                  }
                                  log(provider.originAddress.toString(), name: "ORIGIN ADDRESS");
                                  log(provider.destinationAddress.toString(), name: "DESTINATION ADDRESS");
                                  log(provider.distance.toString(), name: "TOTAL DISTANCE");
                                  log(provider.price.toString(), name: "TOTAL ESTIMATED PRICE");
                                } else {
                                  showToast(message: "Please Select Payment Method");
                                }
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
            ),
          ),
        );
      },
    );
  }
}