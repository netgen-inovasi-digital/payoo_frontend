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
import 'package:payoo/app/routes/app_pages.dart';

class KomposisiView extends StatefulWidget {
  const KomposisiView({super.key});

  @override
  State<KomposisiView> createState() => _KomposisiViewState();
}

class _KomposisiViewState extends State<KomposisiView> {
  final TextEditingController _searchController = TextEditingController();
  late final KomposisiController controller;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    
    // Initialize controller properly
    if (Get.isRegistered<KomposisiController>()) {
      controller = Get.find<KomposisiController>();
    } else {
      controller = Get.put<KomposisiController>(KomposisiController());
    }
    
    // Fetch komposisi only if list is empty
    if (controller.list.isEmpty) {
      controller.fetchKomposisi();
    }
  }

  Future<void> _refreshData() async {
    await controller.fetchKomposisi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Komposisi> _getFilteredKomposisi() {
    if (_searchQuery.isEmpty) {
      return controller.list;
    } else {
      return controller.list.where((k) {
        return k.namaKomposisi.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onKomposisiTap(Komposisi komposisi) async {
    final result = await Get.to(() => DetailKomposisiView(komposisi: komposisi));
    
    if (result == true && mounted) {
      _refreshData();
    }
  }

  Future<void> _onAddKomposisiTap() async {
    controller.resetCreateForm();
    final result = await Get.to(() => const TambahKomposisiView());
    
    if (result == true && mounted) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Data Komposisi', 
        onPressed: () => Get.toNamed(Routes.PRODUK),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(45.0, 30.0, 45.0, 20.0),
                  child: SearchInputField(
                    verticalPadding: 15,
                    controller: _searchController,
                    onSearchChanged: _onSearchChanged,
                    hintText: 'Cari komposisi (nama)',
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.statusList.value == ApiCallStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (controller.statusList.value == ApiCallStatus.error) {
                      return EmptyState(
                        title: 'Gagal memuat',
                        subtitle: controller.errorList.value,
                        icon: Icons.error_outline,
                      );
                    }

                    // Calculate filtered komposisi inside Obx
                    final displayKomposisi = _getFilteredKomposisi();

                    // Check if search has no results
                    if (_searchQuery.isNotEmpty && displayKomposisi.isEmpty) {
                      return const EmptyState(
                        title: 'Komposisi tidak ditemukan',
                        subtitle: 'Coba kata kunci lain',
                        icon: Icons.search_off,
                      );
                    }

                    // Check if there are no komposisi at all
                    if (controller.list.isEmpty) {
                      return const EmptyState(
                        title: 'Belum ada komposisi',
                        subtitle: 'Tambah komposisi baru',
                        icon: Icons.inventory_2_outlined,
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120.0),
                      itemCount: displayKomposisi.length,
                      itemBuilder: (context, index) {
                        final komposisi = displayKomposisi[index];
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
          onPressed: _onAddKomposisiTap,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}