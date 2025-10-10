import 'package:get/get.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'widgets/list_view_stok.dart';
import 'package:flutter/material.dart';

class StokView extends StatefulWidget {
  const StokView({super.key});

  @override
  State<StokView> createState() => _StokViewState();
}

class _StokViewState extends State<StokView> {
  late TextEditingController _searchController;
  late StokController stokController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    stokController = Get.put(StokController());
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stokController.fetchProductsWithStock();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when returning to this page
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (stokController.productsStock.isEmpty) {
          stokController.fetchProductsWithStock();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      // Search filtering is handled in the build method directly
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Manajemen Stok',
        onPressed: () => Get.back(),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: SearchInputField(
              verticalPadding: 15,
              controller: _searchController,
              onSearchChanged: _filterProducts,
              hintText: 'Cari produk (nama)',
            ),
          ),
          // List Stok
          Expanded(
            child: Obx(
              () {
                if (stokController.statusProductsStock.value ==
                    ApiCallStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (stokController.statusProductsStock.value ==
                    ApiCallStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Terjadi kesalahan saat memuat data',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stokController.errorProductsStock.value,
                          style: const TextStyle(fontSize: 14, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => stokController.fetchProductsWithStock(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }
                final productsList = stokController.productsStock;
                final filteredList = productsList.where((item) {
                  final searchTerm = _searchController.text.toLowerCase();
                  return item.name.toLowerCase().contains(searchTerm);
                }).toList();

                if (filteredList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Data produk tidak ditemukan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                }

              return ListViewStok(stokList: filteredList);
              },
            ),
          ),
        ],
      ),
    );
  }
}
