import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/app/data/models/auth_model.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/utils/constant.dart';
import 'package:payoo/utils/storage_manager.dart';

class LoginController extends GetxController {
  var status = ApiCallStatus.holding.obs; // status panggilan API
  var errorMessage = ''.obs;             // pesan error
  var apiResponse = Rxn<ApiResponse<AuthData>>(); // response generic

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> login() async {
    status.value = ApiCallStatus.loading;
    errorMessage.value = '';
    final payload = {
      'email': email.text.trim(),
      'password': password.text.trim(),
    };
    const url = Constants.baseUrl + Constants.AUTH_LOGIN;
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      data: payload,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<AuthData>.fromJson(
            response.data,
            (json) => AuthData.fromJson(json),
          );
          apiResponse.value = parsed;
          if (parsed.data?.token != null) {
            StorageManager().save('token', parsed.data!.token);
          }
          status.value = ApiCallStatus.success;
        } catch (e) {
          errorMessage.value = 'Parsing error';
          status.value = ApiCallStatus.error;
        }
      },
      onError: (error) {
        errorMessage.value = error.toString();
        status.value = ApiCallStatus.error;
      },
    );
    if (status.value == ApiCallStatus.loading) {
      status.value = ApiCallStatus.error; // fallback jika tidak berubah
    }
  }

  /// Logout user: hapus token & reset form tanpa dispose controller
  void logout() {
    // Hapus token
    StorageManager().delete('token');
    // Bersihkan field agar tidak ada data lama
    email.clear();
    password.clear();
    // Reset status ke holding
    status.value = ApiCallStatus.holding;
    errorMessage.value = '';
    apiResponse.value = null;
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
