import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:payoo/config/utils/storage_manager.dart';

class StokController extends GetxController {
  var status = ApiCallStatus.holding.obs;
  var stok = Rx<Stock?>(null);
  var error = ''.obs;
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController buyPriceController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  // State create
  var statusCreate = ApiCallStatus.holding.obs;
  var errorCreate = ''.obs;

  // State for products with stock
  var statusProductsStock = ApiCallStatus.holding.obs;
  var productsStock = <ProductWithStock>[].obs;
  var errorProductsStock = ''.obs;

  // Pagination states untuk list stok
  var statusListStock = ApiCallStatus.holding.obs;
  var errorListStock = ''.obs;
  var listStock = <Stock>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

  // Form validation states
  var quantityError = ''.obs;
  var dateError = ''.obs;
  var buyPriceError = ''.obs;
  var notesError = ''.obs;
  var hasAttemptedSubmit = false.obs;

  bool validateForm(String type) {
    hasAttemptedSubmit.value = true;
    quantityError.value = '';
    dateError.value = '';
    buyPriceError.value = '';
    notesError.value = '';

    bool isValid = true;

    // Validate quantity
    final quantityText = quantityController.text.trim();
    if (quantityText.isEmpty) {
      quantityError.value = 'Jumlah stok tidak boleh kosong';
      isValid = false;
    } else {
      final quantity = int.tryParse(quantityText);
      if (quantity == null) {
        quantityError.value = 'Jumlah stok harus berupa angka';
        isValid = false;
      } else if (quantity <= 0) {
        quantityError.value = 'Jumlah stok harus lebih dari 0';
        isValid = false;
      } else if (quantity > 999999) {
        quantityError.value = 'Jumlah stok terlalu besar';
        isValid = false;
      }
    }

    // Validate date
    final dateText = dateController.text.trim();
    if (dateText.isEmpty) {
      dateError.value = 'Tanggal tidak boleh kosong';
      isValid = false;
    }

    // Validate buy price only for "in" type
    if (type == 'in') {
      final buyPriceText = buyPriceController.text.trim();
      if (buyPriceText.isEmpty) {
        buyPriceError.value = 'Harga beli tidak boleh kosong';
        isValid = false;
      } else {
        final buyPrice = double.tryParse(buyPriceText);
        if (buyPrice == null) {
          buyPriceError.value = 'Harga beli harus berupa angka';
          isValid = false;
        } else if (buyPrice <= 0) {
          buyPriceError.value = 'Harga beli harus lebih dari 0';
          isValid = false;
        } else if (buyPrice > 999999999) {
          buyPriceError.value = 'Harga beli terlalu besar';
          isValid = false;
        }
      }
    }

    return isValid;
  }

  void clearValidationErrors() {
    quantityError.value = '';
    dateError.value = '';
    buyPriceError.value = '';
    notesError.value = '';
    hasAttemptedSubmit.value = false;
  }

