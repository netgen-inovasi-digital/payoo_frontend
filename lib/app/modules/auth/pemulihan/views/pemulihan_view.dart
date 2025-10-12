import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/auth/pemulihan/controllers/pemulihan_controller.dart';
import 'package:payoo/app/modules/auth/pemulihan/views/pemulihan_otp_view.dart';
import 'package:payoo/app/modules/auth/pemulihan/views/widgets/form_email.dart';
import 'package:payoo/app/modules/auth/pemulihan/views/widgets/sukses_email.dart';
import '../../../../../config/theme/light_theme.dart';

class PemulihanView extends StatefulWidget {
  const PemulihanView({super.key});

  @override
  State<PemulihanView> createState() => _PemulihanViewState();
}

class _PemulihanViewState extends State<PemulihanView> {
  bool belumPemulihan = true;

  void _onPemulihan() {
    pemulihanController.forgotPassword();
    Get.to(const PemulihanOtpView());
  }

  PemulihanController pemulihanController = Get.put(PemulihanController());

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
                        height: 150), // Spasi untuk menyesuaikan posisi
                    const Text(
                      "PEMULIHAN AKUN",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: LightThemeColors.displayTextColor),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FormEmail(onPemulihan: _onPemulihan, pemulihanController: pemulihanController),
                    ),
                  ],
                ),
                // Background Lengkungan Gradasi
                const CustomHeaderClipPath(
                  height: 130,
                  strokeWidth: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
