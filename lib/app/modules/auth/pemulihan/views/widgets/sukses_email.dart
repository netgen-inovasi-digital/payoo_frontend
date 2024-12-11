import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class SuksesEmail extends StatelessWidget {
  const SuksesEmail({super.key});

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
            height: 162,
            decoration: BoxDecoration(
              color: LightThemeColors
                  .backgroundGreyColor, // Pindahkan warna ke sini
              borderRadius: BorderRadius.circular(50), // Radius sudut
            ),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Link pemulihan akun telah dikirimkan, silakan cek email Anda dan ikuti petunjuk yang diberikan.',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: LightThemeColors.displayTextColor),
                  textAlign: TextAlign.center, // Gunakan TextAlign.center
                ),
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
          // Teks Daftar dan Lupa Kata Sandi
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Belum Terima Email ? ',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.PEMULIHAN_CALLBACK);
                },
                child: const Text(
                  'Kirim Email Pemulihan.',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          // kembali ke halaman depan
          const SizedBox(height: 10),
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
