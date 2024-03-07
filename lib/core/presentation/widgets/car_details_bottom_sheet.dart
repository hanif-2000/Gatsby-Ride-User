import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/duration_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarDetailWidget extends StatelessWidget {
  final String baseFare;
  final String techFee;
  final String perkM;
  final String perMin;
  final String carImg;
  final String carSeat;
  final String minimumFare;
  final String estimatedPrice;
  final String pendingAmount;
  final String newTotal;
  final String isAvailable;
  final String estimatedDistance;
  final String estimatedTime;

  const CarDetailWidget(
      {Key? key,
      required this.baseFare,
      required this.perMin,
      required this.perkM,
      required this.carImg,
      required this.carSeat,
      required this.minimumFare,
      required this.estimatedPrice,
      required this.pendingAmount,
      required this.newTotal,
      required this.isAvailable,
      required this.estimatedDistance,
      required this.estimatedTime,
      required this.techFee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: _deviceSize.height * .02),
              child: SvgPicture.asset(
                'assets/icons/grey-dropdown-icon.svg',
              ),
            ),
          ),
          Text(
            isAvailable == 'yes'
                ? "Vehicle is Available"
                : "Vehicle is not Available",
            style: TextStyle(
                color:
                    isAvailable == 'yes' ? green2DAA5FColor : redf52d56Color),
          ),
          Image.asset(
            carImg ?? "assets/icons/economy_car.png",
            height: 200,
            width: 200,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/car-seat.png',
                  height: 15,
                  width: 15,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(carSeat ?? "4"),
                SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 3.0,
                    width: 5.0,
                    color: grey7D7979Color,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Image.asset(
                  'assets/icons/luggage.png',
                  height: 15,
                  width: 15,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("2"),
              ],
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Fare Breakdown",
                style: TextStyle(fontSize: 22.0),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Estimated Distance",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Estimated Time",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Minimum Fare",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Base Fare",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Tech Fee",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Extra Per Km Fee ",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Extra Per min Fee",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Pending payment",
                      style: TextStyle(
                          color: black080808Color,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Current Ride Estimate",
                      style: TextStyle(
                          color: black080808Color,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${estimatedDistance} km",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      estimatedTime,
                      // formatDuration(double.parse(
                      //         ((int.parse(estimatedTime)) * 60).toString())
                      //     .toInt()),
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${minimumFare}",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${baseFare}",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${techFee}",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${perkM}",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${perMin}",
                      style: TextStyle(color: black080808Color, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${pendingAmount}",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${estimatedPrice}",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Total Price: CA\$ ${newTotal}",
              style: TextStyle(color: black282828Color, fontSize: 18.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Some of the fares are estimated and may vary based on ride and other conditions"),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
