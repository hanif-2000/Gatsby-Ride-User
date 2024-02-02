import 'dart:developer';

import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImplementation implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImplementation(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();

    log("inernet connection result is::-->. ${result.name}");
    switch (result) {
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.none:
        // showNoInternetDialog();

        showToast(message: "No internet available");
        return false;
      case ConnectivityResult.vpn:
        return true;
      case ConnectivityResult.other:
        return false;
      default:
        return false;
    }
  }
}
