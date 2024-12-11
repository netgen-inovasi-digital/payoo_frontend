import 'package:get/get.dart';

import '../controllers/informasi_toko_controller.dart';

class InformasiTokoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InformasiTokoController>(() => InformasiTokoController());
  }
}
