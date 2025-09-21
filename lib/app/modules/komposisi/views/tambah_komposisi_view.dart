import 'package:flutter/material.dart';

import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_snackbar.dart';
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
            Obx(() => CustomTextField(
              hintText: 'Nama komposisi*',
              controller: controller.namaController,
              hasError: controller.hasAttemptedSubmit.value && 
                       controller.namaError.value.isNotEmpty,
              errorText: controller.namaError.value,
            )),
            const SizedBox(height: 16),
            Obx(() => CustomTextField(
              hintText: 'Harga modal*',
              controller: controller.hargaModalController,
              keyboardType: TextInputType.number,
              hasError: controller.hasAttemptedSubmit.value && 
                       controller.hargaModalError.value.isNotEmpty,
              errorText: controller.hargaModalError.value,
            )),
            const SizedBox(height: 16),
            Obx(() => CustomTextField(
              hintText: 'Harga jual*',
              controller: controller.hargaJualController,
              keyboardType: TextInputType.number,
              hasError: controller.hasAttemptedSubmit.value && 
                       controller.hargaJualError.value.isNotEmpty,
              errorText: controller.hargaJualError.value,
            )),
            const SizedBox(height: 16),
            Obx(() => CustomTextField(
              hintText: 'Satuan',
              controller: controller.satuanController,
              hasError: controller.hasAttemptedSubmit.value && 
                       controller.satuanError.value.isNotEmpty,
              errorText: controller.satuanError.value,
            )),
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
        CustomSnackBar.showCustomSnackBar(
          title: 'Sukses', 
          message: 'Komposisi berhasil dibuat'
        );
      } else {
        // Check if it's a validation error or API error
        if (controller.errorCreate.value.isNotEmpty) {
          CustomSnackBar.showCustomErrorSnackBar(
            title: 'Gagal Membuat', 
            message: controller.errorCreate.value
          );
        }
      }
    } else {
      // Update existing komposisi
      final ok = await controller.updateKomposisi(komposisi!.id);
      if (ok) {
        Get.toNamed(Routes.KOMPOSISI);
        CustomSnackBar.showCustomSnackBar(
          title: 'Sukses', 
          message: 'Komposisi berhasil diperbarui'
        );
        } else {
          // Check if it's a validation error or API error
          if (controller.namaError.value.isNotEmpty || 
              controller.hargaModalError.value.isNotEmpty ||
              controller.hargaJualError.value.isNotEmpty ||
              controller.satuanError.value.isNotEmpty) {
            CustomSnackBar.showCustomErrorSnackBar(
              title: 'Form Tidak Valid', 
              message: 'Mohon periksa kembali data yang Anda masukkan'
            );
          } else if (controller.errorUpdate.value.isNotEmpty) {
            CustomSnackBar.showCustomErrorSnackBar(
              title: 'Gagal Memperbarui', 
              message: controller.errorUpdate.value
            );
          }
      }
    }
  }
}