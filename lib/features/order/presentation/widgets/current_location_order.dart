import 'package:GetsbyRideshare/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentLocationOrderWidget extends StatelessWidget {
  const CurrentLocationOrderWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, provider, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: FloatingActionButton(
              child: const Icon(
                Icons.my_location_rounded,
                color: Colors.grey,
                size: 35,
              ),
              backgroundColor: Colors.white,
              onPressed: () async {
                await provider.moveCameraToDriver();
              },
            ),
          ),
        ],
      );
    });
  }
}
