import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/SearchInputField.dart';
import 'package:payoo/app/components/empty_state.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/komposisi/views/detail_komposisi_view.dart';
import 'package:payoo/app/modules/komposisi/views/tambah_komposisi_view.dart';
import 'package:payoo/app/components/komposisi_card.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class KomposisiView extends StatefulWidget {
  const KomposisiView({super.key});

  @override
  State<KomposisiView> createState() => _KomposisiViewState();
}

class _KomposisiViewState extends State<KomposisiView> {
  final TextEditingController _searchController = TextEditingController();
  List<Komposisi> _filteredKomposisi = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredKomposisi = komposisiList; 
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterKomposisi(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredKomposisi = komposisiList;
      } else {
        _filteredKomposisi = komposisiList.where((komposisi) {
          return komposisi.namaKomposisi.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
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
              if (_searchQuery.isNotEmpty && _filteredKomposisi.isEmpty)
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
                    itemCount: _filteredKomposisi.length,
                    itemBuilder: (context, index) {
                      final komposisi = _filteredKomposisi[index];
                      return KomposisiCard(
                        komposisi: komposisi,
                        onTap: () => _onKomposisiTap(komposisi),
                      );
                    },
                  ),
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
            Get.to(()=>TambahKomposisiView());
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}