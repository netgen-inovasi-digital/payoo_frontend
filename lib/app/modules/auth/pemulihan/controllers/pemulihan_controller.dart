import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/auth_model.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/config/utils/constant.dart';

class PemulihanController extends GetxController {
  var statusForgot = ApiCallStatus.holding.obs;
  var errorForgot = ''.obs;
  var statusVerify = ApiCallStatus.holding.obs;
  var errorVerify = ''.obs;
  var statusReset = ApiCallStatus.holding.obs;
  var errorReset = ''.obs;
  final forgetPasswordController = TextEditingController(); // ini email wkwkw
  final verifyOtpController = TextEditingController();

  @override
  void onClose() {
    forgetPasswordController.dispose();
    verifyOtpController.dispose();
    super.onClose();
  }

  Future<bool> forgotPassword() async {
    statusForgot.value = ApiCallStatus.loading;
    errorForgot.value = '';

    const url = Constants.baseUrl + Constants.ACCOUNT_FORGOT_PASSWORD;
    final payload = {
      'email': forgetPasswordController.text,
    };

    bool success = false;

    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      data: payload,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<ForgetPasswordModel>.fromJson(
            response.data,
            (json) => ForgetPasswordModel.fromJson(json),
          );

          if (parsed.data != null) {}

          statusForgot.value = ApiCallStatus.success;
          success = true;
        } catch (e) {
          errorForgot.value = 'Parsing error: $e';
          statusForgot.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        errorForgot.value = e.toString();
        statusForgot.value = ApiCallStatus.error;
      },
    );

    if (statusForgot.value == ApiCallStatus.loading) {
      statusForgot.value = ApiCallStatus.error;
      errorForgot.value = 'Update request timeout';
    }

    return success;
  }

  Future<bool> verifyForgotPassword(String email, String otp) async {
    statusVerify.value = ApiCallStatus.loading;
    errorVerify.value = '';

    const url = Constants.baseUrl + Constants.ACCOUNT_FORGOT_PASSWORD_VERIFY;
    final payload = {
      'email': email,
      'otp': otp,
    };

    bool success = false;

    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      data: payload,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<ForgetPasswordVerify>.fromJson(
            response.data,
            (json) => ForgetPasswordVerify.fromJson(json),
          );

          if (parsed.data != null) {}

          statusVerify.value = ApiCallStatus.success;
          success = true;
        } catch (e) {
          errorVerify.value = 'Parsing error: $e';
          statusVerify.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        errorVerify.value = e.toString();
        statusVerify.value = ApiCallStatus.error;
      },
    );

    if (statusVerify.value == ApiCallStatus.loading) {
      statusVerify.value = ApiCallStatus.error;
      errorVerify.value = 'Update request timeout';
    }

    return success;
  }

  resetPassword(String email, String newPassword, String confirmPassword) async {
    statusReset.value = ApiCallStatus.loading;
    errorReset.value = '';

    const url = Constants.baseUrl + Constants.ACCOUNT_RESET_PASSWORD;
    final payload = {
      'email': email,
      'password': newPassword,
      'confirm_password': confirmPassword,
    };

    bool success = false;

    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      data: payload,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<String>.fromJson(
            response.data,
            (json) => json.toString(),
          );

          if (parsed.data != null) {}

          statusReset.value = ApiCallStatus.success;
          success = true;
        } catch (e) {
          errorReset.value = 'Parsing error: $e';
          statusReset.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        errorReset.value = e.toString();
        statusReset.value = ApiCallStatus.error;
      },
    );

    if (statusReset.value == ApiCallStatus.loading) {
      statusReset.value = ApiCallStatus.error;
      errorReset.value = 'Update request timeout';
    }

    return success;
  }
}
