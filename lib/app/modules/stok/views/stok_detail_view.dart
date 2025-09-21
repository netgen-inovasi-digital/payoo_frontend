import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/modules/stok/views/widgets/stok_info.dart';
import 'stok_form_view.dart';
import 'widgets/stok_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StokDetailView extends StatelessWidget {
  final Komposisi stok;

  const StokDetailView({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
