import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
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
  // State update
  var statusCreate = ApiCallStatus.holding.obs;
  var errorCreate = ''.obs;
  var statusUpdate = ApiCallStatus.holding.obs;
  var errorUpdate = ''.obs;

  Future<bool> createStock(int komposisId, String type) async {
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
            await updateKomposisi(komposisId);
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

  Future<bool> updateKomposisi(int id) async {
    statusUpdate.value = ApiCallStatus.loading;
    errorUpdate.value = '';
    final url = Constants.baseUrl +
        Constants.COMPOSITION_BY_ID.replaceAll('{id}', id.toString());
    final token = StorageManager().read<String>('token');
	
    final payload = {
      'stock': int.tryParse(quantityController.text.trim()) ?? 0,
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
}
