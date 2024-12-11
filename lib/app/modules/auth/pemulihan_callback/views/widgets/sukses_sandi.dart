import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/config/theme/light_theme.dart';

class SuksesSandi extends StatelessWidget {
  const SuksesSandi({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          //container
          Container(
            width: 280,
            height: 120,
            decoration: BoxDecoration(
              color: LightThemeColors
                  .backgroundGreyColor, // Pindahkan warna ke sini
              borderRadius: BorderRadius.circular(50), // Radius sudut
            ),
            child: const Center(
              child: Text(
                'Kata sandi berhasil diperbarui',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: LightThemeColors.displayTextColor),
                textAlign: TextAlign.center, // Gunakan TextAlign.center
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Tombol Masuk
          CustomButton(
              width: 280,
              height: 50,
              label: 'MASUK',
              onPressed: () {
                // Get.toNamed(Routes.)
              }),
          const SizedBox(height: 20),

          // kembali ke halaman depan
          GestureDetector(
            onTap: () {},
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
    );
  }
}
