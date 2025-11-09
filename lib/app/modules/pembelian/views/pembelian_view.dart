import 'package:get/get.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_footer_clip_path.dart';
import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/app/modules/pembelian/views/Pembelian_form_view.dart';
import 'package:payoo/app/modules/pembelian/views/widget/list_view_pembelian.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:flutter/material.dart';

class PembelianView extends StatefulWidget {
  const PembelianView({super.key});

  @override
  State<PembelianView> createState() => _PembelianViewState();
}

class _PembelianViewState extends State<PembelianView> {
  late final TextEditingController _searchController;
  late final StokController _stokController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _stokController = Get.put(StokController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stokController.fetchStockList(pembelian: true, refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pembelian',
        onPressed: () => Get.back(),
      ),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: SearchInputField(
                  verticalPadding: 15,
                  controller: _searchController,
                  onSearchChanged: (_) {
                    _stokController.searchStokList(
                        search: _searchController.text);
                  },
                  hintText: 'Cari produk (nama)',
                ),
              ),
              // List Stok
              Expanded(
                child: Obx(() {
                  final status = _stokController.statusListStock.value;
                  if (status == ApiCallStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (status == ApiCallStatus.error) {
                    return _buildErrorState();
                  }
                  if (_stokController.listStock.isEmpty) {
                    return _buildEmptyState();
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 200 &&
                          !_stokController.isLoadingMore.value &&
                          _stokController.hasMoreData.value) {
                        _stokController.loadMoreStocks(pembelian: true);
                      }
                      return false;
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ListViewPembelian(
                            stokList: _stokController.listStock,
                          ),
                        ),
                        if (_stokController.isLoadingMore.value)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomFooterClipPath(
                  height: 80,
                  strokeWidth: 10,
                  children: [
                    FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () async {
                        final result = await Get.to(() => const PembelianFormView());
                        if (result == true) {
                          _stokController.fetchStockList(
                              pembelian: true, refresh: true);
                        }
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
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
            _stokController.errorProductsStock.value,
            style: const TextStyle(fontSize: 14, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _stokController.fetchStockList(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Data stok tidak ditemukan',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
