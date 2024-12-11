import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
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

  // mengubah state daftar
  void _toggleWidget() {
    setState(() {
      belumPemulihan = !belumPemulihan; //ubah state
    });
  }

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
                        child: belumPemulihan
                            ? FormEmail(onPemulihan: _toggleWidget)
                            : const SuksesEmail()),
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
