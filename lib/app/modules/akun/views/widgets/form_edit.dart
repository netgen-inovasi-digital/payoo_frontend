import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_text_field_with_label.dart';

class FormEdit extends StatelessWidget {
  final VoidCallback onDaftar;

  const FormEdit({super.key, required this.onDaftar});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const CustomTextFieldWithLabel(labelText: 'Nama akun*', hintText: ''),
        const SizedBox(height: 10),
        // TextField email
        const CustomTextFieldWithLabel(labelText: 'Email*', hintText: ''),
        const SizedBox(height: 10),
        // TextField nomor ponsel
        const CustomTextFieldWithLabel(
          labelText: 'Nomor ponsel*',
          hintText: '',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        // TextField kata sandi
        const CustomTextFieldWithLabel(
            labelText: 'Password lama*', hintText: ''),
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
