// File: lib/app/modules/data_produk/views/tambah_produk_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/data_produk/views/widgets/komposisi_produk_tab.dart';
import 'package:payoo/app/modules/data_produk/views/widgets/tambah_produk_tab.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';

class TambahProdukView extends StatefulWidget {
  final bool isEdit;
  const TambahProdukView({super.key, this.isEdit = false});

  @override
  State<TambahProdukView> createState() => _TambahProdukViewState();
}

class _TambahProdukViewState extends State<TambahProdukView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProdukController controller = Get.find<ProdukController>();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // update warna tab
    });
    
    // Initialize controller's komposisi if needed
    if (widget.isEdit && controller.produk.value != null) {
      // Load existing komposisi from product if needed
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Callback untuk navigate ke tab komposisi dari tab tambah produk
  void goToKomposisiTab() {
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Produk' : 'Tambah Produk'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Tab Bar custom
          Row(
            children: [
              _buildTabButton(0, 'Tambah Produk'),
              const SizedBox(width: 8),
              _buildTabButton(1, 'Komposisi Produk'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TambahProdukTab(
                  isEdit: widget.isEdit,
                  onNextTab: goToKomposisiTab,
                ),
                KomposisiProdukTab(
                  komposisi: controller.selectedKomposisi,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabController.animateTo(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: _tabController.index == index ? Colors.green : Colors.transparent,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _tabController.index == index ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
