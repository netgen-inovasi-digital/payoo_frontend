import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/routes/app_pages.dart';

class FormSandi extends StatelessWidget {
  final VoidCallback onPemulihanCallback;

  const FormSandi({super.key, required this.onPemulihanCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // TextField nama pemilik
        const CustomTextField(hintText: 'kata sandi baru'),
        const SizedBox(height: 20),
        // TextField email
        const CustomTextField(hintText: 'ulangi kata sandi baru*'),
        const SizedBox(height: 20),

        // Tombol Masuk
        CustomButton(
          label: 'KIRIM',
          onPressed: onPemulihanCallback,
          height: 50,
          width: 280,
        ),
        const SizedBox(height: 20),
        // Teks Daftar dan Lupa Kata Sandi
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.LOGIN);
              },
              child: const Text(
                'Kembali ke Halaman Depan.',
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
