import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_text_field_with_label.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/akun/views/widgets/custom_akun_text_field.dart';
import 'package:payoo/app/modules/toko/controllers/toko_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';

class FormEditToko extends StatelessWidget {
  const FormEditToko({super.key, required this.controller,});
  final TokoController controller;

  _updateToko() {
    if (controller.controllerNamaToko.text.isEmpty ||
        controller.controllerAlamatToko.text.isEmpty ||
        controller.controllerTeleponToko.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    controller.updateToko(controller.toko.value!.id);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Nama Toko
          CustomAkunTextField(label: 'Nama Toko*', initialValue: controller.controllerNamaToko.text, controller: controller.controllerNamaToko),
          const SizedBox(height: 10),
          // Alamat
          CustomAkunTextField(label: 'Alamat*', initialValue: controller.controllerAlamatToko.text, controller: controller.controllerAlamatToko),
          const SizedBox(height: 10),
          // TextField nomor Toko
          CustomAkunTextField(label: 'Nomor Toko*', initialValue: controller.controllerTeleponToko.text, keyboardType: TextInputType.number, controller: controller.controllerTeleponToko),
          const SizedBox(height: 60),
          CustomButton(
            label: 'SIMPAN',
            onPressed: () {
              _updateToko();
            },
            width: 146,
            height: 60,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
