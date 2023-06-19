import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';

class CustomVehicleInfo extends StatelessWidget {
  final String? vehicleImage;
  final String? vehicleType;
  final String? time;
  final String? price;
  final String? capacity;
  final VoidCallback? onTap;

  const CustomVehicleInfo({
    Key? key,
    this.vehicleImage,
    this.vehicleType,
    this.time,
    this.price,
    this.capacity,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // color: Colors.yellow,
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
                width: _deviceSize.width * .6,
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

                        //Vehicle's capacity
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
        ),
      ),
    );
  }
}
