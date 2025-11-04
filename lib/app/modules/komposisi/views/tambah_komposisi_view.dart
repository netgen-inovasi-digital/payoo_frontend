import 'package:flutter/material.dart';
import 'package:payoo/app/components/currency_input.dart';

import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_dropdown.dart';
import 'package:payoo/app/components/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/pembayaran_modal.dart';
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
        controller.hargaModalController.text =
            widget.komposisi!.hargaModal.toString();
        controller.hargaJualController.text =
            widget.komposisi!.hargaJual.toString();
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
          title:
              widget.komposisi != null ? 'Edit Komposisi' : 'Tambah Komposisi'),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
        child: Column(
          children: [
            _buildTextField("Nama komposisi*", controller.namaController),
            const SizedBox(height: 16),
            CurrencyInput(
              valueController: controller.hargaModalController,
              hintText: 'harga Modal*',
              enabled: true,
              label: '',
            ),
            const SizedBox(height: 16),
            CurrencyInput(
              valueController: controller.hargaJualController,
              hintText: 'harga jual*',
              enabled: true,
              label: '',
            ),
            const SizedBox(height: 16),
            // Ganti CustomTextField dengan CustomDropdown untuk satuan
            Obx(() => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedSatuan.value.isEmpty
                        ? null
                        : controller.selectedSatuan.value,
                    decoration: InputDecoration(
                      hintText: 'Pilih satuan*',
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      errorText: controller.hasAttemptedSubmit.value &&
                              controller.satuanError.value.isNotEmpty
                          ? controller.satuanError.value
                          : null,
                    ),
                    items: satuanOptions.map((String satuan) {
                      return DropdownMenuItem<String>(
                        value: satuan,
                        child: Text(satuan),
                      );
                    }).toList(),
                    onChanged: (selectedSatuan) {
                      if (selectedSatuan != null) {
                        controller.setSatuan(selectedSatuan);
                      }
                    },
                  ),
                )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
              child: Obx(() {
                final isLoading =
                    controller.statusCreate.value == ApiCallStatus.loading ||
                        controller.statusUpdate.value == ApiCallStatus.loading;
                return CustomSaveButton(
                  onPressed: () {
                    if (isLoading) return; // guard
                    _handleSave();
                  },
                  label: isLoading
                      ? 'Menyimpan...'
                      : widget.komposisi != null
                          ? 'Update'
                          : 'Simpan',
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController? textController,
      {bool isNumber = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: textController,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (widget.komposisi == null) {
      final ok = await controller.createKomposisi();
      if (ok) {
        Get.back(); // Go back to previous screen
        CustomSnackBar.showCustomSnackBar(
            title: 'Sukses', message: 'Komposisi berhasil dibuat');
      } else {
        // Check if it's a validation error or API error
        if (controller.errorCreate.value.isNotEmpty) {
          CustomSnackBar.showCustomErrorSnackBar(
              title: 'Gagal Membuat', message: controller.errorCreate.value);
        }
      }
    } else {
      Get.back();
      Get.back();
      // Update existing komposisi
      final ok = await controller.updateKomposisi(widget.komposisi!.id);
      if (ok) {
        Get.toNamed(Routes.KOMPOSISI);
        CustomSnackBar.showCustomSnackBar(
            title: 'Sukses', message: 'Komposisi berhasil diperbarui');
      } else {
        // Check if it's a validation error or API error
        if (controller.namaError.value.isNotEmpty ||
            controller.hargaModalError.value.isNotEmpty ||
            controller.hargaJualError.value.isNotEmpty ||
            controller.satuanError.value.isNotEmpty) {
          CustomSnackBar.showCustomErrorSnackBar(
              title: 'Form Tidak Valid',
              message: 'Mohon periksa kembali data yang Anda masukkan');
        } else if (controller.errorUpdate.value.isNotEmpty) {
          CustomSnackBar.showCustomErrorSnackBar(
              title: 'Gagal Memperbarui',
              message: controller.errorUpdate.value);
        }
      }
    }
  }
}
