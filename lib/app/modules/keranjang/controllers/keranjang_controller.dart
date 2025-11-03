import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  AkunController userController = Get.put<AkunController>(AkunController());
  final enteredAmount = TextEditingController();
  final namaController = TextEditingController();
  final hargaModalController = TextEditingController();
  final hargaJualController = TextEditingController();
  final satuanController = TextEditingController();
  final notesController = TextEditingController();
  final kembalianController = TextEditingController();
  final diskonController = TextEditingController();
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
    if (enteredAmountValue == null || enteredAmountValue <= 0 || enteredAmountValue < totalPrice) {
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

    // ✅ FIXED: Get ACTUAL local time, not UTC
    final now = DateTime.now().toLocal(); // Force to local timezone
    
    // Manual formatting to ensure local time is used
    final formattedDate = '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    
    // Default tax rate (can be made configurable)
    final taxRate = 0.0; // 0% tax by default
    final taxAmount = totalPrice * taxRate;

    final payload = {
      'user_id': userId.value.toString(),
      'shop_id': shopId.value.toString(),
      'status': 'pending',
      'notes': notesController.text.isNotEmpty
          ? notesController.text
          : (notes ?? ''),
      'total': totalPrice.toStringAsFixed(2),
      'amount_paid': paymentAmount.value.toStringAsFixed(2),
      'created_at': formattedDate,
      'updated_at': formattedDate,
      'order_items': orderItems,
      'payment_method': selectedPaymentMethod.value,
      'change_money': kembalianController.text,
      'tax': taxAmount.toStringAsFixed(2),
      'discount': diskonController.text,
    };

    print('Payload being sent: $payload');

    bool success = false;
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      data: payload,
      onSuccess: (response) {
        try {
          print('Order created successfully: ${response.data}');
          final parsed = ApiResponse<KeranjangModel>.fromJson(
            response.data,
            (json) => KeranjangModel.fromJson(json),
          );
          if (parsed.data != null) {
            keranjang.value = parsed.data;
            clearCart();
          }
          orderId.value = keranjang.value?.id ?? 0;
          status.value = ApiCallStatus.success;
          success = true;
        } catch (e) {
          print('Error parsing response: $e');
          error.value = 'Parsing error: ${e.toString()}';
          status.value = ApiCallStatus.error;
        }
      },
      onError: (e) {
        print('Error creating order: $e');
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
    enteredAmount.dispose();
    diskonController.dispose();
    kembalianController.dispose();
    namaController.dispose();
    hargaModalController.dispose();
    hargaJualController.dispose();
    satuanController.dispose();
    notesController.dispose();
    product.clear();
    countItem.clear();
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
    bool productExists = product.any((p) => p.id == produk.id);

    if (!productExists) {
      product.add(produk);
      countItem[produk.id] = 1;
    } else {
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
  }

  void removeProduct(int productId) {
    product.removeWhere((p) => p.id == productId);
    countItem.remove(productId);
  }

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

  void clearCart() {
    product.clear();
    countItem.clear();
  }
}