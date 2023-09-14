import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';

class CustomVehicleInfo extends StatelessWidget {
  final String? vehicleImage;
  final String? vehicleType;
  final String? time;
  final String? price;
  final String? capacity;
  final VoidCallback? onTap;
  final int? index;
  final HomeProvider provider;

  const CustomVehicleInfo({
    Key? key,
    this.vehicleImage,
    this.vehicleType,
    this.time,
    this.price,
    this.capacity,
    this.onTap,
    this.index,
    required this.provider,
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
                              'assets/icons/car_seat.png',
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

              //Price
              Row(
                children: [
                  Image.asset(
                    'assets/icons/cad_crncy.png',
                    height: 40,
                    width: 40,
                  ),
                  Text(
                    price!,
                    style: const TextStyle(
                        fontFamily: 'poPPinRegular',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
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
}
