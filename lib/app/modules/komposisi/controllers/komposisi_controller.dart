import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:payoo/config/utils/storage_manager.dart';

class KomposisiController extends GetxController {
	// State list
	var statusList = ApiCallStatus.holding.obs;
	var list = <Komposisi>[].obs;
	var errorList = ''.obs;

	// State create
	var statusCreate = ApiCallStatus.holding.obs;
	var errorCreate = ''.obs;

	// State update
	var statusUpdate = ApiCallStatus.holding.obs;
	var errorUpdate = ''.obs;

	// State delete
	var statusDelete = ApiCallStatus.holding.obs;
	var errorDelete = ''.obs;

	// Form validation states
	var namaError = ''.obs;
	var hargaModalError = ''.obs;
	var hargaJualError = ''.obs;
	var satuanError = ''.obs;
	var hasAttemptedSubmit = false.obs;

	// Form controllers
	final namaController = TextEditingController();
	final hargaModalController = TextEditingController();
	final hargaJualController = TextEditingController();
	final satuanController = TextEditingController();

	bool validateForm() {
		hasAttemptedSubmit.value = true;
		namaError.value = '';
		hargaModalError.value = '';
		hargaJualError.value = '';
		satuanError.value = '';
		
		bool isValid = true;
		
		// Validate nama komposisi
		final namaText = namaController.text.trim();
		if (namaText.isEmpty) {
			namaError.value = 'Nama komposisi tidak boleh kosong';
			isValid = false;
		} else if (namaText.length < 2) {
			namaError.value = 'Nama komposisi minimal 2 karakter';
			isValid = false;
		} else if (namaText.length > 100) {
			namaError.value = 'Nama komposisi maksimal 100 karakter';
			isValid = false;
		}
		
		// Validate harga modal
		final hargaModalText = hargaModalController.text.trim();
		if (hargaModalText.isEmpty) {
			hargaModalError.value = 'Harga modal tidak boleh kosong';
			isValid = false;
		} else {
			final hargaModal = double.tryParse(hargaModalText);
			if (hargaModal == null) {
				hargaModalError.value = 'Harga modal harus berupa angka';
				isValid = false;
			} else if (hargaModal < 0) {
				hargaModalError.value = 'Harga modal tidak boleh negatif';
				isValid = false;
			} else if (hargaModal > 999999999) {
				hargaModalError.value = 'Harga modal terlalu besar';
				isValid = false;
			}
		}
		
		// Validate harga jual
		final hargaJualText = hargaJualController.text.trim();
		if (hargaJualText.isEmpty) {
			hargaJualError.value = 'Harga jual tidak boleh kosong';
			isValid = false;
		} else {
			final hargaJual = double.tryParse(hargaJualText);
			if (hargaJual == null) {
				hargaJualError.value = 'Harga jual harus berupa angka';
				isValid = false;
			} else if (hargaJual < 0) {
				hargaJualError.value = 'Harga jual tidak boleh negatif';
				isValid = false;
			} else if (hargaJual > 999999999) {
				hargaJualError.value = 'Harga jual terlalu besar';
				isValid = false;
			} else {
				// Check if harga jual >= harga modal
				final hargaModal = double.tryParse(hargaModalController.text.trim());
				if (hargaModal != null && hargaJual < hargaModal) {
					hargaJualError.value = 'Harga jual harus lebih besar atau sama dengan harga modal';
					isValid = false;
				}
			}
		}
		
		// Validate satuan (required and must be one of allowed values)
		final satuanText = satuanController.text.trim();
		if (satuanText.isEmpty) {
			satuanError.value = 'Satuan tidak boleh kosong';
			isValid = false;
		} else {
			final allowedSatuan = ['pcs', 'gr', 'lembar'];
			if (!allowedSatuan.contains(satuanText)) {
				satuanError.value = 'Satuan harus salah satu dari: pcs, gr, atau lembar';
				isValid = false;
			}
		}
		
		return isValid;
	}

	Future<void> fetchKomposisi() async {
		statusList.value = ApiCallStatus.loading;
		errorList.value = '';
		const url = Constants.baseUrl + Constants.COMPOSITIONS;
		
		final storage = StorageManager();
		final token = storage.read<String>('token');
		await BaseClient.safeApiCall(
			url,
			RequestType.get,
			headers: token != null ? {'Authorization': 'Bearer $token'} : null,
			onSuccess: (response) {
				try {
					final parsed = ApiResponse<Komposisi>.fromJson(
						response.data,
						(json) => Komposisi.fromJson(json),
					);
					list.assignAll(parsed.result ?? []); // Backend returns list in result field, handle accordingly
					statusList.value = ApiCallStatus.success;
				} catch (e) {
					errorList.value = 'Parsing error';
					statusList.value = ApiCallStatus.error;
				}
			},
			onError: (e) {
				errorList.value = e.toString();
				statusList.value = ApiCallStatus.error;
			},
		);
		if (statusList.value == ApiCallStatus.loading) {
			statusList.value = ApiCallStatus.error;
		}
	}

