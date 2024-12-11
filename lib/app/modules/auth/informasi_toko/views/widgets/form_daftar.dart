import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/routes/app_pages.dart';

class FormDaftar extends StatelessWidget {
  final VoidCallback onDaftar;

  const FormDaftar({super.key, required this.onDaftar});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // TextField nama pemilik
        const CustomTextField(hintText: 'nama pemilik*'),
        const SizedBox(height: 20),
        // TextField email
        const CustomTextField(hintText: 'email*'),
        const SizedBox(height: 20),
        // TextField nomor ponsel
        const CustomTextField(hintText: 'nomor ponsel pemilik*'),
        const SizedBox(height: 20),
        // TextField kata sandi
        const CustomTextField(
          hintText: 'kata sandi*',
        ),
        const SizedBox(height: 20),
        // TextField ulang kata sandi
        const CustomTextField(hintText: 'ulang kata sandi*'),
        const SizedBox(height: 20),

        // Tombol Masuk
        CustomButton(
          label: 'DAFTAR',
          onPressed: onDaftar,
          width: 280,
          height: 50,
        ),
        const SizedBox(height: 20),
        // Teks Daftar dan Lupa Kata Sandi
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sudah Punya Akun? Masuk ',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.LOGIN);
              },
              child: const Text(
                'Disini.',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
