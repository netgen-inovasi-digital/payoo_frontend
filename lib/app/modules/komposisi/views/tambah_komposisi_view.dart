import 'package:flutter/material.dart';

import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/komposisi/controllers/komposisi_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';

class TambahKomposisiView extends StatelessWidget {
  TambahKomposisiView({super.key, this.komposisi});
  final Komposisi? komposisi;
  final KomposisiController controller = Get.find<KomposisiController>();

  @override
  Widget build(BuildContext context) {
  if (komposisi != null) {
    controller.namaController.text = komposisi!.namaKomposisi;
    controller.hargaModalController.text = komposisi!.hargaModal.toString();
    controller.hargaJualController.text = komposisi!.hargaJual.toString();
    controller.satuanController.text = komposisi!.satuan;
  }
    return Scaffold(
      appBar: CustomAppBar(
        title: komposisi != null ? 'Edit Komposisi' : 'Tambah Komposisi'
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            CustomTextField(
              hintText: 'nama komposisi*',
              controller: controller.namaController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'harga modal*',
              controller: controller.hargaModalController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'harga jual*',
              controller: controller.hargaJualController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'satuan',
              controller: controller.satuanController,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
              child: Obx(() {
                final isLoading = controller.statusCreate.value == ApiCallStatus.loading ||
                    controller.statusUpdate.value == ApiCallStatus.loading;
                return CustomSaveButton(
                  onPressed: () {
                    if (isLoading) return; // guard
                    _handleSave();
                  },
                  label: isLoading
                      ? 'Menyimpan...'
                      : komposisi != null ? 'Update' : 'Simpan',
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (komposisi == null) {
      final ok = await controller.createKomposisi();
      if (ok) {
        Get.toNamed(Routes.KOMPOSISI);
        Get.snackbar('Sukses', 'Komposisi dibuat');
      } else {
        Get.snackbar('Gagal', controller.errorCreate.value, snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      // Update existing komposisi
      final ok = await controller.updateKomposisi(komposisi!.id);
      if (ok) {
        Get.toNamed(Routes.KOMPOSISI);
        Get.snackbar('Sukses', 'Komposisi diperbarui');
      } else {
        Get.snackbar('Gagal', controller.errorUpdate.value, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}