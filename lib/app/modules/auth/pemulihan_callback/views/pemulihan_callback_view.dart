import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/auth/pemulihan_callback/views/widgets/form_sandi.dart';
import 'package:payoo/app/modules/auth/pemulihan_callback/views/widgets/sukses_sandi.dart';
import '../../../../../config/theme/light_theme.dart';

class PemulihanCallbackView extends StatefulWidget {
  const PemulihanCallbackView({super.key});

  @override
  State<PemulihanCallbackView> createState() => _PemulihanCallbackViewState();
}

class _PemulihanCallbackViewState extends State<PemulihanCallbackView> {
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
                            ? FormSandi(onPemulihanCallback: _toggleWidget)
                            : const SuksesSandi()),
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
