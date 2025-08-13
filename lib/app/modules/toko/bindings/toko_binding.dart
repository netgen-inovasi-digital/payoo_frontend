import 'package:get/get.dart';

import '../controllers/toko_controller.dart';

class TokoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokoController>(() => TokoController());
  }
}
