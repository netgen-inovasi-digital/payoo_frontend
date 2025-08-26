import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/auth/daftar/views/widgets/form_daftar.dart';
import 'package:payoo/app/modules/auth/daftar/views/widgets/sukses_daftar.dart';
import '../../../../../config/theme/light_theme.dart';

class DaftarView extends StatefulWidget {
  const DaftarView({super.key});

  @override
  State<DaftarView> createState() => _DaftarViewState();
}

class _DaftarViewState extends State<DaftarView> {
  bool belumDaftar = true;

  // mengubah state daftar
  void _toggleWidget() {
    setState(() {
      belumDaftar = !belumDaftar; //ubah state
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
                      "DAFTAR AKUN PAYOO",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: LightThemeColors.displayTextColor),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
            child: belumDaftar
              ? FormDaftar(onDaftarSuccess: _toggleWidget)
              : const SuksesDaftar()),
                  ],
                ),
                // Background Lengkungan Gradasi
                const CustomHeaderClipPath(
                  height: 130,
                  strokeWidth: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
