import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_text_field_with_label.dart';
import 'package:payoo/app/routes/app_pages.dart';

class FormEditToko extends StatelessWidget {
  const FormEditToko({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Nama Toko
        const CustomTextFieldWithLabel(labelText: 'Nama Toko*', hintText: 'Nama Toko'),
        const SizedBox(height: 10),
        // Alamat
        const CustomTextFieldWithLabel(labelText: 'Alamat*', hintText: 'Alamat'),
        const SizedBox(height: 10),
        // TextField nomor Toko
        const CustomTextFieldWithLabel(
          labelText: 'Nomor Toko*',
          hintText: 'Nomor Toko',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 60),
        CustomButton(
          label: 'SIMPAN',
          onPressed: () {
            Get.toNamed(Routes.DASHBOARD);
          },
          width: 146,
          height: 60,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
