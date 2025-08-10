import 'package:payoo/app/components/custom_app_bar_secondary.dart';

import 'widgets/list_view_stok.dart';
import 'package:payoo/app/components/custom_text_field.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StokView extends StatelessWidget {
  const StokView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final List<Map<String, dynamic>> stokList = [
      {
        'nama': 'Roti',
        'harga': 3000,
        'hargaModal': 2500,
        'stok': 20,
      },
      {
        'nama': 'Daging',
        'harga': 7000,
        'hargaModal': 5000,
        'stok': 20,
      },
      {
        'nama': 'Keju',
        'harga': 3000,
        'hargaModal': 2000,
        'stok': 20,
      },
    ];

    return Scaffold(
      appBar: const CustomAppBarSecondary(
        title: 'Manajemen Stok',
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: CustomTextField(
              hintText: 'cari komposisi produk',
              controller: searchController,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              width: 350,
            ),
          ),
          // List Stok
          Expanded(
            child: ListViewStok(stokList: stokList),
          ),
        ],
      ),
    );
  }
}
