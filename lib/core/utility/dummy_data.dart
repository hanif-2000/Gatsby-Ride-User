import 'package:google_maps_flutter/google_maps_flutter.dart';

class DummyData {
  static List<Map<String, dynamic>> dummyCardList = [
    {"cardNumber": "123456", "cardType": "visa"},
  ];

  double lat = 43.6771;
  double lang = 79.6334;

  LatLng latLng = LatLng(43.6771, 79.6334);
}
