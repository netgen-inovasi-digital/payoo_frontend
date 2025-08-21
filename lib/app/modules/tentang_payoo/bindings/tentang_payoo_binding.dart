import 'package:get/get.dart';

import '../controllers/tentang_payoo_controller.dart';

class TentangPayooBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TentangPayooController>(() => TentangPayooController());
  }
}
