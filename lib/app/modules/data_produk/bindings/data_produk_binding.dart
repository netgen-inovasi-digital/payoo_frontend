import 'package:get/get.dart';

import '../controllers/data_produk_controller.dart';

class DataProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataProdukController>(() => DataProdukController());
  }
}
