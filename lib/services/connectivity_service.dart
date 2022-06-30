import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService{

  Future<bool>isConnectInternet()async{
    return _isConnectInternet(await Connectivity().checkConnectivity());
  }

  bool _isConnectInternet(ConnectivityResult result){
    return result==ConnectivityResult.mobile||result==ConnectivityResult.wifi;
  }
}