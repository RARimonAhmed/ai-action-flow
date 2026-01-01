import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future get isConnected;
  Stream get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  @override
  Stream get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((results) {
      return results.first != ConnectivityResult.none;
    });
  }
}