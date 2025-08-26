import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/config/api/base_client.dart';
import 'package:payoo/config/api/api.dart';
import 'package:payoo/app/data/models/auth_model.dart';
import 'package:payoo/utils/storage_manager.dart';

class DaftarController extends GetxController {
	// Text field controllers
	final TextEditingController name = TextEditingController();
	final TextEditingController email = TextEditingController();
	final TextEditingController phone = TextEditingController();
	final TextEditingController password = TextEditingController();
	final TextEditingController passwordConfirm = TextEditingController();

	// State
	var isLoading = false.obs;
	var errorMessage = ''.obs;
	var registerSuccess = false.obs;
	var authResponse = Rxn<AuthResponse>();

	Future<void> register() async {
		errorMessage.value = '';
		registerSuccess.value = false;

		if (password.text.trim() != passwordConfirm.text.trim()) {
			errorMessage.value = 'Konfirmasi kata sandi tidak sama';
			return;
		}

		isLoading.value = true;
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
					// Jika API register langsung mengembalikan struktur sama seperti login
						final result = AuthResponse.fromJson(response.data);
						authResponse.value = result;
						StorageManager().save('token', result.data.token);
				} catch (_) {
					// Jika tidak sesuai, tetap lanjut sebagai success tanpa token parsing
				}
				registerSuccess.value = true;
				isLoading.value = false;
			},
			onError: (error) {
				errorMessage.value = error.toString();
				isLoading.value = false;
			},
		);
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
