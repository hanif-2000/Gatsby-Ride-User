import 'dart:convert';

import 'package:appkey_taxiapp_user/core/utility/app_settings.dart';
import 'package:http/http.dart' as http;

import '../data/models/point_latlng_model.dart';

class DirectionHelper {
  final client = http.Client();
  final googleApiKey = GOOGLEMAPKEY;

  Future<List<PointLatLng>> getRouteBetweenCoordinates(double originLat,
      double originLong, double destLat, double destLong) async {
    List<PointLatLng> polylinePoints = [];
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=" +
            originLat.toString() +
            "," +
            originLong.toString() +
            "&destination=" +
            destLat.toString() +
            "," +
            destLong.toString() +
            "&mode=driving" +
            "&avoid=tolls" +
            "&key=$googleApiKey";

    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        polylinePoints = decodeEncodedPolyline(json
            .decode(response.body)["routes"][0]["overview_polyline"]["points"]);
      }
    } catch (error) {
      throw Exception(error.toString());
    }
    // print(polylinePoints);
    return polylinePoints;
  }

  List<PointLatLng> decodeEncodedPolyline(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      PointLatLng p =
          PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}
