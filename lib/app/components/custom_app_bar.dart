import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/config/theme/light_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool dividerLine;
  final List<Widget>? children;
  final VoidCallback? onPressed;

  const CustomAppBar({super.key, required this.title, this.dividerLine = true, this.children, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: const EdgeInsets.only(right: 20),
      elevation: 0, // Hilangkan bayangan
      backgroundColor: Colors.white, // Warna latar belakang putih
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,
            color: Colors.black), // Ikon panah kembali
        onPressed: onPressed ?? () {
          Get.back();
        },
      ),
      centerTitle: true, // Judul di tengah
      title: Text(
        title, // Teks judul
        style: const TextStyle(
          color: Colors.black, // Warna teks hitam
          fontSize: 18, // Ukuran teks
          fontWeight: FontWeight.w700, // Teks tebal
        ),
      ),
      actions: children, // Add children to the right side
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0), // Tinggi garis
        child: Container(
          color: dividerLine ? LightThemeColors.accentColor : Colors.transparent, // Warna garis merah
          height: 1.0, // Ketebalan garis
        ),
      ),
    );
  }

  // Implementasi PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
