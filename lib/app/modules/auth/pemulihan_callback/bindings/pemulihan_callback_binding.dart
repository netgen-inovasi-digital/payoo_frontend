import 'package:get/get.dart';
import '../controllers/pemulihan_callback_controller.dart';

class PemulihanCallbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PemulihanCallbackController>(
        () => PemulihanCallbackController());
  }
}
