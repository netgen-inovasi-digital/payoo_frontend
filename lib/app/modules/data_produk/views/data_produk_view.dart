import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_footer_clip_path.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/empty_state.dart';
import 'package:payoo/app/components/product_card.dart';
import 'package:payoo/app/modules/data_produk/views/detail_produk_view.dart';
import 'package:payoo/app/modules/data_produk/views/tambah_produk_view.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';

class DataProdukView extends StatefulWidget {
  const DataProdukView({super.key});

  @override
  State<DataProdukView> createState() => _DataProdukViewState();
}

class _DataProdukViewState extends State<DataProdukView> {
  final TextEditingController _searchController = TextEditingController();
  late final ProdukController _produkController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    
    // Initialize controller properly
    if (Get.isRegistered<ProdukController>()) {
      _produkController = Get.find<ProdukController>();
    } else {
      _produkController = Get.put<ProdukController>(ProdukController());
    }
    
    // Fetch products only if list is empty
    if (_produkController.list.isEmpty) {
      _produkController.fetchProduk();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    // DON'T delete the controller here - let GetX manage it
    // or delete it only if you created it
    super.dispose();
  }

  Future<void> _refreshData() async {
    await _produkController.fetchProduk();
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

  void _onProductTap(Produk product) async {
    final result = await Get.to(() => DetailProdukView(produkId: product.id));

    if (result == true && mounted) {
      _refreshData();
    }
  }

  Future<void> _onAddProductTap() async {
    final result = await Get.to(() => const TambahProdukView());

    if (result == true && mounted) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Data Produk',
        dividerLine: false,
        onPressed: () => Get.toNamed(Routes.PRODUK),
      ),
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
                    hintText: 'Cari produk (nama)',
                  ),
                ),
                Container(
                  height: 1.0,
                  color: const Color(0xFFFF9781),
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
                        subtitle: 'Tambah produk pertama Anda',
                        icon: Icons.inventory_2_outlined,
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120.0),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
                        return ProductCard(
                          produk: product,
                          onTap: () => _onProductTap(product),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomFooterClipPath(
                height: 80,
                strokeWidth: 10,
                children: [
                  FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: _onAddProductTap,
                    backgroundColor: Colors.white,
                    elevation: 4,
                    child: const Icon(
                      Icons.add,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}