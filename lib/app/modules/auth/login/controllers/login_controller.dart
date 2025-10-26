import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/app/data/models/auth_model.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:payoo/config/utils/storage_manager.dart';

class LoginController extends GetxController {
  var status = ApiCallStatus.holding.obs;
  var errorMessage = ''.obs;
  var apiResponse = Rxn<ApiResponse<AuthData>>();
  
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var hasAttemptedSubmit = false.obs;
  
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  
  bool validateForm() {
    hasAttemptedSubmit.value = true;
    emailError.value = '';
    passwordError.value = '';
    
    bool isValid = true;
    
    final emailText = email.text.trim();
    if (emailText.isEmpty) {
      emailError.value = 'Email tidak boleh kosong';
      isValid = false;
    } else if (!GetUtils.isEmail(emailText)) {
      emailError.value = 'Format email tidak valid';
      isValid = false;
    }
    
    final passwordText = password.text.trim();
    if (passwordText.isEmpty) {
      passwordError.value = 'Kata sandi tidak boleh kosong';
      isValid = false;
    } else if (passwordText.length < 6) {
      passwordError.value = 'Kata sandi minimal 6 karakter';
      isValid = false;
    }
    
    return isValid;
  }
  
  Future<void> login() async {
    if (!validateForm()) {
      return;
    }
    
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
            final tokenToSave = parsed.data!.token;
            
            // Simpan token dan status login
            StorageManager().save('token', tokenToSave);
            StorageManager().save('isLoggedIn', true);
            
            // Opsional: simpan data user lainnya jika perlu
            if (parsed.data?.user != null) {
              StorageManager().save('userId', parsed.data!.user.id);
              StorageManager().save('userEmail', parsed.data!.user.email);
              // simpan data lain sesuai kebutuhan
            }
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
      status.value = ApiCallStatus.error;
    }
  }
  
  /// Logout user: hapus semua data login
  void logout() {
    // Hapus semua data login
    StorageManager().delete('token');
    StorageManager().delete('isLoggedIn');
    StorageManager().delete('userId');
    StorageManager().delete('userEmail');
    
    // Bersihkan field
    email.clear();
    password.clear();
    
    // Reset status
    status.value = ApiCallStatus.holding;
    errorMessage.value = '';
    apiResponse.value = null;
    
    // Reset validation
    emailError.value = '';
    passwordError.value = '';
    hasAttemptedSubmit.value = false;
  }
  
  void clearForm() {
    email.clear();
    password.clear();
    emailError.value = '';
    passwordError.value = '';
    hasAttemptedSubmit.value = false;
    errorMessage.value = '';
  }
  
  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}