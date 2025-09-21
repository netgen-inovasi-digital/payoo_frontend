import 'package:get/get.dart';
import 'package:payoo/app/data/models/Toko_model.dart';
import 'package:payoo/app/data/models/keranjang_model.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/modules/toko/controllers/toko_controller.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/config/utils/storage_manager.dart';

import '../../../../config/utils/constant.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class StrukController extends GetxController {
var status = ApiCallStatus.holding.obs;
var order = Rx<KeranjangModel?>(null);
TokoController tokoController = Get.find<TokoController>();
var totalHarga = 0.0.obs;
var returnAmount = 0.0.obs;
var totalItem = 0.obs;
var error = ''.obs;
var shopId = 0.obs;
var userId = 0.obs;
var toko = <Toko?>[].obs;
ProdukController produkController =
    Get.put<ProdukController>(ProdukController());
List<Produk> produkList = <Produk>[].obs;

// State update
var statusUpdate = ApiCallStatus.holding.obs;
var errorUpdate = ''.obs;

Future<bool> getOrderById({required int orderId}) async {
  status.value = ApiCallStatus.loading;
  error.value = '';
  final url = Constants.baseUrl +
      Constants.ORDER_BY_ID.replaceFirst('{id}', orderId.toString());
  final token = StorageManager().read<String>('token');

  bool success = false;
  await BaseClient.safeApiCall(
    url,
    RequestType.get,
    headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    onSuccess: (response) async {
      try {
        final parsed = ApiResponse<KeranjangModel>.fromJson(
          response.data,
          (json) => KeranjangModel.fromJson(json),
        );
        if (parsed.data != null) {
          order.value = parsed.data;
          shopId.value = int.tryParse('${order.value?.shopId}') ?? 0;
          userId.value = int.tryParse('${order.value?.userId}') ?? 0;
          await tokoController.fetchTokoById(shopId.value);
          calculateTotalHargaAndItem();
          produkList.clear();

          // Load all products in parallel
          final productIds = order.value?.orderItems
                  .map((item) => item.productId)
                  .toList() ??
              [];

          // Fetch products one by one and add them to the list
          final products = await Future.wait(
            productIds.map((id) async {
              await produkController.fetchProdukById(id);
              return produkController.produk.value;
            }),
          );
          produkList.assignAll(products.whereType<Produk>());
        }

        status.value = ApiCallStatus.success;
        success = true;
      } catch (e) {
        error.value = 'Parsing error: ${e.toString()}';
        status.value = ApiCallStatus.error;
      }
    },
    onError: (e) {
      error.value = e.toString();
      status.value = ApiCallStatus.error;
    },
  );

  if (status.value == ApiCallStatus.loading) {
    status.value = ApiCallStatus.error;
  }
  return success;
}

void calculateTotalHargaAndItem() {
  totalHarga.value = 0.0;
  totalItem.value = 0; // reset first
  if (order.value?.orderItems != null) {
    for (var item in order.value!.orderItems!) {
      totalHarga.value += item.price * item.quantity;
      totalItem.value += item.quantity;
    }
  }
}

@override
void onClose() {
  super.onClose();
}
}
