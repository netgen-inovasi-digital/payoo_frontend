import 'package:get/get.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/toko/controllers/toko_controller.dart';

enum LoadingStatus {
  initial,
  loading,
  success,
  error,
}

class DashboardController extends GetxController {
  final AkunController userController = Get.put<AkunController>(AkunController());
  final TokoController tokoController = Get.put<TokoController>(TokoController());
  
  final Rx<LoadingStatus> status = Rx<LoadingStatus>(LoadingStatus.initial);
  final RxString errorMessage = RxString('');
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
    @override
  void onReady() {
    super.onReady();
    // This will be called when the page is shown
    loadData();
  }
  
  Future<void> loadData() async {
    try {
      status.value = LoadingStatus.loading;
      
      // Wait for user data to be available (with a timeout)
      int attempts = 0;
      const maxAttempts = 10; // Maximum number of attempts
      const delaySeconds = 1; // Delay between attempts in seconds
      
      while (userController.user.value == null && attempts < maxAttempts) {
        await Future.delayed(const Duration(seconds: delaySeconds));
        attempts++;
      }
      
      if (userController.user.value != null) {
        await tokoController.fetchTokoById(userController.user.value!.shopId);
        status.value = LoadingStatus.success;
      } else {
        status.value = LoadingStatus.error;
        errorMessage.value = 'User data not available after waiting';
      }
    } catch (e) {
      status.value = LoadingStatus.error;
      errorMessage.value = e.toString();
    }
  }
  
  Future<void> refreshData() async {
    // Check if we're already loading data
    if (status.value == LoadingStatus.loading) {
      return; // Already loading, don't trigger again
    }
    
    // Use microtask to ensure this doesn't happen during build
    await Future.microtask(() async {
      try {
        status.value = LoadingStatus.loading;
        
        // Add your data loading logic here
        await Future.delayed(const Duration(milliseconds: 100)); // Small delay
        
        // Load your toko data
        await tokoController.fetchToko();
        
        // Load user data if needed
        await userController.fetchUser();
        
        // Load any other data you need
        
        status.value = LoadingStatus.success;
      } catch (e) {
        status.value = LoadingStatus.error;
        errorMessage.value = e.toString();
      }
    });
  }
}
