import 'package:get/get.dart';

import '../controllers/struk_controller.dart';

class StrukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StrukController>(() => StrukController());
  }
}
