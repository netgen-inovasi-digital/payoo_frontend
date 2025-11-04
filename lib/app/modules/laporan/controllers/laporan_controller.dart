import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/keranjang_model.dart';
import 'package:payoo/app/data/models/laporan_model.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/config/utils/storage_manager.dart';

import '../../../../config/utils/constant.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class LaporanController extends GetxController {
  // Change from List<OrdersReport> to a single Rx<OrdersReport?>
  var ordersReport = Rx<OrdersReport?>(null);
  var statusOrderReport = ApiCallStatus.holding.obs;
  var errorOrderReport = ''.obs;
  var selectedPeriod = 'bulan ini'.obs;
  TextEditingController rangeStartController = TextEditingController();
  TextEditingController rangeEndController = TextEditingController();

  var reportSummary = Rx<ReportSummary?>(null);
  var statusSummary = ApiCallStatus.holding.obs;
  var errorSummary = ''.obs;
  var shopId = 0.obs;

  var orderDetail = Rx<KeranjangModel?>(null);
  var statusOrderDetail = ApiCallStatus.holding.obs;
  var errorOrderDetail = ''.obs;

  @override
  void onInit() {
    shopId.value = getShopIdFromParameters();
    super.onInit();
  }

  int getShopIdFromParameters() {
    final args = Get.arguments;
    // Case 1: Direct integer
    if (args != null && args is int) {
      return args;
    }

    // Case 2: Map with shopId key
    if (args != null && args is Map) {
      if (args.containsKey('shopId')) {
        return args['shopId'] is int
            ? args['shopId']
            : int.tryParse(args['shopId'].toString()) ?? 0;
      }
      if (args.containsKey('shop_id')) {
        return args['shop_id'] is int
            ? args['shop_id']
            : int.tryParse(args['shop_id'].toString()) ?? 0;
      }
    }

    // Fallback: Try to get from storage
    final storage = StorageManager();
    final storedShopId = storage.read<int>('shopId');
    if (storedShopId != null) {
      return storedShopId;
    }

    return 0; // Default if all else fails
  }

  ProdukController produkController =
      Get.put<ProdukController>(ProdukController());
  List<Produk> produkList = <Produk>[].obs;

  Future<void> fetchOrderReport({required String period}) async {
    statusOrderReport.value = ApiCallStatus.loading;
    errorOrderReport.value = '';
    final url =
        "${Constants.baseUrl}${Constants.REPORTS_ORDERS.replaceAll('{shop_id}', shopId.value.toString())}?period=$period";
    final storage = StorageManager();
    final token = storage.read<String>('token');
    await BaseClient.safeApiCall(url, RequestType.get,
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        onSuccess: (response) {
      try {
        final parsed = ApiResponse<OrdersReport>.fromJson(
          response.data,
          (json) => OrdersReport.fromJson(json),
        );
        ordersReport.value = parsed.data;
        statusOrderReport.value = ApiCallStatus.success;
      } catch (e) {
        errorOrderReport.value = 'Parsing error $e';
        statusOrderReport.value = ApiCallStatus.error;
      }
    }, onError: (e) {
      errorOrderReport.value = e.toString();
      statusOrderReport.value = ApiCallStatus.error;
    });
  }

  fetchOrderReportByDateRange() async {
    statusOrderReport.value = ApiCallStatus.loading;
    errorOrderReport.value = '';
    final url =
        "${Constants.baseUrl}${Constants.REPORTS_ORDERS_V2.replaceAll('{shop_id}', shopId.value.toString())}?range_start=${rangeStartController.text}&range_end=${rangeEndController.text}";
    final storage = StorageManager();
    final token = storage.read<String>('token');
    await BaseClient.safeApiCall(url, RequestType.get,
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        onSuccess: (response) {
      try {
        final parsed = ApiResponse<OrdersReport>.fromJson(
          response.data,
          (json) => OrdersReport.fromJson(json),
        );
        ordersReport.value = parsed.data;
        statusOrderReport.value = ApiCallStatus.success;
      } catch (e) {
        errorOrderReport.value = 'Parsing error $e';
        statusOrderReport.value = ApiCallStatus.error;
      }
    }, onError: (e) {
      errorOrderReport.value = e.toString();
      statusOrderReport.value = ApiCallStatus.error;
    });
  }

  Future<void> fetchReportSummary({required String period}) async {
    statusSummary.value = ApiCallStatus.loading;
    errorSummary.value = '';
    var url =
        "${Constants.baseUrl}${Constants.REPORTS_SUMMARY.replaceAll('{shop_id}', shopId.toString())}?period=$period";
    final storage = StorageManager();
    final token = storage.read<String>('token');

    await BaseClient.safeApiCall(
      url,
      RequestType.get,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<ReportSummary>.fromJson(
            response.data,
            (json) => ReportSummary.fromJson(json),
          );
          reportSummary.value = parsed.data;
          statusSummary.value = ApiCallStatus.success;
        } catch (e) {
          errorSummary.value = 'Parsing error $e';
          statusSummary.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        errorSummary.value = e.toString();
        statusSummary.value = ApiCallStatus.error;
      },
    );
  }

  Future<void> fetchOrderDetail({required int orderId}) async {
    statusOrderDetail.value = ApiCallStatus.loading;
    errorOrderDetail.value = '';

    var url =
        "${Constants.baseUrl}${Constants.ORDER_BY_ID.replaceAll('{id}', orderId.toString())}";
    final storage = StorageManager();
    final token = storage.read<String>('token');

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
          orderDetail.value = parsed.data;

          // Clear existing products
          produkList.clear();

          // Load all products in parallel
          final productIds = orderDetail.value?.orderItems
                  .map((item) => item.productId)
                  .toList() ??
              [];

          // Fetch products one by one and add them to the list
          for (var id in productIds) {
            await produkController.fetchProdukById(id);
            if (produkController.produk.value != null) {
              produkList.add(produkController.produk.value!);
            }
          }

          statusOrderDetail.value = ApiCallStatus.success;
        } catch (e) {
          errorOrderDetail.value = 'Parsing error $e';
          statusOrderDetail.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        errorOrderDetail.value = e.toString();
        statusOrderDetail.value = ApiCallStatus.error;
      },
    );
  }

  @override
  void onClose() {
    // Reset all Rx values to their initial states
    ordersReport.value = null;
    statusOrderReport.value = ApiCallStatus.holding;
    errorOrderReport.value = '';
    selectedPeriod.value = 'bulan ini';

    reportSummary.value = null;
    statusSummary.value = ApiCallStatus.holding;
    errorSummary.value = '';

    orderDetail.value = null;
    statusOrderDetail.value = ApiCallStatus.holding;
    errorOrderDetail.value = '';

    produkList.clear();
    super.onClose();
  }

  // Future<void> fetchProduk() async {
  //   statusOrderReport.value = ApiCallStatus.loading ;
  //   errorOrderReport.value = '';
  //   const url = Constants.baseUrl + Constants.PRODUCTS;

  //   final storage = StorageManager();
  //   final token = storage.read<String>('token');
  //   await BaseClient.safeApiCall(
  //     url,
  //     RequestType.get,
  //     headers: token != null ? {'Authorization': 'Bearer $token'} : null,
  //     onSuccess: (response) {
  //       try {
  //         final parsed = ApiResponse<Produk>.fromJson(
  //           response.data,
  //           (json) => Produk.fromJson(json),
  //         );
  //         list.assignAll(parsed.result ?? []);
  //         statusOrderReport.value = ApiCallStatus.success;
  //       } catch (e) {
  //         errorOrderReport.value = 'Parsing error';
  //         statusOrderReport.value = ApiCallStatus.error;
  //       }
  //     },
  //     onError: (e) {
  //       errorOrderReport.value = e.toString();
  //       statusOrderReport.value = ApiCallStatus.error;
  //     },
  //   );
  //   if (statusOrderReport.value == ApiCallStatus.loading) {
  //     statusOrderReport.value = ApiCallStatus.error;
  //   }
  // }
}
