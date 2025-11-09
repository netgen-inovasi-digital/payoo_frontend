import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/kategori/controllers/kategori_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart' show ApiResponse;
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:payoo/config/utils/storage_manager.dart';

class ProdukController extends GetxController {
  // Text controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaModalController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController satuanController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  // State list
  var linkImage = ''.obs;
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

  var selectedKategoriId = ''.obs;
  var selectedKomposisi = <Komposisi>[].obs;

  /// Sets the selected category ID for the product
  void setKategori(String kategoriId) {
    selectedKategoriId.value = kategoriId;
  }

  /// Sets the selected komposisi list for the product
  void setKomposisi(List<Komposisi> komposisi) {
    selectedKomposisi.value = komposisi;
  }

  /// Clears the selected kategori
  void clearKategori() {
    selectedKategoriId.value = '';
  }

  /// Clears the selected komposisi
  void clearKomposisi() {
    selectedKomposisi.clear();
    update(['komposisi_info']);
  }

  /// Adds a single komposisi to the list
  void addKomposisi(Komposisi komposisi) {
    if (!selectedKomposisi.any((item) => item.id == komposisi.id)) {
      selectedKomposisi.add(komposisi);
      update(['komposisi_info']);
    }
  }

  /// Removes a komposisi from the list
  void removeKomposisi(Komposisi komposisi) {
    selectedKomposisi.removeWhere((item) => item.id == komposisi.id);
    update(['komposisi_info']);
  }

  /// Gets the selected kategori name
  String getSelectedKategoriName() {
    if (selectedKategoriId.value.isEmpty) return '';

    final kategoriController = Get.find<KategoriController>();
    final kategori = kategoriController.list.firstWhereOrNull(
        (kat) => kat.id.toString() == selectedKategoriId.value);

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
      errorCreate.value =
          'Harga jual harus berupa angka yang valid dan lebih dari 0';
      return false;
    }

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
          list.assignAll(parsed.result ?? []);
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
    final url =
        '${Constants.baseUrl}${Constants.PRODUCT_BY_ID.replaceAll('{id}', id.toString())}';

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

