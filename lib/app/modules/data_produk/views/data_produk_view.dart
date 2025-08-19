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
import 'package:payoo/app/modules/data_produk/views/detail_produk_view.dart';
import 'package:payoo/app/modules/data_produk/views/tambah_produk_view.dart';
import 'package:payoo/app/routes/app_pages.dart';

class DataProdukView extends StatefulWidget {
  const DataProdukView({super.key});

  @override
  State<DataProdukView> createState() => _DataProdukViewState();
}

class _DataProdukViewState extends State<DataProdukView> {
  final TextEditingController _searchController = TextEditingController();
  List<Produk> _filteredProducts = [];
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
    Get.to(() => DetailProdukView(produk: product));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Data Produk', dividerLine: false),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 120.0, 
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(
                        produk: product,
                        onTap: () => _onProductTap(product),
                      );
                    },
                  ),
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
                  onPressed: () {
                  Get.to(() => const TambahProdukView());
                  },
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
    );
  }
}