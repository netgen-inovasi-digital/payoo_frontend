import 'package:get/get.dart';

import '../controllers/pemulihan_controller.dart';

class PemulihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PemulihanController>(() => PemulihanController());
  }
}
