import 'package:flutter/material.dart';
import 'package:payoo/config/theme/light_theme.dart';

class EditableImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onEdit;

  const EditableImage({
    super.key,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Lingkaran besar dengan border gradient
        Container(
          width: 90, // Diameter lingkaran
          height: 90,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                LightThemeColors.primaryColor,
                LightThemeColors.accentColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0), // Jarak dalam border
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Background putih untuk gambar
              ),
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // Tombol edit
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: LightThemeColors.accentColor, // Warna tombol
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white, // Warna ikon
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