    if (!validateProdukData()) {
      statusCreate.value = ApiCallStatus.error;
      return false;
    }

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
      'photo': linkImage.value,
      'category_id': categoryId,
      'compositions': selectedKomposisi
          .map((c) => {
                'composition_id': c.id,
                'quantity': (c.quantity ?? 1),
              }).toList(),
      'stock': int.tryParse(stokController.text.trim()) ?? 0,
    };

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
            // PERBAIKAN: Parse compositions dari response POST
            // Response POST mengembalikan pivot table dengan composition_id
            final createdProduct = parsed.data!;
            
            // Convert pivot compositions back to Komposisi objects
            if (createdProduct.compositions != null) {
              final convertedCompositions = <Komposisi>[];
              
              for (var comp in createdProduct.compositions!) {
                // Cari komposisi asli dari selectedKomposisi berdasarkan composition_id
                // Karena response hanya ada composition_name, cost_price, selling_price, unit
                // kita buat Komposisi baru dari data response
                convertedCompositions.add(Komposisi(
                  id: comp.compositionId ?? comp.id, // Gunakan composition_id bukan pivot id
                  namaKomposisi: comp.namaKomposisi,
                  hargaModal: double.tryParse(comp.hargaModal.toString()) ?? 0,
                  hargaJual: double.tryParse(comp.hargaJual.toString()) ?? 0,
                  satuan: comp.satuan ?? '',
                  quantity: comp.quantity,
                ));
              }
              
              // Update produk dengan komposisi yang sudah dikonversi
              createdProduct.compositions = convertedCompositions;
            }
            
            list.insert(0, createdProduct);
          }
          
          statusCreate.value = ApiCallStatus.success;
          success = true;
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
    final url = Constants.baseUrl +
        Constants.PRODUCT_BY_ID.replaceAll('{id}', id.toString());
    final token = StorageManager().read<String>('token');

    if (!validateProdukData()) {
      statusUpdate.value = ApiCallStatus.error;
      return false;
    }

    final categoryId = int.tryParse(selectedKategoriId.value);
    if (categoryId == null) {
      errorUpdate.value = 'Invalid category selected';
      statusUpdate.value = ApiCallStatus.error;
      return false;
    }

    // PERBAIKAN: Gunakan composition_id yang benar, bukan pivot id
    final compositionsPayload = selectedKomposisi.map((c) {
      // Pastikan menggunakan ID komposisi asli, bukan ID pivot
      return {
        'composition_id': c.id, // Ini harus ID komposisi (37), bukan ID pivot (31)
        'quantity': (c.quantity ?? 1),
      };
    }).toList();

    final payload = {
      'name': namaController.text.trim(),
      'cost_price': int.tryParse(hargaModalController.text.trim()) ?? 0,
      'selling_price': int.tryParse(hargaJualController.text.trim()) ?? 0,
      'description': 'lorem50adasdadsssssssssssssss',
      'photo': linkImage.value == '' || linkImage.value.isEmpty
          ? produk.value?.photo ?? ''
          : linkImage.value,
      'category_id': categoryId,
      'compositions': compositionsPayload,
      'stock': int.tryParse(stokController.text.trim()) ?? 0,
    };

    print('Update payload compositions: $compositionsPayload'); // Debug log

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
            final index = list.indexWhere((p) => p.id == id);
            if (index != -1) {
              list[index] = parsed.data!;
            }
            produk.value = parsed.data!;
          }
          
          statusUpdate.value = ApiCallStatus.success;
          success = true;
        } catch (e) {
          errorUpdate.value = 'Error parsing response: $e';
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
      errorUpdate.value = 'Request timeout';
    }

    return success;
  }

  Future<bool> deleteProduk(int id) async {
    statusDelete.value = ApiCallStatus.loading;
    errorDelete.value = '';
    final url = Constants.baseUrl +
        Constants.PRODUCT_BY_ID.replaceAll('{id}', id.toString());
    final token = StorageManager().read<String>('token');
    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.delete,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      onSuccess: (response) {
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
    stokController.clear();
    produk.value = null;
    selectedKategoriId.value = '';
    selectedKomposisi.clear();
    linkImage.value = '';
    statusCreate.value = ApiCallStatus.holding;
    errorCreate.value = '';
    statusUpdate.value = ApiCallStatus.holding;
    errorUpdate.value = '';
    update(['komposisi_info']);
  }

  void resetData() {
    list.clear();
    statusList.value = ApiCallStatus.empty;
    errorList.value = '';
  }
  
  @override
  void onClose() {
    namaController.dispose();
    hargaModalController.dispose();
    hargaJualController.dispose();
    satuanController.dispose();
    stokController.dispose();
    linkImage.value = '';
    produk.value = null;
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    super.onClose();
  }

  void setFormFromProduk(Produk produk) {
    namaController.text = produk.name;
    hargaModalController.text = produk.costPrice.toString();
    hargaJualController.text = produk.sellingPrice.toString();
    selectedKategoriId.value = produk.kategori.id.toString();
    
    // PERBAIKAN: Pastikan menggunakan composition_id yang benar
    if (produk.compositions != null) {
      selectedKomposisi.value = produk.compositions!.map((comp) {
        // Jika comp.compositionId ada, gunakan itu (untuk data dari API)
        // Jika tidak, gunakan comp.id (untuk data lokal)
        return Komposisi(
          id: comp.compositionId ?? comp.id,
          namaKomposisi: comp.namaKomposisi,
          hargaModal: double.tryParse(comp.hargaModal.toString()) ?? 0,
          hargaJual: double.tryParse(comp.hargaJual.toString()) ?? 0,
          satuan: comp.satuan ?? '',
          quantity: comp.quantity,
        );
      }).toList();
    }
    
    stokController.text = produk.stock.toString();
    update(['komposisi_info']);
  }

  // Add this method to safely show snackbars
  void showSnackbar(String title, String message, {bool isError = false}) {
    // Cancel any existing snackbar first
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    
    // Wait a frame before showing new snackbar
    Future.delayed(Duration.zero, () {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: isError ? Colors.red : Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    });
  }
  
  
}