import 'package:get/get.dart';
import 'package:payoo/app/data/models/dashboard_model.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/toko/controllers/toko_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:payoo/config/utils/storage_manager.dart';



class DashboardController extends GetxController {
  final AkunController userController = Get.put<AkunController>(AkunController());
  final TokoController tokoController = Get.put<TokoController>(TokoController());
  var statusDashboardData = ApiCallStatus.holding.obs;
  var status = ApiCallStatus.holding.obs;
  var errorDashboardData = ''.obs;
  final RxString errorMessage = RxString('');
  var dashboardData = Rxn<DashboardData?>(null);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    try {
      status.value = ApiCallStatus.loading;
      
      // Wait for user data to be available (with a timeout)
      int attempts = 0;
      const maxAttempts = 10;
      const delaySeconds = 1;
      
      while (userController.user.value == null && attempts < maxAttempts) {
        await Future.delayed(const Duration(seconds: delaySeconds));
        attempts++;
      }
      
      if (userController.user.value != null) {
        // First fetch shop data
        await fetchShopData();
        
        // Then fetch toko data if shop ID is available
        await tokoController.fetchTokoById(userController.user.value!.shopId);
              
        status.value = ApiCallStatus.success;
      } else {
        status.value = ApiCallStatus.error;
        errorMessage.value = 'User data not available after timeout';
      }
    } catch (e) {
      status.value = ApiCallStatus.error;
      errorMessage.value = e.toString();
    }
  }

  Future<void> fetchShopData() async {
    statusDashboardData.value = ApiCallStatus.loading;
    errorDashboardData.value = '';
    const url = Constants.baseUrl + Constants.DASHBOARD;
    final storage = StorageManager();
    final token = storage.read<String>('token');
    await BaseClient.safeApiCall(
      url,
      RequestType.get,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<DashboardData>.fromJson(
            response.data,
            (json) => DashboardData.fromJson(json),
          );
          dashboardData.value = parsed.data;
          statusDashboardData.value = ApiCallStatus.success;
        } catch (e) {
          errorDashboardData.value = 'Parsing error';
          statusDashboardData.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        errorDashboardData.value = e.toString();
        statusDashboardData.value = ApiCallStatus.error;
      },
    );
    if (statusDashboardData.value == ApiCallStatus.loading) {
      statusDashboardData.value = ApiCallStatus.error;
    }
  }

  void refreshData() {
    loadData();
  }
}
