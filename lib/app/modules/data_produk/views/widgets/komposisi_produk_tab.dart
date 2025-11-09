  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:payoo/app/components/custom_save_button.dart';
  import 'package:payoo/app/data/models/komposisi_model.dart';
  import 'package:payoo/app/components/komposisi_card.dart';
  import 'package:payoo/app/modules/komposisi/controllers/komposisi_controller.dart';
  import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
  import 'package:payoo/app/services/api_call_status.dart';

  class KomposisiProdukTab extends StatefulWidget {
    final List<Komposisi> komposisi;
    
    const KomposisiProdukTab({
      super.key, 
      required this.komposisi,
    });
    
    @override
    State<KomposisiProdukTab> createState() => _KomposisiProdukTabState();
  }

  class _KomposisiProdukTabState extends State<KomposisiProdukTab> {
    final KomposisiController komposisiController = Get.put<KomposisiController>(KomposisiController());
    late final ProdukController produkController;
    String? selectedKomposisiName;

    @override
    void initState() {
      super.initState();
      
      // Initialize produk controller
      if (Get.isRegistered<ProdukController>()) {
        produkController = Get.find<ProdukController>();
      } else {
        produkController = Get.put<ProdukController>(ProdukController());
      }
      
      // Fetch komposisi data if not already loaded
      if (komposisiController.list.isEmpty) {
        komposisiController.fetchKomposisi();
      }
    }

  void _addKomposisi(Komposisi komposisi) {
    // Check if not already in controller's list
    if (!produkController.selectedKomposisi.any((k) => k.id == komposisi.id)) {
      // Set initial quantity to 1
      komposisi.quantity = 1;
      produkController.addKomposisi(komposisi);
      // Reset dropdown selection after adding
      if (mounted) {
        setState(() {
          selectedKomposisiName = null;
        });
      }
    }
  }    void _removeKomposisi(int komposisiId) {
      final removed = produkController.selectedKomposisi.firstWhereOrNull((k) => k.id == komposisiId);
      if (removed != null) {
        produkController.removeKomposisi(removed);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Obx(() => _buildKomposisiDropdown()),
          ),
          
          Expanded(
            child: Obx(() {
              final selectedKomposisi = produkController.selectedKomposisi;
              
              return selectedKomposisi.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada komposisi dipilih',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Pilih komposisi dari dropdown di atas',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: selectedKomposisi.length,
                    itemBuilder: (context, index) {
                      final komposisi = selectedKomposisi[index];
                      return Dismissible(
                        key: Key('komposisi_${komposisi.id}_$index'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _removeKomposisi(komposisi.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${komposisi.namaKomposisi} dihapus'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () => _addKomposisi(komposisi),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: KomposisiCard(
                            komposisi: komposisi,
                            useQuantities: true,
                            onQuantityZero: (komposisi) {
                              _removeKomposisi(komposisi.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${komposisi.namaKomposisi} dihapus'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () => _addKomposisi(komposisi),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
            }),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSaveButton(
              onPressed: () {
                Get.snackbar(
                  'Berhasil',
                  '${produkController.selectedKomposisi.length} komposisi dipilih',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              label: 'SIMPAN',
            ),
          ),
        ],
      );
    }

    Widget _buildKomposisiDropdown() {
      if (komposisiController.statusList.value == ApiCallStatus.loading) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Memuat komposisi...', style: TextStyle(color: Colors.grey[500], fontSize: 15)),
              const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
        );
      }

      if (komposisiController.statusList.value == ApiCallStatus.error) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Error: ${komposisiController.errorList.value}',
                  style: TextStyle(color: Colors.red[600], fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => komposisiController.fetchKomposisi(),
                child: Icon(Icons.refresh, color: Colors.red[600], size: 20),
              ),
            ],
          ),
        );
      }

      // Calculate available komposisi outside of widget tree
      final allKomposisi = komposisiController.list;
      final selectedIds = produkController.selectedKomposisi.map((k) => k.id).toSet();
      final available = allKomposisi.where((k) => !selectedIds.contains(k.id)).toList();
      
      if (available.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            allKomposisi.isNotEmpty
                ? 'Semua komposisi sudah dipilih'
                : 'Tidak ada komposisi tersedia',
            style: TextStyle(color: Colors.grey[500], fontSize: 15),
          ),
        );
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedKomposisiName,
            hint: Text('Pilih Komposisi Produk', style: TextStyle(color: Colors.grey[500], fontSize: 15)),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
            items: available.map((Komposisi komposisi) {
              return DropdownMenuItem<String>(
                value: komposisi.namaKomposisi,
                child: Text(komposisi.namaKomposisi, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                final selected = available.firstWhereOrNull((k) => k.namaKomposisi == newValue);
                if (selected != null) {
                  _addKomposisi(selected);
                }
              }
            },
          ),
        ),
      );
    }
  }