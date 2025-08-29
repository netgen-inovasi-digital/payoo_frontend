import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/empty_state.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/komposisi/controllers/komposisi_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/modules/komposisi/views/detail_komposisi_view.dart';
import 'package:payoo/app/modules/komposisi/views/tambah_komposisi_view.dart';
import 'package:payoo/app/components/komposisi_card.dart';
import 'package:payoo/config/theme/light_theme.dart';

class KomposisiView extends StatefulWidget {
  const KomposisiView({super.key});

  @override
  State<KomposisiView> createState() => _KomposisiViewState();
}

class _KomposisiViewState extends State<KomposisiView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final KomposisiController controller = Get.find<KomposisiController>();

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

  void _onKomposisiTap(Komposisi komposisi) {
    Get.to(() => DetailKomposisiView(komposisi: komposisi));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Data Komposisi'),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(45.0, 30.0, 45.0, 20.0),
                child: SearchInputField(
                  verticalPadding: 15,
                  controller: _searchController,
                  onSearchChanged: _filterKomposisi,
                  hintText: 'Cari komposisi (nama)',
                ),
              ),
              // Tampilkan hasil pencarian atau pesan jika tidak ada hasil
              Expanded(
                child: Obx(() {
                  final isLoading = controller.statusList.value == ApiCallStatus.loading;
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.statusList.value == ApiCallStatus.error) {
                    return EmptyState(
                      title: 'Gagal memuat',
                      subtitle: controller.errorList.value,
                      icon: Icons.error_outline,
                    );
                  }
                  // Filter
                  final filtered = controller.list.where((k) =>
                      k.namaKomposisi.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                  if (_searchQuery.isNotEmpty && filtered.isEmpty) {
                    return const EmptyState(
                      title: 'Komposisi tidak ditemukan',
                      subtitle: 'Coba kata kunci lain',
                      icon: Icons.search_off,
                    );
                  }
                  if (filtered.isEmpty) {
                    return const EmptyState(
                      title: 'Belum ada komposisi',
                      subtitle: 'Tambah komposisi baru',
                      icon: Icons.inventory_2_outlined,
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 120.0),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final komposisi = filtered[index];
                      return KomposisiCard(
                        komposisi: komposisi,
                        onTap: () => _onKomposisiTap(komposisi),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          elevation: 3,
          foregroundColor: LightThemeColors.primaryColor,
          backgroundColor: LightThemeColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            ),
          onPressed: () {
            controller.resetCreateForm();
            Get.to(()=>TambahKomposisiView());
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}