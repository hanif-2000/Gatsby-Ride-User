import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';

class CustomVehicleInfo extends StatelessWidget {
  final String? vehicleImage;
  final String? vehicleType;
  final String? time;
  final String? price;
  final String? capacity;

  const CustomVehicleInfo(
      {Key? key,
      this.vehicleImage,
      this.vehicleType,
      this.time,
      this.price,
      this.capacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              vehicleImage!,
              height: 24,
              width: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vehicleType!,
                      style: const TextStyle(
                          fontFamily: 'poPPinRegular',
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: black080808Color),
                    ),
                    Text(
                      " (${capacity!} Person)",
                      style: const TextStyle(
                          fontFamily: 'poPPinRegular',
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: black080808Color),
                    ),
                  ],
                ),
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
            Text(
              price!,
              style: const TextStyle(
                  fontFamily: 'poPPinRegular',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: black080808Color),
            )
          ],
        ),
      ),
    );
  }
}
