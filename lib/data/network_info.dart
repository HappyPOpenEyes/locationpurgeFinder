import 'package:internet_connection_checker/internet_connection_checker.dart';
//import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
  // bool get isConnected;
}

class NetworkInfoImplementer implements NetworkInfo{
  InternetConnectionChecker _internetConnectionChecker;
  NetworkInfoImplementer(this._internetConnectionChecker);

  @override
  // bool get isConnected => true;
  Future<bool> get isConnected =>  _internetConnectionChecker.hasConnection;
}
