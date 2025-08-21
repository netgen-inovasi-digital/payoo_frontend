import 'package:get/get.dart';

import '../controllers/komposisi_controller.dart';

class KomposisiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KomposisiController>(() => KomposisiController());
  }
}
