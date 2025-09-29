import 'package:flutter/material.dart';

import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_dropdown.dart';
import 'package:payoo/app/components/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/komposisi/controllers/komposisi_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';

class TambahKomposisiView extends StatefulWidget {
  const TambahKomposisiView({super.key, this.komposisi});
  final Komposisi? komposisi;

  @override
  State<TambahKomposisiView> createState() => _TambahKomposisiViewState();
}

class _TambahKomposisiViewState extends State<TambahKomposisiView> {
  final KomposisiController controller = Get.find<KomposisiController>();

  // Data satuan static enum
  final List<String> satuanOptions = const [
    'pcs',
    'gr', 
    'kg',
    'ml',
    'liter',
    'lembar',
    'slice',
    'butir',
    'pack',
    'botol'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize form data if editing
    if (widget.komposisi != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.namaController.text = widget.komposisi!.namaKomposisi;
        controller.hargaModalController.text = widget.komposisi!.hargaModal.toString();
        controller.hargaJualController.text = widget.komposisi!.hargaJual.toString();
        // Set selected satuan for dropdown
        if (satuanOptions.contains(widget.komposisi!.satuan)) {
          controller.selectedSatuan.value = widget.komposisi!.satuan;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.komposisi != null ? 'Edit Komposisi' : 'Tambah Komposisi'
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
            // Ganti CustomTextField dengan CustomDropdown untuk satuan
            Obx(() => CustomDropdown<String>(
              hintText: controller.selectedSatuan.value.isEmpty
                  ? 'Pilih satuan*'
                  : controller.selectedSatuan.value,
              itemsStatic: satuanOptions,
              hasError: controller.hasAttemptedSubmit.value && 
                       controller.satuanError.value.isNotEmpty,
              errorText: controller.satuanError.value,
              onChanged: (selectedSatuan) {
                controller.setSatuan(selectedSatuan);
              },
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
                      : widget.komposisi != null ? 'Update' : 'Simpan',
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (widget.komposisi == null) {
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
      final ok = await controller.updateKomposisi(widget.komposisi!.id);
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