import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/empty_state.dart';
import 'package:payoo/app/components/product_card.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/keranjang_modal.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/pembayaran_modal.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/theme/light_theme.dart';

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  final TextEditingController _searchController = TextEditingController();
  late final ProdukController _produkController;
  late final KeranjangController _keranjangController;
  String _searchQuery = '';
  bool _expanded = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers properly
    if (Get.isRegistered<ProdukController>()) {
      _produkController = Get.find<ProdukController>();
    } else {
      _produkController = Get.put<ProdukController>(ProdukController());
    }

    if (Get.isRegistered<KeranjangController>()) {
      _keranjangController = Get.find<KeranjangController>();
    } else {
      _keranjangController =
          Get.put<KeranjangController>(KeranjangController());
    }

    // Fetch products only if list is empty
    if (_produkController.list.isEmpty) {
      _produkController.fetchProduk();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Produk> _getFilteredProducts() {
    if (_searchQuery.isEmpty) {
      return _produkController.list;
    } else {
      return _produkController.list.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onProductTap(Produk product) {
    if (_keranjangController.getProductCount(product.id) <= 0) {
      _keranjangController.addProduct(product);
    }
    keranjangModal(
      context: context,
      produk: product,
      controller: _keranjangController,
      produkId: product.id,
    );
    if (_keranjangController.getProductCount(product.id) < 1) {
      // Remove product from cart
      _keranjangController.removeProduct(product.id);
    }
  }

  bool _isProductInCart(Produk product) {
    return _keranjangController.product.any((p) => p.id == product.id);
  }

  Future<void> _refreshData() async {
    await _produkController.fetchProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Transaksi', dividerLine: false),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: SearchInputField(
                    controller: _searchController,
                    onSearchChanged: _onSearchChanged,
                    hintText: 'cari produk (kode | nama)',
                  ),
                ),
                Container(
                  height: 1.0,
                  color: LightThemeColors.accentColor,
                ),
                Expanded(
                  child: Obx(() {
                    if (_produkController.statusList.value ==
                        ApiCallStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_produkController.statusList.value ==
                        ApiCallStatus.error) {
                      return EmptyState(
                        title: 'Gagal memuat',
                        subtitle: _produkController.errorList.value,
                        icon: Icons.error_outline,
                      );
                    }

                    // Calculate filtered products inside Obx
                    final displayProducts = _getFilteredProducts();

                    // Check if search has no results
                    if (_searchQuery.isNotEmpty && displayProducts.isEmpty) {
                      return const EmptyState(
                        title: 'Produk tidak ditemukan',
                        subtitle: 'Coba kata kunci lain',
                        icon: Icons.search_off,
                      );
                    }

                    // Check if there are no products at all
                    if (_produkController.list.isEmpty) {
                      return const EmptyState(
                        title: 'Belum ada produk',
                        subtitle: 'Tambah produk terlebih dahulu',
                        icon: Icons.inventory_2_outlined,
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
                        return Obx(() => ProductCard(
                              cardColor: _isProductInCart(product)
                                  ? const Color(0xFFD9D9D9)
                                  : Colors.white,
                              produk: product,
                              onTap: () => _onProductTap(product),
                            ));
                      },
                    );
                  }),
                ),
              ],
            ),

            // Cart Bottom Sheet with Notes
            Obx(() {
              if (_keranjangController.product.isNotEmpty) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated Notes Container
                      AnimatedContainer(
                        margin: const EdgeInsets.symmetric(horizontal: 70),
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.only(
                          top: 2,
                          right: 15,
                          left: 15,
                          bottom: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, -2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Price Row with Expand Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Notes",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(_expanded
                                      ? Icons.expand_less
                                      : Icons.expand_more),
                                  onPressed: () {
                                    setState(() {
                                      _expanded = !_expanded;
                                    });
                                  },
                                ),
                              ],
                            ),
                            // Animated note field
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: _expanded
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0, top: 5),
                                      child: TextField(
                                        controller: _keranjangController
                                            .notesController,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText:
                                              'Catatan untuk pesanan Anda',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(8),
                                        ),
                                        maxLines: 3,
                                        onChanged: (value) {
                                          // Note value automatically saved in controller
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),

                      // Save Button
                      Container(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => PembayaranModal(
                                controller: _keranjangController,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LightThemeColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart,
                                  color: Colors.white),
                              const SizedBox(width: 8.0),
                              Text(
                                'Rp.${_keranjangController.totalPrice.toStringAsFixed(0)}  |  ${_keranjangController.totalItems.toStringAsFixed(0)} Item',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
