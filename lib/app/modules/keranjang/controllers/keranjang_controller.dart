import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/keranjang_modal.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/data/models/user_model.dart';
import 'package:payoo/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:payoo/app/modules/dashboarduser/controllers/dashboard_user_controller.dart';
import 'package:payoo/app/modules/dashboarduser/views/dashboard_user_view.dart' hide DashboardUserController;
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/utils/constant.dart';
import 'package:payoo/utils/storage_manager.dart';

class KeranjangController extends GetxController {
  var countItem = <int, int>{}.obs;
  var status = ApiCallStatus.holding.obs;
  var keranjang = Rx<KeranjangModel?>(null);
  var error = ''.obs;
  var product = <Produk>[].obs;
  DashboardUserController userController = Get.find<DashboardUserController>();
    

  final namaController = TextEditingController();
  final hargaModalController = TextEditingController();
  final hargaJualController = TextEditingController();
  final satuanController = TextEditingController();
  // State update
  var statusUpdate = ApiCallStatus.holding.obs;
  var errorUpdate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }
  Future<bool> createOrder({String? notes}) async {
    status.value = ApiCallStatus.loading;
    error.value = '';
    const url =
        Constants.baseUrl + Constants.ORDERS; // Update with correct endpoint
    final token = StorageManager().read<String>('token');

    // Ensure user data is loaded before proceeding
    while (userController.status.value == ApiCallStatus.loading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    User? currentUser = userController.user.value;
    int? shopId = currentUser?.shopId;
    if (shopId == null) {
      error.value = 'Shop ID not found';
      status.value = ApiCallStatus.error;
      return false;
    }
    if (currentUser == null) {
      error.value = 'User not found';
      status.value = ApiCallStatus.error;
      return false;
    }

    // Create order items from current cart
    final orderItems = product.map((prod) {
      final quantity = countItem[prod.id] ?? 0;
      return {
        'product_id': prod.id,
        'quantity': quantity,
        'price': prod.sellingPrice,
        'subtotal': prod.sellingPrice * quantity
      };
    }).toList();

    final payload = {
      'shop_id': shopId,
      'notes': notes ?? '',
      'total': totalPrice,
      'order_items': orderItems
    };

    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      data: payload,
      onSuccess: (response) {
        try {
          final parsed = ApiResponse<KeranjangModel>.fromJson(
            response.data,
            (json) => KeranjangModel.fromJson(json),
          );
          if (parsed.data != null) {
            keranjang.value = parsed.data;
            clearCart(); // Clear cart after successful order
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

  @override
  void onClose() {
    // ✅ Proper cleanup
    product.clear();
    countItem.clear();
    super.onClose();
  }

  void _initializeFromArguments() {
    final args = Get.arguments;
    if (args != null && args is List<Produk>) {
      // ✅ Clear first to avoid conflicts on second opening
      product.clear();
      countItem.clear();

      // ✅ Use Future.microtask to avoid GetX scope issues
      Future.microtask(() {
        product.assignAll(args);

        // Initialize counts
        for (var prod in args) {
          countItem[prod.id] = 1;
        }
      });
    }
  }

  void addProduct(Produk produk) {
    // Check if product already exists in cart
    bool productExists = product.any((p) => p.id == produk.id);

    if (!productExists) {
      // Add new product to cart
      product.add(produk);
      countItem[produk.id] = 1; // Initialize with count 1
    } else {
      // If product exists, increment the count
      incrementCount(produk.id);
    }
  }

  int getProductCount(int productId) {
    return countItem[productId] ?? 0;
  }

  void incrementCount(int productId) {
    countItem[productId] = getProductCount(productId) + 1;
  }

  void decrementCount(int productId) {
    int currentCount = getProductCount(productId);
    if (currentCount > 1) {
      countItem[productId] = currentCount - 1;
    }
  }

  void setProductCount(int productId, int count) {
    if (count <= 0) {
      removeProduct(productId);
    } else {
      countItem[productId] = count;
    }
    // ✅ Remove update() since we're using .obs
  }

  void removeProduct(int productId) {
    // ✅ Use reactive methods
    product.removeWhere((p) => p.id == productId);
    countItem.remove(productId);
    // ✅ Remove update() since we're using .obs
  }

  // ✅ Fixed calculation - no double counting
  double get totalPrice {
    double total = 0.0;

    for (var prod in product) {
      int quantity = countItem[prod.id] ?? 0;
      total += prod.sellingPrice * quantity;
    }

    return total;
  }

  get selectedPaymentMethod => null;

  // ✅ Helper method for clearing cart
  void clearCart() {
    product.clear();
    countItem.clear();
  }
}
