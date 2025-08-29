import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/utils/constant.dart';
import 'package:payoo/utils/storage_manager.dart';

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

	// Form controllers
	final namaController = TextEditingController();
	final hargaModalController = TextEditingController();
	final hargaJualController = TextEditingController();
	final satuanController = TextEditingController();

	@override
	void onInit() {
		fetchKomposisi();
		super.onInit();
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
