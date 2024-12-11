import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool passwordSee = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Konten Utama
                Column(
                  children: [
                    const SizedBox(
                        height: 250), // Spasi untuk menyesuaikan posisi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 120),
                          // TextField Pertama
                          const CustomTextField(hintText: 'email/nomor ponsel'),
                          const SizedBox(height: 20),
                          // TextField Kedua
                          CustomTextField(
                            hintText: 'kata sandi',
                            obscureText: passwordSee,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  passwordSee = !passwordSee;
                                  setState(() {});
                                },
                                child: Icon(
                                  passwordSee
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: passwordSee
                                      ? LightThemeColors.textHintColor
                                      : LightThemeColors.bodyTextColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Tombol Masuk
                          CustomButton(
                              height: 50,
                              width: 280,
                              label: 'Masuk',
                              onPressed: () {
                                Get.toNamed(Routes.DASHBOARD);
                              }),
                          const SizedBox(height: 20),
                          // Teks Daftar dan Lupa Kata Sandi
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Belum Punya Akun? Daftar ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.DAFTAR);
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
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.PEMULIHAN);
                            },
                            child: const Text(
                              'Lupa Kata Sandi?',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Background Lengkungan Gradasi
                const CustomHeaderClipPath(
                  height: 350,
                  strokeWidth: 20,
                  children: [
                    Text(
                      "PAYOO",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text("Point of Sales",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
