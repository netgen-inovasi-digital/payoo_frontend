import 'package:get/get.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/custom_app_bar_secondary.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/komposisi/controllers/komposisi_controller.dart';
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
  late KomposisiController komposisiController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    komposisiController = Get.put(KomposisiController());
    komposisiController.fetchKomposisi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterKomposisi(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSecondary(
        title: 'Manajemen Stok',
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: SearchInputField(
              verticalPadding: 15,
              controller: _searchController,
              onSearchChanged: _filterKomposisi,
              hintText: 'Cari komposisi (nama)',
            ),
          ),
          // List Stok
          Expanded(
            child: Obx(
              () {
                if (komposisiController.statusList.value ==
                    ApiCallStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (komposisiController.statusList.value ==
                    ApiCallStatus.error) {
                  return const Center(
                    child: Text(
                      'Terjadi kesalahan saat memuat data',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                final stokList = komposisiController.list;
                final filteredList = stokList.where((item) {
                  final searchTerm = _searchController.text.toLowerCase();
                  return item.namaKomposisi.toLowerCase().contains(searchTerm);
                }).toList();

                if (filteredList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Data komposisi tidak ditemukan',
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
