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
      errorMessage.value = '';
      
      print('=== Starting refreshData ===');
      
      // Fetch user data first
      await userController.fetchUser();
      
      
      // Check if user fetch failed due to 401
      if (userController.status.value == ApiCallStatus.error) {
        // Check if it's a token issue (401)
        final userError = userController.error.value.toLowerCase();
        if (userError.contains('401') || 
            userError.contains('unauthorized') || 
            userError.contains('token')) {
          status.value = ApiCallStatus.error;
          errorStatusCode.value = 401;
          errorMessage.value = 'Session expired. Please login again.';
          
          // Redirect to login
          Get.offAllNamed('/login');
          return;
        }
        
        status.value = ApiCallStatus.error;
        errorStatusCode.value = 500;
        errorMessage.value = userController.error.value;
        return;
      }
      
      if (userController.user.value != null) {
        final shopId = userController.user.value!.shopId;
        
        print('=== ShopId from user: $shopId ===');
        
        // Always try to fetch data, even if shopId is 0
        // The API will return empty/default data for new accounts
        try {
          await Future.wait([
            if (shopId > 0) tokoController.fetchTokoById(shopId),
            fetchShopData(),
          ]);
          
          print('=== After fetch - Toko name: ${tokoController.toko.value?.name} ===');
        } catch (e) {
          print('Error fetching dashboard data: $e');
          // Don't fail, just continue with empty data
        }
      
        // Check if any of the fetches failed with 401
        if (statusDashboardData.value == ApiCallStatus.error && 
            errorStatusCode.value == 401) {
          errorMessage.value = 'Session expired. Please login again.';
          Get.offAllNamed('/login');
          return;
        }
        
        status.value = ApiCallStatus.success;
        errorMessage.value = '';
      } else {
        status.value = ApiCallStatus.error;
        errorStatusCode.value = 500; // Changed from 400 to 500
        errorMessage.value = 'Failed to load user data';
      }
    } catch (e) {
      status.value = ApiCallStatus.error;
      errorMessage.value = e.toString();
      errorStatusCode.value = 500;
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
            final parsed = ApiResponse<DashboardData>.fromJson(
              response.data,
              (json) => DashboardData.fromJson(json),
            );
            
            dashboardData.value = parsed.data;
            statusDashboardData.value = ApiCallStatus.success;
            errorStatusCode.value = 0;
          } catch (e) {
            print('Dashboard parsing error: $e');
            // For new accounts, data might be null or empty - this is ok
            dashboardData.value = null;
            statusDashboardData.value = ApiCallStatus.success;
            errorStatusCode.value = 0;
          }
        },
        onError: (e) {
          print('Dashboard fetch error: ${e.toString()}');
          errorDashboardData.value = e.toString();
          
          // If 404 or 422, it might be a new account without shop yet
          // This is normal for newly registered users
          if (e.statusCode == 404 || e.statusCode == 422) {
            print('Dashboard: New account without shop (422/404), setting empty data');
            dashboardData.value = null;
            statusDashboardData.value = ApiCallStatus.success;
            errorStatusCode.value = 0;
          } else {
            statusDashboardData.value = ApiCallStatus.error;
            errorStatusCode.value = e.statusCode ?? 0;
            
            // If 401, set flag for logout
            if (e.statusCode == 401) {
              errorMessage.value = 'Session expired';
            }
          }
        },
      );
    } catch (e) {
      print('Dashboard exception: $e');
      errorDashboardData.value = e.toString();
      // For unexpected errors in new accounts, still show success with empty data
      dashboardData.value = null;
      statusDashboardData.value = ApiCallStatus.success;
      errorStatusCode.value = 0;
    }
  }
}