	Future<bool> createKomposisi() async {
		// Validate form before making API call
		if (!validateForm()) {
			return false;
		}

		statusCreate.value = ApiCallStatus.loading;
		errorCreate.value = '';
		const url = Constants.baseUrl + Constants.COMPOSITIONS;
		final token = StorageManager().read<String>('token');
		final payload = {
			'name': namaController.text.trim(),
			'cost_price': double.tryParse(hargaModalController.text.trim()) ?? 0,
			'selling_price': double.tryParse(hargaJualController.text.trim()) ?? 0,
			'unit': satuanController.text.trim(),
		};
		bool success = false;
		await BaseClient.safeApiCall(
			url,
			RequestType.post,
			headers: token != null ? {'Authorization': 'Bearer $token'} : null,
			data: payload,
			onSuccess: (response) {
				try {
					final parsed = ApiResponse<Komposisi>.fromJson(
						response.data,
						(json) => Komposisi.fromJson(json),
					);
						if (parsed.data != null) {
							list.insert(0, parsed.data!); // prepend
						}
					statusCreate.value = ApiCallStatus.success;
					success = true;
				} catch (e) {
					errorCreate.value = 'Parsing error';
					statusCreate.value = ApiCallStatus.error;
				}
			},
			onError: (e) {
				errorCreate.value = e.toString();
				statusCreate.value = ApiCallStatus.error;
			},
		);
		if (statusCreate.value == ApiCallStatus.loading) {
			statusCreate.value = ApiCallStatus.error;
		}
		return success;
	}

	Future<bool> updateKomposisi(int id) async {
		// Validate form before making API call
		if (!validateForm()) {
			return false;
		}

		statusUpdate.value = ApiCallStatus.loading;
		errorUpdate.value = '';
		final url = Constants.baseUrl + Constants.COMPOSITION_BY_ID.replaceAll('{id}', id.toString());
		final token = StorageManager().read<String>('token');
		final payload = {
			'name': namaController.text.trim(),
			'cost_price': double.tryParse(hargaModalController.text.trim()) ?? 0,
			'selling_price': double.tryParse(hargaJualController.text.trim()) ?? 0,
			'unit': satuanController.text.trim(),
		};
		bool success = false;
		await BaseClient.safeApiCall(
			url,
			RequestType.put,
			headers: token != null ? {'Authorization': 'Bearer $token'} : null,
			data: payload,
			onSuccess: (response) {
				try {
					final parsed = ApiResponse<Komposisi>.fromJson(
						response.data,
						(json) => Komposisi.fromJson(json),
					);
					if (parsed.data != null) {
						// Update item in list
						final index = list.indexWhere((k) => k.id == id);
						if (index != -1) {
							list[index] = parsed.data!;
						}
					}
					statusUpdate.value = ApiCallStatus.success;
					success = true;
				} catch (e) {
					errorUpdate.value = 'Parsing error';
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
		}
		return success;
	}

	Future<bool> deleteKomposisi(int id) async {
		statusDelete.value = ApiCallStatus.loading;
		errorDelete.value = '';
		final url = Constants.baseUrl + Constants.COMPOSITION_BY_ID.replaceAll('{id}', id.toString());
		final token = StorageManager().read<String>('token');
		bool success = false;
		await BaseClient.safeApiCall(
			url,
			RequestType.delete,
			headers: token != null ? {'Authorization': 'Bearer $token'} : null,
			onSuccess: (response) {
				// Remove from list
				list.removeWhere((k) => k.id == id);
				statusDelete.value = ApiCallStatus.success;
				success = true;
			},
			onError: (e) {
				errorDelete.value = e.toString();
				statusDelete.value = ApiCallStatus.error;
			},
		);
		if (statusDelete.value == ApiCallStatus.loading) {
			statusDelete.value = ApiCallStatus.error;
		}
		return success;
	}

	void resetCreateForm() {
		namaController.clear();
		hargaModalController.clear();
		hargaJualController.clear();
		satuanController.clear();
		statusCreate.value = ApiCallStatus.holding;
		errorCreate.value = '';
		statusUpdate.value = ApiCallStatus.holding;
		errorUpdate.value = '';
		// Reset validation errors
		namaError.value = '';
		hargaModalError.value = '';
		hargaJualError.value = '';
		satuanError.value = '';
		hasAttemptedSubmit.value = false;
	}

	@override
	void onClose() {
		namaController.dispose();
		hargaModalController.dispose();
		hargaJualController.dispose();
		satuanController.dispose();
		super.onClose();
	}
}
