import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

class CurrentLocationWidget extends StatelessWidget {
  const CurrentLocationWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, map, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: FloatingActionButton(
              child: const Icon(Icons.my_location_rounded,
                  color: Colors.grey, size: 35),
              backgroundColor: Colors.white,
              onPressed: () async {
                await map.getCurrentLocation();
              },
            ),
          ),
        ],
      );
    });
  }
}
