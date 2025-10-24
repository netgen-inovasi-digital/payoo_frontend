import 'package:get/get.dart';

import '../controllers/pembelian_controller.dart';

class PembelianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PembelianController>(() => PembelianController());
  }
}
