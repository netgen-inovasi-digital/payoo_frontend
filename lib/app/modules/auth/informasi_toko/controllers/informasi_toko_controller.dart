import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/model_lokasi.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/utils/storage_manager.dart';

import '../../../../../utils/constant.dart';
import '../../../../services/api_call_status.dart';
import '../../../../services/base_client.dart';

class InformasiTokoController extends GetxController {
  // hold data coming from api
  var provinces = <ModelLokasi>[].obs;
  var cities = <ModelLokasi>[].obs;
  // api call status
  var provinceStatus = ApiCallStatus.holding.obs;
  var cityStatus = ApiCallStatus.holding.obs;

  // form controllers
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();

  // selections
  var selectedType = ''.obs; // mandiri / perusahaan
  var selectedProvince = ''.obs; // province name
  var selectedCity = ''.obs; // city name

  // save shop state
  var isSaving = false.obs;
  var saveError = ''.obs;
  var saveSuccess = false.obs;

  @override
  void onInit() {
    getDataProvinces();
    super.onInit();
  }

  // getting data from api
  // pengambilan data lokasi
  Future<void> getDataProvinces() async {
    await BaseClient.safeApiCall(
      Constants.lokasiProvinsiUrl,
      RequestType.get,
      onLoading: () {
        provinceStatus.value = ApiCallStatus.loading; // Perbarui nilai
      },
      onSuccess: (response) {
        // Convert JSON response to ApiResponse model
        final apiResponse = ApiResponse<ModelLokasi>.fromJson(
          response.data, // Respons JSON
          (json) => ModelLokasi.fromJson(json), // Parsing ModelLokasi
        );

        // Extract the "text" values from the result
        provinces.value = apiResponse.result!;
        provinceStatus.value = ApiCallStatus.success; // Perbarui nilai
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        provinceStatus.value = ApiCallStatus.error; // Perbarui nilai
      },
    );
  }

  Future<void> getDataCities(String idProvince) async {
    await BaseClient.safeApiCall(
      Constants.lokasiKotaUrl + idProvince,
      RequestType.get,
      onLoading: () {
        cityStatus.value = ApiCallStatus.loading; // Perbarui nilai
      },
      onSuccess: (response) {
        // Convert JSON response to ApiResponse model
        final apiResponse = ApiResponse<ModelLokasi>.fromJson(
          response.data, // Respons JSON
          (json) => ModelLokasi.fromJson(json), // Parsing ModelLokasi
        );

        // Extract the "text" values from the result
        cities.value = apiResponse.result!;

        cityStatus.value = ApiCallStatus.success; // Perbarui nilai
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        cityStatus.value = ApiCallStatus.error; // Perbarui nilai
      },
    );
  }

  void setType(String value) => selectedType.value = value;
  void setProvince(String value) => selectedProvince.value = value;
  void setCity(String value) => selectedCity.value = value;

  bool _validateForm() {
    if (name.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        address.text.trim().isEmpty ||
        phone.text.trim().isEmpty ||
        selectedType.value.isEmpty ||
        selectedProvince.value.isEmpty ||
        selectedCity.value.isEmpty) {
      saveError.value = 'Lengkapi semua field wajib';
      return false;
    }
    return true;
  }

  Future<void> saveShop() async {
    saveError.value = '';
    saveSuccess.value = false;
    if (!_validateForm()) return;
    // ambil token
    final token = StorageManager().read<String>('token');
    if (token == null || token.isEmpty) {
      saveError.value = 'Token tidak ditemukan, silakan login ulang';
      return;
    }
    isSaving.value = true;
    final payload = {
      'name': name.text.trim(),
      'email': email.text.trim(),
      'address': address.text.trim(),
      'type': selectedType.value,
      'province': selectedProvince.value,
      'city': selectedCity.value,
      'phone': phone.text.trim(),
    };

    const url = Constants.baseUrl + Constants.SHOPS;
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      headers: {
        'Authorization': 'Bearer $token',
      },
      data: payload,
      onSuccess: (response) {
        saveSuccess.value = true;
        isSaving.value = false;
      },
      onError: (error) {
        saveError.value = error.toString();
        isSaving.value = false;
      },
    );
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    address.dispose();
    phone.dispose();
    super.onClose();
  }
}
