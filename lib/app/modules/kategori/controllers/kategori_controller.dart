import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/kategori_model.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/utils/constant.dart';
import 'package:payoo/utils/storage_manager.dart';

class KategoriController extends GetxController {
  // List state
  final statusList = ApiCallStatus.holding.obs;
  final errorList = ''.obs;
  final list = <Kategori>[].obs;

  // Create state
  final statusCreate = ApiCallStatus.holding.obs;
  final errorCreate = ''.obs;

  // Delete state
  final statusDelete = ApiCallStatus.holding.obs; // last delete op
  final errorDelete = ''.obs;
  final deletingIds = <int>{}.obs; // track multiple deletes simultaneously

  // Update state
  final statusUpdate = ApiCallStatus.holding.obs;
  final errorUpdate = ''.obs;

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    fetchKategori();
    super.onInit();
  }

  Future<void> fetchKategori() async {
    statusList.value = ApiCallStatus.loading;
    errorList.value = '';
    const url = Constants.baseUrl + Constants.CATEGORIES;
    final token = StorageManager().read<String>('token');
    await BaseClient.safeApiCall(
      url,
      RequestType.get,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<Kategori>.fromJson(
            response.data,
            (json) => Kategori.fromJson(json),
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

  Future<bool> createKategori() async {
    statusCreate.value = ApiCallStatus.loading;
    errorCreate.value = '';
    const url = Constants.baseUrl + Constants.CATEGORIES;
    final token = StorageManager().read<String>('token');
    final payload = {
      'name': nameController.text.trim(),
      if (descriptionController.text.trim().isNotEmpty)
        'description': descriptionController.text.trim(),
    };
    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      data: payload,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<Kategori>.fromJson(
            response.data,
            (json) => Kategori.fromJson(json),
          );
          if (parsed.data != null) {
            list.insert(0, parsed.data!);
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

  Future<bool> deleteKategori(int id) async {
    deletingIds.add(id);
    statusDelete.value = ApiCallStatus.loading;
    errorDelete.value = '';
    final url = (Constants.baseUrl + Constants.CATEGORY_BY_ID).replaceAll('{id}', id.toString());
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
    deletingIds.remove(id);
    return success;
  }

  Future<bool> updateKategori(int id) async {
    statusUpdate.value = ApiCallStatus.loading;
    errorUpdate.value = '';
    final url = (Constants.baseUrl + Constants.CATEGORY_BY_ID).replaceAll('{id}', id.toString());
    final token = StorageManager().read<String>('token');
    final payload = {
      'name': nameController.text.trim(),
      if (descriptionController.text.trim().isNotEmpty)
        'description': descriptionController.text.trim(),
    };
    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.put,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      data: payload,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<Kategori>.fromJson(
            response.data,
            (json) => Kategori.fromJson(json),
          );
          if (parsed.data != null) {
            final idx = list.indexWhere((k) => k.id == id);
            if (idx != -1) {
              list[idx] = parsed.data!;
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

  void resetCreateForm() {
    nameController.clear();
    descriptionController.clear();
    statusCreate.value = ApiCallStatus.holding;
    errorCreate.value = '';
  statusUpdate.value = ApiCallStatus.holding;
  errorUpdate.value = '';
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}