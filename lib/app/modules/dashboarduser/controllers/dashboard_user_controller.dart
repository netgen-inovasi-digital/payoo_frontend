import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/user_model.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/utils/storage_manager.dart';
import '../../../../utils/constant.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class DashboardUserController extends GetxController {
  // State for user
  var status = ApiCallStatus.holding.obs;
  var user = Rx<User?>(null);
  var error = ''.obs;
  
  // State update
  var statusUpdate = ApiCallStatus.holding.obs;
  var errorUpdate = ''.obs;
  
  // Text controllers - initialize immediately
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    fetchUser();
    super.onInit();
  }

  Future<void> fetchUser() async {
    status.value = ApiCallStatus.loading;
    error.value = '';
    const url = Constants.baseUrl + Constants.ACCOUNT_PROFILE;
   
    final storage = StorageManager();
    final token = storage.read<String>('token');
    
    await BaseClient.safeApiCall(
      url,
      RequestType.get,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<User>.fromJson(
            response.data,
            (json) => User.fromJson(json),
          );
          user.value = parsed.data;
          
          // Populate controllers with fetched data
          if (user.value != null) {
            namaController.text = user.value!.name;
            emailController.text = user.value!.email;
            phoneController.text = user.value!.phone;
          }
          
          status.value = ApiCallStatus.success;
        } catch (e) {
          error.value = 'Parsing error: $e';
          status.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        error.value = e.toString();
        status.value = ApiCallStatus.error;
      },
    );
    
    if (status.value == ApiCallStatus.loading) {
      status.value = ApiCallStatus.error;
      error.value = 'Request timeout';
    }
  }

  Future<bool> updateUser() async {
    if (user.value == null) {
      errorUpdate.value = 'No user data available';
      return false;
    }
   
    statusUpdate.value = ApiCallStatus.loading;
    errorUpdate.value = '';
    
    final url = Constants.baseUrl + Constants.ACCOUNT_PROFILE;
    final token = StorageManager().read<String>('token');
    
    final payload = {
      'name': namaController.text,
      'email': emailController.text,
      'phone': phoneController.text,
    };

    bool success = false;
    
    await BaseClient.safeApiCall(
      url,
      RequestType.put,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      data: payload,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<User>.fromJson(
            response.data,
            (json) => User.fromJson(json),
          );
          
          if (parsed.data != null) {
            user.value = parsed.data;
            // Update controllers with the latest data from server
            namaController.text = parsed.data!.name ?? '';
            emailController.text = parsed.data!.email ?? '';
            phoneController.text = parsed.data!.phone ?? '';
          }
          
          statusUpdate.value = ApiCallStatus.success;
          success = true;
        } catch (e) {
          errorUpdate.value = 'Parsing error: $e';
          statusUpdate.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        errorUpdate.value = e.toString();
        statusUpdate.value = ApiCallStatus.error;
      },
    );
    
    if (statusUpdate.value == ApiCallStatus.loading) {
      statusUpdate.value = ApiCallStatus.error;
      errorUpdate.value = 'Update request timeout';
    }
    
    return success;
  }

  void resetForm() {
    statusUpdate.value = ApiCallStatus.holding;
    errorUpdate.value = '';
  }

  void resetToOriginalValues() {
    if (user.value != null) {
      namaController.text = user.value!.name ?? '';
      emailController.text = user.value!.email ?? '';
      phoneController.text = user.value!.phone ?? '';
    }
    resetForm();
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}