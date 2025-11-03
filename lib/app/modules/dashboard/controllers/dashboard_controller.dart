import 'package:get/get.dart';
import 'package:payoo/app/data/models/dashboard_model.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/auth/login/controllers/login_controller.dart';
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
  var errorStatusCode = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't call loadData here, let the view call it
  }

  Future<void> refreshData() async {
    try {
      status.value = ApiCallStatus.loading;
      errorStatusCode.value = 0;
      
      // Fetch user data first
      await userController.fetchUser();
      
      // Check if user data is available
      if (userController.user.value != null) {
        // Fetch shop and dashboard data in parallel
        await Future.wait([
          tokoController.fetchTokoById(userController.user.value!.shopId),
          fetchShopData(),
        ]);
        
        status.value = ApiCallStatus.success;
      } else {
        status.value = ApiCallStatus.error;
        errorStatusCode.value = 400;
        errorMessage.value = 'User data not available';
      }
    } catch (e) {
      status.value = ApiCallStatus.error;
      errorMessage.value = e.toString();
      print('Error in refreshData: $e');
    }
  }

  Future<void> fetchShopData() async {
    try {
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
            print('Dashboard API response: ${response.data}');
            
            final parsed = ApiResponse<DashboardData>.fromJson(
              response.data,
              (json) => DashboardData.fromJson(json),
            );
            
            dashboardData.value = parsed.data;
            statusDashboardData.value = ApiCallStatus.success;
            errorStatusCode.value = 0;
          } catch (e) {
            print('Error parsing dashboard data: $e');
            errorDashboardData.value = 'Parsing error: $e';
            statusDashboardData.value = ApiCallStatus.error;
            errorStatusCode.value = 500;
          }
        },
        onError: (e) {
          print('Error fetching dashboard data: $e');
          errorDashboardData.value = e.toString();
          statusDashboardData.value = ApiCallStatus.error;
          errorStatusCode.value = e.statusCode ?? 0;
          
          // If 401, it's a token expiration
          if (e.statusCode == 401) {
            status.value = ApiCallStatus.error;
          }
        },
      );
    } catch (e) {
      print('Exception in fetchShopData: $e');
      errorDashboardData.value = e.toString();
      statusDashboardData.value = ApiCallStatus.error;
      errorStatusCode.value = 500;
    }
  }
}