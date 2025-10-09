import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/keranjang_model.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/data/models/user_model.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:payoo/config/utils/storage_manager.dart';

class KeranjangController extends GetxController {
  var countItem = <int, int>{}.obs;

  var status = ApiCallStatus.holding.obs;
  var keranjang = Rx<KeranjangModel?>(null);
  var error = ''.obs;
  var product = <Produk>[].obs;
  var paymentAmount = 0.0.obs;
  AkunController userController = Get.find<AkunController>();
  final enteredAmount = TextEditingController();
  final namaController = TextEditingController();
  final hargaModalController = TextEditingController();
  final hargaJualController = TextEditingController();
  final satuanController = TextEditingController();
  final notesController = TextEditingController();
  RxString selectedPaymentMethod = 'cash'.obs;
  var shopId = 0.obs;
  var userId = 0.obs;

  // State update
  var statusUpdate = ApiCallStatus.holding.obs;
  var errorUpdate = ''.obs;
  var orderId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
    _loadAkun();
  }

  Future<bool> createOrder({String? notes}) async {
    status.value = ApiCallStatus.loading;
    error.value = '';
    const url = Constants.baseUrl + Constants.ORDERS;
    final token = StorageManager().read<String>('token');

    // Ensure user data is loaded before proceeding
    while (userController.status.value == ApiCallStatus.loading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (shopId.value == 0) {
      error.value = 'Shop ID not found';
      status.value = ApiCallStatus.error;
      return false;
    }

    // Parse entered amount to ensure we have the correct payment amount
    final enteredAmountValue = double.tryParse(enteredAmount.text.trim());
    if (enteredAmountValue == null || enteredAmountValue <= 0) {
      error.value = 'Invalid payment amount';
      status.value = ApiCallStatus.error;
      return false;
    }

    // Set the payment amount
    paymentAmount.value = enteredAmountValue;

    // Create order items from current cart
    final orderItems = product.map((prod) {
      final quantity = countItem[prod.id] ?? 0;
      return {
        'product_id': prod.id,
        'quantity': quantity,
        'price': prod.sellingPrice,
      };
    }).toList();

    if (orderItems.isEmpty) {
      error.value = 'Cart is empty';
      status.value = ApiCallStatus.error;
      return false;
    }

    // Get current timestamp for created_at and updated_at
    final now = DateTime.now().toString().split('.')[0].replaceAll('T', ' ');

    // Calculate change money
    final changeAmount = paymentAmount.value - totalPrice;

    // Default tax rate (can be made configurable)
    final taxRate = 0.0; // 0% tax by default
    final taxAmount = totalPrice * taxRate;

    final payload = {
      'user_id': userId.value.toString(),
      'shop_id': shopId.value.toString(),
      'status': 'pending', // Consider making this configurable
      'notes': notesController.text.isNotEmpty
          ? notesController.text
          : (notes ?? ''),
      'total': totalPrice.toStringAsFixed(2),
      'amount_paid': paymentAmount.value.toStringAsFixed(2),
      'created_at': now,
      'updated_at': now,
      'order_items': orderItems,
      'payment_method': selectedPaymentMethod.value,
      'change_money': changeAmount.toStringAsFixed(2),
      'tax': taxAmount.toStringAsFixed(2),
      'discount': '0%', // Use string format to match expected output
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
          orderId.value = keranjang.value?.id ?? 0;
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
    notesController.clear();
    super.onClose();
  }

  void _initializeFromArguments() {
    final args = Get.arguments;
    if (args != null && args is List<Produk>) {
      product.clear();
      countItem.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        product.assignAll(args);

        for (var prod in args) {
          countItem[prod.id] = 1;
        }
      });
    }
  }

  void _loadAkun() {
    if (userController.user.value != null) {
      namaController.text = userController.user.value!.name ?? '';
      userId.value = userController.user.value!.id;
      shopId.value = userController.user.value?.shopId ?? 0;
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

   double get totalItems {
    double total = 0;

    for (var prod in product) {
      int quantity = countItem[prod.id] ?? 0;
      total += quantity;
    }

    return total;
   }


  // ✅ Helper method for clearing cart
  void clearCart() {
    product.clear();
    countItem.clear();
  }
}
