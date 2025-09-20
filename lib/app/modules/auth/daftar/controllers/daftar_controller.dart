import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:payoo/app/data/models/auth_model.dart';
import 'package:payoo/config/utils/storage_manager.dart';
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

	// Validation error messages (only shown after submit attempt)
	var nameError = ''.obs;
	var emailError = ''.obs;
	var phoneError = ''.obs;
	var passwordError = ''.obs;
	var passwordConfirmError = ''.obs;
	var hasAttemptedSubmit = false.obs;

	bool validateForm() {
		hasAttemptedSubmit.value = true;
		nameError.value = '';
		emailError.value = '';
		phoneError.value = '';
		passwordError.value = '';
		passwordConfirmError.value = '';
		
		bool isValid = true;
		
		// Validate name
		final nameText = name.text.trim();
		if (nameText.isEmpty) {
			nameError.value = 'Nama pemilik tidak boleh kosong';
			isValid = false;
		} else if (nameText.length < 2) {
			nameError.value = 'Nama pemilik minimal 2 karakter';
			isValid = false;
		}
		
		// Validate email
		final emailText = email.text.trim();
		if (emailText.isEmpty) {
			emailError.value = 'Email tidak boleh kosong';
			isValid = false;
		} else if (!GetUtils.isEmail(emailText)) {
			emailError.value = 'Format email tidak valid';
			isValid = false;
		}
		
		// Validate phone
		final phoneText = phone.text.trim();
		if (phoneText.isEmpty) {
			phoneError.value = 'Nomor ponsel tidak boleh kosong';
			isValid = false;
		} else if (!GetUtils.isPhoneNumber(phoneText)) {
			phoneError.value = 'Format nomor ponsel tidak valid';
			isValid = false;
		}
		
		// Validate password
		final passwordText = password.text.trim();
		if (passwordText.isEmpty) {
			passwordError.value = 'Kata sandi tidak boleh kosong';
			isValid = false;
		} else if (passwordText.length < 6) {
			passwordError.value = 'Kata sandi minimal 6 karakter';
			isValid = false;
		}
		
		// Validate password confirmation
		final passwordConfirmText = passwordConfirm.text.trim();
		if (passwordConfirmText.isEmpty) {
			passwordConfirmError.value = 'Konfirmasi kata sandi tidak boleh kosong';
			isValid = false;
		} else if (passwordText != passwordConfirmText) {
			passwordConfirmError.value = 'Konfirmasi kata sandi tidak sama';
			isValid = false;
		}
		
		return isValid;
	}

	Future<void> register() async {
		// Validate form before making API call
		if (!validateForm()) {
			return;
		}

		errorMessage.value = '';
		registerSuccess.value = false;

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

	void resetForm() {
		name.clear();
		email.clear();
		phone.clear();
		password.clear();
		passwordConfirm.clear();
		status.value = ApiCallStatus.holding;
		errorMessage.value = '';
		apiResponse.value = null;
		registerSuccess.value = false;
		// Reset validation errors
		nameError.value = '';
		emailError.value = '';
		phoneError.value = '';
		passwordError.value = '';
		passwordConfirmError.value = '';
		hasAttemptedSubmit.value = false;
	}
}
