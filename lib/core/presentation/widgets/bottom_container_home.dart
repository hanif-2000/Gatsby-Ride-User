import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/button_request_taxi_widget.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/distance_price_widget.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/payment_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomContainerHome extends StatelessWidget {
  const BottomContainerHome({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 290,
            color: const Color.fromRGBO(0, 0, 0, 0.2),
            child: ListView(
              children: const [
                //Show Different vehicles options
                // CategoryCarWidget(),

                //Show distance and price of ride
                DistancePriceWidget(),

                // Show Payment Option
                PaymentOption(),

                //Call Taxi Button
                ButtonRequestTaxi()
              ],
            ),
          ),
        ],
      );
    });
  }
}
