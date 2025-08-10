import 'package:payoo/app/components/custom_app_bar_secondary.dart';
import 'package:payoo/app/modules/stok/views/widgets/stok_info.dart';
import 'stok_form_view.dart';
import 'widgets/stok_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StokDetailView extends StatelessWidget {
  final Map<String, dynamic> stok;

  const StokDetailView({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSecondary(
        title: 'Manajemen Stok',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StokInfo(stok: stok),
            const SizedBox(height: 28),
            // Tombol aksi
            Column(
              children: [
                StokActionButton(
                  label: 'tambah / kurangi stok',
                  margin: const EdgeInsets.only(bottom: 16),
                  onTap: () {
                    Get.to(() => StokFormView(stok: stok));
                  },
                ),
                StokActionButton(
                  label: 'edit / lihat stok',
                  onTap: () {
                    Get.to(() => StokFormView(stok: stok));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
