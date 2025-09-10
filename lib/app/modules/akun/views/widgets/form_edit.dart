import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_text_field_with_label.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/dashboarduser/controllers/dashboard_user_controller.dart';

class FormEdit extends StatelessWidget {
  final VoidCallback onDaftar;

  FormEdit({super.key, required this.onDaftar});
  final AkunController userController = AkunController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        CustomTextFieldWithLabel(
            labelText: 'Nama akun*',
            hintText: userController.namaController.text),
        const SizedBox(height: 10),
        // TextField email
        CustomTextFieldWithLabel(
            labelText: 'Email*', hintText: userController.emailController.text),
        const SizedBox(height: 10),
        // TextField nomor ponsel
        CustomTextFieldWithLabel(
          labelText: 'Nomor ponsel*',
          hintText: userController.phoneController.text,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        // TextField kata sandi
        CustomTextFieldWithLabel(labelText: 'Password lama*', hintText: ''),
        const SizedBox(height: 10),
        // TextField ulang kata sandi
        const CustomTextFieldWithLabel(
            labelText: 'Password baru*', hintText: ''),
        const SizedBox(height: 10),
        // Tombol Masuk
        CustomButton(
          label: 'SIMPAN',
          onPressed: onDaftar,
          width: 136,
          height: 50,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
