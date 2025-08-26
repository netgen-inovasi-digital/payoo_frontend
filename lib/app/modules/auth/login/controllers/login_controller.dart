import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/config/api/base_client.dart';
import 'package:payoo/config/api/api.dart';
import 'package:payoo/app/data/models/auth_model.dart';
import 'package:payoo/utils/storage_manager.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var authResponse = Rxn<AuthResponse>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    final payload = {
      'email': email,
      'password': password,
    };
    const url = Constants.baseUrl + Constants.AUTH_LOGIN;
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      data: payload,
      onSuccess: (response) {
        try {
          final result = AuthResponse.fromJson(response.data);
          authResponse.value = result;
          StorageManager().save('token', result.data.token);
        } catch (e) {
          errorMessage.value = 'Parsing error';
        }
        isLoading.value = false;
      },
      onError: (error) {
        errorMessage.value = error.toString();
        isLoading.value = false;
      },
    );
  }
}
