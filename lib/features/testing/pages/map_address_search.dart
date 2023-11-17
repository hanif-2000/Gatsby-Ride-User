import 'package:flutter/material.dart';

class MapAddressSearch extends StatefulWidget {
  @override
  State<MapAddressSearch> createState() => _MapAddressSearchState();
}

class _MapAddressSearchState extends State<MapAddressSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Text('PLAY QUEUE'),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text('CLEAR'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    //  Center(
    //   child: Container(

    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Icon(
    //             Icons.location_on_outlined,
    //             color: whiteColor,
    //           ),
    //           Icon(
    //             Icons.my_location_outlined,
    //             color: whiteColor,
    //           ),
    //         ],
    //       )),
    // );
  }
}
