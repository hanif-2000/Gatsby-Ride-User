import 'dart:developer';
import 'dart:io';

import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get isSlow;
}

class NetworkInfoImplementation implements NetworkInfo {
  final Connectivity connectivity;
  final int slowThreshold = 5000; // Threshold in milliseconds

  NetworkInfoImplementation(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();

    log("Internet connection result is: ${result.first}");
    switch (result.first) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
        return true;
      case ConnectivityResult.none:
        showToast(message: "No internet available");
        return false;
      default:
        return false;
    }
  }

  @override
  Future<bool> get isSlow async {
    try {
      final stopwatch = Stopwatch()..start();
      await InternetAddress.lookup(
          'example.com'); // Replace with a reliable address
      final duration = stopwatch.elapsedMilliseconds;
      return duration > slowThreshold;
    } on SocketException catch (_) {
      return true; // Consider slow if lookup fails
    }
  }
}










// import 'dart:developer';

// import 'package:GetsbyRideshare/core/utility/helper.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// abstract class NetworkInfo {
//   Future<bool> get isConnected;
// }

// class NetworkInfoImplementation implements NetworkInfo {
//   final Connectivity connectivity;

//   NetworkInfoImplementation(this.connectivity);

//   @override
//   Future<bool> get isConnected async {
//     final result = await connectivity.checkConnectivity();

//     log("inernet connection result is::-->. ${result.name}");
//     switch (result) {
//       case ConnectivityResult.bluetooth:
//       case ConnectivityResult.wifi:
//       case ConnectivityResult.ethernet:
//       case ConnectivityResult.mobile:
//         return true;
//       case ConnectivityResult.none:
//         // showNoInternetDialog();

//         showToast(message: "No internet available");
//         return false;
//       case ConnectivityResult.vpn:
//         return true;
//       case ConnectivityResult.other:
//         return false;
//       default:
//         return false;
//     }
//   }
// }
