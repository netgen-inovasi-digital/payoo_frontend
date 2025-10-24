import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/app/modules/pembelian/views/widget/pembelian_info.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/modules/stok/views/widgets/stok_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PembelianDetailView extends StatelessWidget {
  final Stock stok;

  const PembelianDetailView({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pembelian',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PembelianInfo(stok: stok),
            const SizedBox(height: 28),
            // Tombol aksi
            
          ],
        ),
      ),
    );
  }
}