  Future<bool> createStock(int produkId, String type, String produkName) async {
    if (!validateForm(type)) {
      return false;
    }

    statusCreate.value = ApiCallStatus.loading;
    errorCreate.value = '';
    const url = Constants.baseUrl + Constants.STOCKS_CREATE;
    final token = StorageManager().read<String>('token');

    final payload = {
      'product_id': produkId,
      'product_name': produkName,
      'product_type': 'product',
      'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
      'type': type,
      'notes': notesController.text.trim(),
      'date': dateController.text.trim(),
    };

    if (type == 'in') {
      payload['buy_price'] =
          double.tryParse(buyPriceController.text.trim()) ?? 0;
    }

    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      data: payload,
      onSuccess: (response) async {
        try {
          final parsed = ApiResponse<Stock>.fromJson(
            response.data,
            (json) => Stock.fromJson(json),
          );
          if (parsed.data != null) {
            stok.value = parsed.data;
            listStock.insert(0, parsed.data!);
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
    fetchStockList(refresh: true);
    return success;
  }

  void resetForm() {
    quantityController.clear();
    dateController.clear();
    buyPriceController.clear();
    notesController.clear();
    clearValidationErrors();
  statusCreate.value = ApiCallStatus.holding;
    errorCreate.value = '';
  }

  Future<bool> searchStokList({required String search}) async {
    statusListStock.value = ApiCallStatus.loading;
    errorListStock.value = '';
    final url = '${Constants.baseUrl}${Constants.STOCKS}?search=${search}';
    final token = StorageManager().read<String>('token');
    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.get,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      onSuccess: (response) async {
        try {
          final responseData = response.data;
          if (responseData != null && responseData['data'] is List) {
            final List<dynamic> dataList = responseData['data'];
            final List<Stock> stocks =
                dataList.map((json) => Stock.fromJson(json)).toList();
            listStock.assignAll(stocks);
            statusListStock.value = ApiCallStatus.success;
            success = true;
          } else {
            throw Exception('Invalid response format');
          }
        } catch (e) {
          errorListStock.value = 'Error parsing response: $e';
          statusListStock.value = ApiCallStatus.error;
          print('Parsing error: $e');
        }
      },
      onError: (e) {
        errorListStock.value = e.toString();
        statusListStock.value = ApiCallStatus.error;
        print('API Error: $e');
      },
    );

    if (statusListStock.value == ApiCallStatus.loading) {
      statusListStock.value = ApiCallStatus.error;
      errorListStock.value = 'Request timeout';
    }

    return success;
  }

  // Fetch stock list dengan pagination
  Future<bool> fetchStockList(
      {bool refresh = false,
      bool isLoadMore = false,
      bool pembelian = false}) async {
    // Jika refresh, reset pagination
    if (refresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      listStock.clear();
    }

    // Only set loading status if it's not a load more operation
    if (!isLoadMore) {
      statusListStock.value = ApiCallStatus.loading;
    }
    errorListStock.value = '';

    // Build URL dengan query parameter pagination
    final url =
        '${Constants.baseUrl}${Constants.STOCKS}?page=${currentPage.value}&per_page=100${pembelian ? '&type=in' : ''}';
    final token = StorageManager().read<String>('token');

    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.get,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      onSuccess: (response) async {
        try {
          final responseData = response.data;
          if (responseData != null && responseData['data'] is List) {
            final List<dynamic> dataList = responseData['data'];
            final List<Stock> stocks =
                dataList.map((json) => Stock.fromJson(json)).toList();

            // Jika refresh, replace semua data. Jika tidak, append
            if (refresh) {
              listStock.assignAll(stocks);
            } else {
              listStock.addAll(stocks);
            }

            // Parse pagination metadata dari response
            if (responseData['meta'] != null &&
                responseData['meta']['pagination'] != null) {
              final pagination = responseData['meta']['pagination'];
              currentPage.value =
                  pagination['current_page'] ?? currentPage.value;
              totalPages.value = pagination['total_pages'] ?? 1;

              // Check apakah masih ada data selanjutnya
              hasMoreData.value = currentPage.value < totalPages.value;
            } else {
              // Jika tidak ada meta, cek dari jumlah data yang diterima
              hasMoreData.value = stocks.length >= 10;
            }

            // Only update status if it's not a load more operation
            if (!isLoadMore) {
              statusListStock.value = ApiCallStatus.success;
            }
            success = true;
          } else {
            throw Exception('Invalid response format');
          }
        } catch (e) {
          errorListStock.value = 'Error parsing response: $e';
          if (!isLoadMore) {
            statusListStock.value = ApiCallStatus.error;
          }
          print('Parsing error: $e');
        }
      },
      onError: (e) {
        errorListStock.value = e.toString();
        if (!isLoadMore) {
          statusListStock.value = ApiCallStatus.error;
        }
        print('API Error: $e');
      },
    );

    if (statusListStock.value == ApiCallStatus.loading) {
      statusListStock.value = ApiCallStatus.error;
      errorListStock.value = 'Request timeout';
    }

    listStock.sort((a, b) => (b.id).compareTo(a.id));
    return success;
  }

  // Load more stocks untuk infinite scroll
  Future<void> loadMoreStocks({bool pembelian = false}) async {
    // Jangan load jika sedang loading atau sudah tidak ada data lagi
    if (isLoadingMore.value || !hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    await fetchStockList(isLoadMore: true, pembelian: pembelian);

    isLoadingMore.value = false;
  }

  Future<bool> fetchProductsWithStock() async {
    statusProductsStock.value = ApiCallStatus.loading;
    errorProductsStock.value = '';
    const url = Constants.baseUrl + Constants.STOCKS_PRODUCTS_SHOP;
    final token = StorageManager().read<String>('token');

    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.get,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      onSuccess: (response) async {
        try {
          final stockLis = response.data;
          if (stockLis != null && stockLis['data'] is List) {
            final List<dynamic> dataList = stockLis['data'];
            final List<ProductWithStock> products = dataList
                .map((json) => ProductWithStock.fromJson(json))
                .toList();

            productsStock.assignAll(products);
            statusProductsStock.value = ApiCallStatus.success;
            success = true;
          } else {
            throw Exception('Invalid response format');
          }
        } catch (e) {
          errorProductsStock.value = 'Error parsing response: $e';
          statusProductsStock.value = ApiCallStatus.error;
          print('Parsing error: $e');
        }
      },
      onError: (e) {
        errorProductsStock.value = e.toString();
        statusProductsStock.value = ApiCallStatus.error;
        print('API Error: $e');
      },
    );

    if (statusProductsStock.value == ApiCallStatus.loading) {
      statusProductsStock.value = ApiCallStatus.error;
      errorProductsStock.value = 'Request timeout';
    }
    return success;
  }

  @override
  void onClose() {
    quantityController.dispose();
    dateController.dispose();
    buyPriceController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
