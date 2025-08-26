import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/utils/constant.dart';
import 'package:payoo/app/data/models/auth_model.dart';
import 'package:payoo/utils/storage_manager.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';

class DaftarController extends GetxController {
	// Text field controllers
	final TextEditingController name = TextEditingController();
	final TextEditingController email = TextEditingController();
	final TextEditingController phone = TextEditingController();
	final TextEditingController password = TextEditingController();
	final TextEditingController passwordConfirm = TextEditingController();

	// State
	var status = ApiCallStatus.holding.obs;
	var errorMessage = ''.obs;
	var apiResponse = Rxn<ApiResponse<AuthData>>();
	var registerSuccess = false.obs; // tetap untuk logic view lama jika diperlukan

	Future<void> register() async {
		errorMessage.value = '';
		registerSuccess.value = false;

		if (password.text.trim() != passwordConfirm.text.trim()) {
			errorMessage.value = 'Konfirmasi kata sandi tidak sama';
			return;
		}

		status.value = ApiCallStatus.loading;
		final payload = {
			'name': name.text.trim(),
			'email': email.text.trim(),
			'phone': phone.text.trim(),
			'password': password.text.trim(),
			'password_confirmation': passwordConfirm.text.trim(),
		};

		const url = Constants.baseUrl + Constants.AUTH_REGISTER;

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
					registerSuccess.value = parsed.isSuccess;
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
			status.value = ApiCallStatus.error; // fallback safety
		}
	}

	@override
	void onClose() {
		name.dispose();
		email.dispose();
		phone.dispose();
		password.dispose();
		passwordConfirm.dispose();
		super.onClose();
	}
}
