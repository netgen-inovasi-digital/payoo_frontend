import 'package:flutter/material.dart';

import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';

class TambahKomposisiView extends StatelessWidget {
  TambahKomposisiView({super.key, this.komposisi});
  final Komposisi? komposisi;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaModalController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController satuanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  if (komposisi != null) {
    namaController.text = komposisi!.namaKomposisi;
    hargaModalController.text = komposisi!.hargaModal.toString();
    hargaJualController.text = komposisi!.hargaJual.toString();
    stokController.text = komposisi!.stokKomposisi.toString();
    satuanController.text = komposisi!.satuan;
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
              controller: namaController,
              
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'harga modal*',
              controller: hargaModalController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'harga jual*',
              controller: hargaJualController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'stok komposisi*',
              controller: stokController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'satuan',
              controller: satuanController,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
              child: CustomSaveButton(
                onPressed: () {},
                label: komposisi != null ? 'Update' : 'Simpan'
              ),
            )
          ],
        ),
      ),
    );
  }
}