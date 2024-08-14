import 'dart:convert';
import 'dart:developer';

import 'package:GetsbyRideshare/core/utility/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart' as permission;

import '../data/models/point_latlng_model.dart';

class DirectionHelper {
  final client = http.Client();
  final googleApiKey = GOOGLEMAPKEY;

  Future<List<PointLatLng>> getRouteBetweenCoordinates(
      double originLat,
      double originLong,
      double destLat,
      double destLong) async {
    List<PointLatLng> polylinePoints = [];
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLong&destination=$destLat,$destLong&mode=driving&avoid=tolls&key=$googleApiKey";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse["routes"] != null && jsonResponse["routes"].isNotEmpty) {
         return polylinePoints = decodeEncodedPolyline(jsonResponse["routes"][0]["overview_polyline"]["points"]);
        } else {
          return [];
        }
      } else {
        log("Error fetching directions: ${response.statusCode}");
        throw Exception("Failed to fetch directions: ${response.statusCode}");
      }
    } catch (error) {
      log("Error: $error");
      throw Exception("An error occurred: $error");
    }

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

  static Future<LatLng?> getCurrentLocation() async {
    try {
      final permissionStatus = await _getLocationPermissionStatus();
      if (permissionStatus) {
        var location = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return LatLng(location.latitude, location.longitude);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> _getLocationPermissionStatus() async {
    try {
      var permissionStatus = await permission.Permission.location.request();
      if (permissionStatus == permission.PermissionStatus.granted) {
        return true;
      } else if (permissionStatus == permission.PermissionStatus.denied) {
        return false;
      } else if (permissionStatus ==
          permission.PermissionStatus.permanentlyDenied) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
