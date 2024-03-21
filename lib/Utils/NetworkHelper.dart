import 'package:connectivity_plus/connectivity_plus.dart';

import '../Bloc/networkBloc/network_bloc.dart';
import '../Bloc/networkBloc/network_event.dart';

class NetworkHelper {

  static void observeNetwork() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        NetworkBloc().add(NetworkNotify());
      } else {
        NetworkBloc().add(NetworkNotify(isConnected: true));
      }
    });
  }
}