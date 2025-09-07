import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/kategori/controllers/kategori_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart' show ApiResponse;
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/utils/constant.dart';
import 'package:payoo/utils/storage_manager.dart';

class ProdukController extends GetxController {
	// Text controllers
	final TextEditingController namaController = TextEditingController();
	final TextEditingController hargaModalController = TextEditingController();
	final TextEditingController hargaJualController = TextEditingController();
	final TextEditingController satuanController = TextEditingController();
	
	// State list
	var statusList = ApiCallStatus.holding.obs;
	var list = <Produk>[].obs;
  var listCompositions = <Komposisi>[].obs;
	var errorList = ''.obs;
  var statusProdukById = ApiCallStatus.holding.obs;
	var produk = Rx<Produk?>(null);
	// State create
	var statusCreate = ApiCallStatus.holding.obs;
	var errorCreate = ''.obs;

	// State update
	var statusUpdate = ApiCallStatus.holding.obs;
	var errorUpdate = ''.obs;

	// State delete
	var statusDelete = ApiCallStatus.holding.obs;
	var errorDelete = ''.obs;

  

	@override
	void onInit() {
		fetchProduk();
    
		super.onInit();
	}


var selectedKategoriId = ''.obs;
  var selectedKomposisi = <Komposisi>[].obs;
  
  // ... your existing text controllers and other variables ...

  /// Sets the selected category ID for the product
  void setKategori(String kategoriId) {
    selectedKategoriId.value = kategoriId;
    
    // Optional: You can also store the category name if needed
    // You might want to get the category details from KategoriController
    update(); // Trigger UI update if using GetBuilder
  }

  /// Sets the selected komposisi list for the product
  void setKomposisi(List<Komposisi> komposisi) {
    selectedKomposisi.value = komposisi;
    update(); // Trigger UI update if using GetBuilder
  }

  /// Clears the selected kategori
  void clearKategori() {
    selectedKategoriId.value = '';
    update();
  }

  /// Clears the selected komposisi
  void clearKomposisi() {
    selectedKomposisi.clear();
    update();
  }

  /// Adds a single komposisi to the list
  void addKomposisi(Komposisi komposisi) {
    if (!selectedKomposisi.any((item) => item.id == komposisi.id)) {
      selectedKomposisi.add(komposisi);
      update();
    }
  }

  /// Removes a komposisi from the list
  void removeKomposisi(Komposisi komposisi) {
    selectedKomposisi.removeWhere((item) => item.id == komposisi.id);
    update();
  }

  /// Gets the selected kategori name (if you need it for display)
  String getSelectedKategoriName() {
    if (selectedKategoriId.value.isEmpty) return '';
    
    // Assuming you have access to KategoriController
    final kategoriController = Get.find<KategoriController>();
    final kategori = kategoriController.list.firstWhereOrNull(
      (kat) => kat.id.toString() == selectedKategoriId.value
    );
    
    return kategori?.name ?? '';
  }

  /// Validates if all required fields are filled
  bool validateProdukData() {
    if (namaController.text.trim().isEmpty) {
      errorCreate.value = 'Nama produk harus diisi';
      return false;
    }
    
    if (selectedKategoriId.value.isEmpty) {
      errorCreate.value = 'Kategori produk harus dipilih';
      return false;
    }
    
    if (hargaJualController.text.trim().isEmpty) {
      errorCreate.value = 'Harga jual harus diisi';
      return false;
    }
    
    final hargaJual = double.tryParse(hargaJualController.text.trim());
    if (hargaJual == null || hargaJual <= 0) {
      errorCreate.value = 'Harga jual harus berupa angka yang valid dan lebih dari 0';
      return false;
    }
    
    // Validate modal price if provided
    if (hargaModalController.text.trim().isNotEmpty) {
      final hargaModal = double.tryParse(hargaModalController.text.trim());
      if (hargaModal == null || hargaModal < 0) {
        errorCreate.value = 'Harga modal harus berupa angka yang valid';
        return false;
      }
    }
    
    return true;
  }

