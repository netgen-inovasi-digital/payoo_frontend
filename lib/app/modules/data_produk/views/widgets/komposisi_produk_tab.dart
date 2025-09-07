// File: lib/app/modules/data_produk/views/widgets/komposisi_produk_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/components/komposisi_card.dart';
import 'package:payoo/app/modules/komposisi/controllers/komposisi_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';

class KomposisiProdukTab extends StatefulWidget {
  final List<Komposisi> komposisi;
  final Function(List<Komposisi>)? onKomposisiChanged;
  
  const KomposisiProdukTab({
    super.key, 
    required this.komposisi,
    this.onKomposisiChanged,
  });
  
  @override
  State<KomposisiProdukTab> createState() => _KomposisiProdukTabState();
}

class _KomposisiProdukTabState extends State<KomposisiProdukTab> {
  late List<Komposisi> selectedKomposisi;
  final KomposisiController komposisiController = Get.put<KomposisiController>(KomposisiController());
  String? selectedKomposisiName;

  @override
  void initState() {
    super.initState();
    selectedKomposisi = List.from(widget.komposisi);
    
    // Fetch komposisi data if not already loaded
    if (komposisiController.list.isEmpty) {
      komposisiController.fetchKomposisi();
    }
  }

  void _addKomposisi(Komposisi komposisi) {
    if (!selectedKomposisi.any((k) => k.id == komposisi.id)) {
      setState(() {
        selectedKomposisi.add(komposisi);
      });
      widget.onKomposisiChanged?.call(selectedKomposisi);
    }
  }

  void _removeKomposisi(int komposisiId) {
    setState(() {
      selectedKomposisi.removeWhere((k) => k.id == komposisiId);
    });
    widget.onKomposisiChanged?.call(selectedKomposisi);
  }

  List<Komposisi> _getAvailableKomposisi(List<Komposisi> allKomposisi) {
    return allKomposisi
        .where((k) => !selectedKomposisi.any((s) => s.id == k.id))
        .toList();
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
          child: selectedKomposisi.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada komposisi dipilih',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pilih komposisi dari dropdown di atas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: selectedKomposisi.length,
                itemBuilder: (context, index) {
                  final komposisi = selectedKomposisi[index];
                  return Dismissible(
                    key: Key(komposisi.id.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
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
                        onTap: () => _removeKomposisi(komposisi.id),
                      ),
                    ),
                  );
                },
              ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSaveButton(
            onPressed: () {
              // Update parent with selected komposisi
              widget.onKomposisiChanged?.call(selectedKomposisi);
              
              Get.snackbar(
                'Berhasil',
                '${selectedKomposisi.length} komposisi dipilih',
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
    // Handle loading state
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
            Text(
              'Memuat komposisi...',
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      );
    }

    // Handle error state
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

    // Get available komposisi (not already selected)
    final available = _getAvailableKomposisi(komposisiController.list);
    
    // Handle empty state
    if (available.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          available.isEmpty && komposisiController.list.isNotEmpty
              ? 'Semua komposisi sudah dipilih'
              : 'Tidak ada komposisi tersedia',
          style: TextStyle(color: Colors.grey[500], fontSize: 15),
        ),
      );
    }

    // Normal dropdown with data
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
          hint: Text(
            'Pilih Komposisi Produk',
            style: TextStyle(color: Colors.grey[500], fontSize: 15),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
          items: available.map((Komposisi komposisi) {
            return DropdownMenuItem<String>(
              value: komposisi.namaKomposisi,
              child: Text(
                komposisi.namaKomposisi,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              final selected = available.firstWhere((k) => k.namaKomposisi == newValue);
              _addKomposisi(selected);
              setState(() {
                selectedKomposisiName = null; // Reset dropdown
              });
            }
          },
        ),
      ),
    );
  }
  }