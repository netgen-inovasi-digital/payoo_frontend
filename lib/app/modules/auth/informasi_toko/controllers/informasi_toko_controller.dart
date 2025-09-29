import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/model_lokasi.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/config/utils/storage_manager.dart';

import '../../../../../config/utils/constant.dart';
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

  // Validation error messages (only shown after submit attempt)
  var nameError = ''.obs;
  var emailError = ''.obs;
  var addressError = ''.obs;
  var phoneError = ''.obs;
  var typeError = ''.obs;
  var provinceError = ''.obs;
  var cityError = ''.obs;
  var hasAttemptedSubmit = false.obs;

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

  bool validateForm() {
    hasAttemptedSubmit.value = true;
    nameError.value = '';
    emailError.value = '';
    addressError.value = '';
    phoneError.value = '';
    typeError.value = '';
    provinceError.value = '';
    cityError.value = '';
    
    bool isValid = true;
    
    // Validate shop name
    final nameText = name.text.trim();
    if (nameText.isEmpty) {
      nameError.value = 'Nama toko tidak boleh kosong';
      isValid = false;
    } else if (nameText.length < 2) {
      nameError.value = 'Nama toko minimal 2 karakter';
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
    
    // Validate address
    final addressText = address.text.trim();
    if (addressText.isEmpty) {
      addressError.value = 'Alamat toko tidak boleh kosong';
      isValid = false;
    } else if (addressText.length < 5) {
      addressError.value = 'Alamat toko minimal 5 karakter';
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
    
    // Validate type
    if (selectedType.value.isEmpty) {
      typeError.value = 'Jenis toko harus dipilih';
      isValid = false;
    }
    
    // Validate province
    if (selectedProvince.value.isEmpty) {
      provinceError.value = 'Provinsi harus dipilih';
      isValid = false;
    }
    
    // Validate city
    if (selectedCity.value.isEmpty) {
      cityError.value = 'Kabupaten/Kota harus dipilih';
      isValid = false;
    }
    
    return isValid;
  }

  Future<void> saveShop() async {
    // Validate form before making API call
    if (!validateForm()) {
      return;
    }

    saveError.value = '';
    saveSuccess.value = false;
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

  void resetForm() {
    name.clear();
    email.clear();
    address.clear();
    phone.clear();
    selectedType.value = '';
    selectedProvince.value = '';
    selectedCity.value = '';
    isSaving.value = false;
    saveError.value = '';
    saveSuccess.value = false;
    // Reset validation errors
    nameError.value = '';
    emailError.value = '';
    addressError.value = '';
    phoneError.value = '';
    typeError.value = '';
    provinceError.value = '';
    cityError.value = '';
    hasAttemptedSubmit.value = false;
  }
}
