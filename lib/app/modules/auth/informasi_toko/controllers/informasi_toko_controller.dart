import 'package:get/get.dart';
import 'package:payoo/app/data/models/model_lokasi.dart';
import 'package:payoo/app/services/api_response.dart';

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
        provinces.value = apiResponse.result;
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
        cities.value = apiResponse.result;

        cityStatus.value = ApiCallStatus.success; // Perbarui nilai
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        cityStatus.value = ApiCallStatus.error; // Perbarui nilai
      },
    );
  }
}
