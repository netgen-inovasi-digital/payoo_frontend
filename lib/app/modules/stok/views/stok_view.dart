import 'package:get/get.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_footer_clip_path.dart';
import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/modules/stok/views/stok_form_view.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'widgets/list_view_stok.dart';
import 'package:flutter/material.dart';

class StokView extends StatefulWidget {
  const StokView({super.key});

  @override
  State<StokView> createState() => _StokViewState();
}

class _StokViewState extends State<StokView> {
  late final TextEditingController _searchController;
  late final StokController _stokController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _stokController = Get.put(StokController());
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stokController.fetchStockList();
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
        title: 'Manajemen Stok',
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
                    _stokController.searchStokList(search: _searchController.text);
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
                        _stokController.loadMoreStocks();
                      }
                      return false;
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ListViewStok(
                            stokList: _stokController.listStock,
                          ),
                        ),
                        if (_stokController.isLoadingMore.value)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
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
                      onPressed: () async{
                        final result = await Get.to(() => const StokFormView());
                        if (result == true) {
                          _stokController.fetchStockList(refresh: true);
                        }},
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