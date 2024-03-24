import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  Connectivity _connectivity = Connectivity();
  Rx<ConnectivityResult> _connectivityResult =
  Rx<ConnectivityResult>(ConnectivityResult.none);

  ConnectivityResult get connectivityStatus => _connectivityResult.value;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _initConnectivity(); // Initialize connectivity status
  }

  void _initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (_connectivityResult.value != connectivityResult) {
      _connectivityResult.value = connectivityResult;
      update(); // Trigger rebuild of dependent widgets

   /*   if (connectivityResult == ConnectivityResult.none) {
        print('NoInternet');
        Get.rawSnackbar(
          messageText: const Text(
            'Please connect to the internet!',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: Colors.red[400]!,
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
        );
      } else {
        print('ConnectedInternet');

        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
      }*/
    }

  }
}
