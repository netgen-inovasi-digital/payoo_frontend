import 'package:get/get.dart';

import '../controllers/akun_controller.dart';

class AkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AkunController>(() => AkunController());
  }
}
