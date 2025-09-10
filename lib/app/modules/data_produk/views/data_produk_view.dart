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
import 'package:payoo/app/services/api_call_status.dart';

class DataProdukView extends StatefulWidget {
  const DataProdukView({super.key});

  @override
  State<DataProdukView> createState() => _DataProdukViewState();
}

class _DataProdukViewState extends State<DataProdukView> {
  final TextEditingController _searchController = TextEditingController();
  final ProdukController _produkController = Get.put<ProdukController>(ProdukController());
  List<Produk> _filteredProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Refresh data when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await _produkController.fetchProduk();
    _filterProducts(_searchQuery);
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = List.from(_produkController.list);
      } else {
        _filteredProducts = _produkController.list.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onProductTap(Produk product) async {
    // Navigate to detail view and wait for result
    final result = await Get.to(() => DetailProdukView(produkId: product.id));
    
    // Refresh data when returning from detail view
    if (result == true || mounted) {
      _refreshData();
    }
  }

  Future<void> _onAddProductTap() async {
    // Navigate to add product view and wait for result
    final result = await Get.to(() => const TambahProdukView());
    
    // Refresh data when returning from add product view
    if (result == true || mounted) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Data Produk', dividerLine: false),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: SearchInputField(
                    controller: _searchController,
                    onSearchChanged: _filterProducts,
                    hintText: 'Cari produk (nama)',
                  ),
                ),
                Container(
                  height: 1.0,
                  color: const Color(0xFFFF9781),
                ),
                // Tampilkan hasil pencarian atau pesan jika tidak ada hasil
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
                    child: Obx(() {
                      if (_produkController.statusList.value == ApiCallStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (_produkController.statusList.value == ApiCallStatus.error) {
                        return EmptyState(
                          title: 'Gagal memuat',
                          subtitle: _produkController.errorList.value,
                          icon: Icons.error_outline,
                        );
                      }

                      // Update filtered products when the main list changes
                      final produkList = _produkController.list;
                      if (_searchQuery.isEmpty) {
                        _filteredProducts = List.from(produkList);
                      } else {
                        _filteredProducts = produkList.where((product) {
                          return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
                        }).toList();
                      }

                      if (_filteredProducts.isEmpty && produkList.isNotEmpty && _searchQuery.isEmpty) {
                        return const EmptyState(
                          title: 'Belum ada produk',
                          subtitle: 'Tambah produk pertama Anda',
                          icon: Icons.inventory_2_outlined,
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 120.0),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
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
            // Footer overlay at bottom
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