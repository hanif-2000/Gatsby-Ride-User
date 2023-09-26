import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';

class CarDetailWidget extends StatelessWidget {
  final String baseFare;
  final String techFee;
  final String perkM;
  final String perMin;
  final String carImg;
  final String carSeat;
  final String minimumFare;
  final String estimatedPrice;

  const CarDetailWidget(
      {Key? key,
      required this.baseFare,
      required this.perMin,
      required this.perkM,
      required this.carImg,
      required this.carSeat,
      required this.minimumFare,
      required this.estimatedPrice,
      required this.techFee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
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
                      "Minimum Fare",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Base Fare",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Tech Fee",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Extra Per Km Fee ",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Extra Per min Fee",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
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
                      "CA \$ ${minimumFare}",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${baseFare}",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${techFee}",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${perkM}",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CA \$ ${perMin}",
                      style: TextStyle(color: greyC8C7CCColor, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Estimated Price: CA\$ ${estimatedPrice}",
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
