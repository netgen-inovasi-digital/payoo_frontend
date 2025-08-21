import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/CustomFooterClipPath.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_app_bar_clip_path.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/empty_state.dart';
import 'package:payoo/app/components/product_card.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  final TextEditingController _searchController = TextEditingController();
  List<Produk> _filteredProducts = [];
  List<Produk> _cartItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredProducts = ProdukList;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = ProdukList;
      } else {
        _filteredProducts = ProdukList.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onProductTap(Produk product) {
    setState(() {
      if (!_cartItems.contains(product)) {
        _cartItems.add(product);
      } else {
        _cartItems.remove(product);
      }
    });
  }

  double get _totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Transaksi', dividerLine: false),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: SearchInputField(
                  controller: _searchController,
                  onSearchChanged: _filterProducts,
                  hintText: 'cari produk (kode | nama)',
                ),
              ),
              Container(
                height: 1.0,
                color: LightThemeColors.accentColor,
              ),
              if (_searchQuery.isNotEmpty && _filteredProducts.isEmpty)
                const Expanded(
                  child: EmptyState(
                    title: 'Produk tidak ditemukan',
                    subtitle: 'Coba kata kunci lain',
                    icon: Icons.search_off,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 100.0,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(
                        cardColor: _cartItems.contains(product)
                            ? const Color(0xFFD9D9D9)
                            : Colors.white,
                        produk: product,
                        onTap: () => _onProductTap(product),
                      );
                    },
                  ),
                ),
            ],
          ),
          // Cart Bottom Sheet
          if (_cartItems.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    // ✅ OPTION 1: Register controller if not exists
                    KeranjangController keranjangController;
                    
                    try {
                      keranjangController = Get.find<KeranjangController>();
                    } catch (e) {
                      // Controller not found, create it
                      keranjangController = Get.put(KeranjangController());
                    }

                    // Clear existing items first
                    keranjangController.clearCart();

                    // Add selected items to controller
                    for (var item in _cartItems) {
                      keranjangController.addProduct(item);
                    }

                    // Navigate to keranjang
                    Get.toNamed(Routes.KERANJANG);
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
                      const Icon(Icons.shopping_cart, color: Colors.white),
                      const SizedBox(width: 8.0),
                      Text(
                        'Rp.${_totalPrice.toStringAsFixed(0)}  |  ${_cartItems.length} Item',
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
            ),
        ],
      ),
    );
  }
}