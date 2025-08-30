import 'package:get/get.dart';
import 'package:payoo/app/data/models/produk_model.dart';

class KeranjangController extends GetxController {
  // ✅ Make product observable
  var product = <Produk>[].obs;
  var countItem = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
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
      total += prod.price * quantity;
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
