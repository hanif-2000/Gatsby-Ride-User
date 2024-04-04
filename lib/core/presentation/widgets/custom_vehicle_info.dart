import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';

import 'car_details_bottom_sheet.dart';

class CustomVehicleInfo extends StatelessWidget {
  final String? vehicleImage;
  final String? vehicleType;
  final String? time;
  final String? price;
  final String? newTotal;
  final String? pendingAmount;
  final String? estimatedDistance;
  final String? capacity;
  final String? priceMin;
  final String? techFee;
  final String? baseFare;
  final VoidCallback? onTap;
  final int? index;
  final HomeProvider provider;
  final List vehicleDetail;
  final dynamic isAvailable;

  const CustomVehicleInfo({
    Key? key,
    this.vehicleImage,
    this.vehicleType,
    this.time,
    this.price,
    this.capacity,
    this.onTap,
    this.index,
    this.newTotal,
    this.estimatedDistance,
    this.pendingAmount,
    required this.vehicleDetail,
    required this.provider,
    required this.isAvailable,
    this.priceMin,this.baseFare,this.techFee
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: provider.selectedVehicleIndex == index
            ? yellowE5A829FColor.withOpacity(.15)
            : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceSize.width * .05,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Vehicle Image
              Image.asset(
                vehicleImage!,
                height: 24,
                width: 24,
              ),

              Container(
                width: _deviceSize.width * .55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //Vehicle Type
                        Text(
                          vehicleType!,
                          style: const TextStyle(
                              fontFamily: 'poPPinRegular',
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              color: black080808Color),
                        ),
                        SizedBox(
                          width: _deviceSize.width * .05,
                        ),

                        //Vehicle's capacity
                        Row(
                          children: [
                            Text(" ("),
                            Text(
                              "${capacity!}",
                              style: const TextStyle(
                                  fontFamily: 'poPPinRegular',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: black080808Color),
                            ),
                            Image.asset(
                              'assets/icons/car-seat.png',
                              height: 15,
                              width: 15,
                            ),
                            Text(
                              "   2",
                              style: const TextStyle(
                                  fontFamily: 'poPPinRegular',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: black080808Color),
                            ),
                            Image.asset(
                              'assets/icons/luggage.png',
                              height: 15,
                              width: 15,
                            ),
                            Text(")"),
                          ],
                        ),
                      ],
                    ),

                    //Time
                    Text(
                      time!,
                      style: const TextStyle(
                          fontFamily: 'poPPinRegular',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          color: greyC8C7CCColor),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                  onTap: () {
                    showBottomSheet(
                        estimatedPrice: price,
                        minimumFare: priceMin,
                        context: context,
                        baseFare: baseFare,
                        carImg: provider.vehiclesDetailsList[index!]["carImg"],
                        carSeat: provider.vehiclesDetailsList[index!]["seat"],
                        perkm: provider.vehiclesDetailsList[index!]["perKm"],
                        permin: provider.vehiclesDetailsList[index!]["perMin"],
                        techFee: techFee,
                        newTotal: double.parse(newTotal!).toStringAsFixed(2),
                        pendingAmount: pendingAmount,
                        estimatedTime: time.toString(),
                        estimatedDistance: estimatedDistance.toString(),
                        isAvailable: isAvailable);
                  },
                  child: Icon(Icons.info_outline)),

              //Price
              Row(
                children: [
                  Image.asset(
                    'assets/icons/cad_crncy.png',
                    height: 40,
                    width: 40,
                  ),
                  Text(
                    double.parse(newTotal!).toStringAsFixed(2),
                    style: const TextStyle(
                        fontFamily: 'poPPinRegular',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: black080808Color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showBottomSheet(
      {context,
      carImg,
      carSeat,
      baseFare,
      techFee,
      perkm,
      permin,
      estimatedPrice,
      pendingAmount,
      newTotal,
      isAvailable,
      estimatedDistance,
      estimatedTime,
      minimumFare}) {
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
        return CarDetailWidget(
          estimatedPrice: estimatedPrice,
          carImg: carImg,
          carSeat: carSeat,
          baseFare: baseFare,
          perMin: permin,
          perkM: perkm,
          techFee: techFee,
          minimumFare: minimumFare,
          newTotal: newTotal,
          pendingAmount: pendingAmount,
          isAvailable: isAvailable,
          estimatedDistance: estimatedDistance,
          estimatedTime: estimatedTime,
        );
      },
    );
  }
}
