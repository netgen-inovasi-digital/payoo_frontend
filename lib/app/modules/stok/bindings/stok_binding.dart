import 'package:get/get.dart';
import '../controllers/stok_controller.dart';

class StokBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StokController>(() => StokController());
  }
}