	Future<void> fetchProduk() async {
		statusList.value = ApiCallStatus.loading;
		errorList.value = '';
		const url = Constants.baseUrl + Constants.PRODUCTS;

		final storage = StorageManager();
		final token = storage.read<String>('token');
		await BaseClient.safeApiCall(
			url,
			RequestType.get,
			headers: token != null ? {'Authorization': 'Bearer $token'} : null,
			onSuccess: (response) {
				try {
					final parsed = ApiResponse<Produk>.fromJson(
						response.data,
						(json) => Produk.fromJson(json),
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


  	Future<void> fetchProdukCompositions(int id) async {
		statusList.value = ApiCallStatus.loading;
		errorList.value = '';
		const url = Constants.baseUrl + Constants.PRODUCT_COMPOSITION;
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
						listCompositions.assignAll(parsed.result ?? []); 
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

  	Future<void> fetchProdukById(int id) async {
		statusProdukById.value = ApiCallStatus.loading;
		errorList.value = '';
		final url = '${Constants.baseUrl}${Constants.PRODUCT_BY_ID.replaceAll('{id}', id.toString())}';

		final storage = StorageManager();
		final token = storage.read<String>('token');
		await BaseClient.safeApiCall(
			url,
			RequestType.get,
			headers: token != null ? {'Authorization': 'Bearer $token'} : null,
			onSuccess: (response) {
				try {
					final parsed = ApiResponse<Produk>.fromJson(
						response.data,
						(json) => Produk.fromJson(json),
					);
					produk.value = parsed.data;
					statusProdukById.value = ApiCallStatus.success;
				} catch (e) {
					errorList.value = 'Parsing error';
					statusProdukById.value = ApiCallStatus.error;
				}
			},
			onError: (e) {
				errorList.value = e.toString();
				statusProdukById.value = ApiCallStatus.error;
			},
		);
		if (statusProdukById.value == ApiCallStatus.loading) {
			statusProdukById.value = ApiCallStatus.error;
		}
	}
Future<bool> createProduk() async {
	statusCreate.value = ApiCallStatus.loading;
	errorCreate.value = '';
	const url = Constants.baseUrl + Constants.PRODUCTS;
	final token = StorageManager().read<String>('token');
	
	// Validate input using the validation method
	if (!validateProdukData()) {
		statusCreate.value = ApiCallStatus.error;
		return false;
	}

	// Parse category_id to integer
	final categoryId = int.tryParse(selectedKategoriId.value);
	if (categoryId == null) {
		errorCreate.value = 'Invalid category selected';
		statusCreate.value = ApiCallStatus.error;
		return false;
	}

	final payload = {
		'name': namaController.text.trim(),
		'cost_price': int.tryParse(hargaModalController.text.trim()) ?? 0,
		'selling_price': int.tryParse(hargaJualController.text.trim()) ?? 0,
		'description': 'lorem50adasdadsssssssssssssss',
		'photo': 'https://tse2.mm.bing.net/th/id/OIP.qlRWrzScM0SKLdvMOzZtiAAAAA?pid=ImgDet&w=290&h=280&rs=1&o=7&rm=3',
		'category_id': categoryId, // Now properly converted to integer
		'compositions': selectedKomposisi.map((c) => c.id).toList(), // Use selectedKomposisi instead of listCompositions
	};
	
	// Debug print to check the payload
	print('Creating product with payload: $payload');
	
	bool success = false;
	await BaseClient.safeApiCall(
		url,
		RequestType.post,
		headers: token != null ? {'Authorization': 'Bearer $token'} : null,
		data: payload,
		onSuccess: (response) {
			try {
				final parsed = ApiResponse<Produk>.fromJson(
					response.data,
					(json) => Produk.fromJson(json),
				);
				if (parsed.data != null) {
					list.insert(0, parsed.data!);
				}
				statusCreate.value = ApiCallStatus.success;
				success = true;
				
				// Reset form after success
				resetCreateForm();
			} catch (e) {
				errorCreate.value = 'Error parsing response: $e';
				statusCreate.value = ApiCallStatus.error;
				print('Parsing error: $e');
			}
		},
		onError: (e) {
			errorCreate.value = e.toString();
			statusCreate.value = ApiCallStatus.error;
			print('API Error: $e');
		},
	);
	
	if (statusCreate.value == ApiCallStatus.loading) {
		statusCreate.value = ApiCallStatus.error;
		errorCreate.value = 'Request timeout';
	}
	
	return success;
}

	Future<bool> updateProduk(int id) async {
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
					final parsed = ApiResponse<Produk>.fromJson(
						response.data,
						(json) => Produk.fromJson(json),
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

	Future<bool> deleteProduk(int id) async {
		statusDelete.value = ApiCallStatus.loading;
		errorDelete.value = '';
		final url = Constants.baseUrl + Constants.PRODUCT_BY_ID.replaceAll('{id}', id.toString());
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
	
	// Clear the new fields
	selectedKategoriId.value = '';
	selectedKomposisi.clear();
	
	// Reset status
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
