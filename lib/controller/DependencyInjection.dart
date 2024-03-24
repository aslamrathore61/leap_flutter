import 'package:get/get.dart';
import 'package:leap_flutter/controller/NetworkController.dart';

class DependencyInjection {

  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent: true);
  }
}