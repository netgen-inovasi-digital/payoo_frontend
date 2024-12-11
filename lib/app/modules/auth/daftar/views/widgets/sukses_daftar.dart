import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class SuksesDaftar extends StatelessWidget {
  const SuksesDaftar({super.key});

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
                'Pendaftaran Akun telah Berhasil.',
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
                Get.toNamed(Routes.INFORMASI_TOKO);
              }),
          const SizedBox(height: 20),
          // Teks Daftar dan Lupa Kata Sandi
        ],
      ),
    );
  }
}
