import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/modules/auth/pemulihan/controllers/pemulihan_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';

class FormEmail extends StatelessWidget {
  final VoidCallback onPemulihan;
  final PemulihanController pemulihanController;
  const FormEmail({super.key, required this.onPemulihan, required this.pemulihanController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        
        // TextField email
        CustomTextField(hintText: 'alamat email', controller: pemulihanController.forgetPasswordController),
        const SizedBox(height: 20),

        // Tombol Masuk
        CustomButton(
          label: 'KIRIM PEMULIHAN AKUN',
          onPressed: onPemulihan,
          width: 280,
          height: 50,
        ),
        const SizedBox(height: 20),
        // Teks Daftar dan Lupa Kata Sandi
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Lupa Alamat Email? ',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.LOGIN);
              },
              child: const Text(
                'Kontak Tim Payoo.',
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
