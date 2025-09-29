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
  
  // State create
  var statusCreate = ApiCallStatus.holding.obs;
  var errorCreate = ''.obs;

  // Form validation states
  var quantityError = ''.obs;
  var dateError = ''.obs;
  var hasAttemptedSubmit = false.obs;

  bool validateForm() {
    hasAttemptedSubmit.value = true;
    quantityError.value = '';
    dateError.value = '';
    
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
    
    return isValid;
  }

  void clearValidationErrors() {
    quantityError.value = '';
    dateError.value = '';
    hasAttemptedSubmit.value = false;
  }

  Future<bool> createStock(int komposisId, String type) async {
    // Validate form before making API call
    if (!validateForm()) {
      return false;
    }

    statusCreate.value = ApiCallStatus.loading;
    errorCreate.value = '';
    const url = Constants.baseUrl + Constants.STOCKS_CREATE;
    final token = StorageManager().read<String>('token');

    // Parse category_id to integer
    final categoryId = int.tryParse(komposisId.toString());
    if (categoryId == null) {
      errorCreate.value = 'Invalid category selected';
      statusCreate.value = ApiCallStatus.error;
      return false;
    }

    final payload = {
      'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
      'date': dateController.text.trim(),
      'composition_id': categoryId,
      'type': type,
    };

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
            stok = Rx<Stock?>(parsed.data);
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

  void resetForm() {
    quantityController.clear();
    dateController.clear();
    clearValidationErrors();
    statusCreate.value = ApiCallStatus.holding;
    errorCreate.value = '';
  }

  @override
  void onClose() {
    quantityController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
