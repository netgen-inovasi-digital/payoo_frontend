import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class TransaksiBerhasilView extends StatelessWidget {
  const TransaksiBerhasilView({super.key, required this.bayar, required this.harga});
  final double bayar;
  final double harga;

  @override
  Widget build(BuildContext context) {
    final double kembalian = bayar - harga;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 8),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 65,
                ),
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                'Selamat!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              const Text(
                'Transaksi Berhasil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // Transaction Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kembalian',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Rp. ${kembalian.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Buttons
              Column(
                children: [
                    _ActionButton(
                    label: "Transaksi baru",
                    color: LightThemeColors.primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      // TODO: Implement aksi transaksi baru
                      Get.offAndToNamed(Routes.DASHBOARD);
                    },
                  ),
                  const SizedBox(height: 15),
                  _ActionButton(
                    label: "Lihat Struk",
                    color: const Color(0xFFF5F5F5),
                    textColor: LightThemeColors.buttonColor,
                    onPressed: () {
                      // TODO: Implement lihat struk
                      Get.offAndToNamed(Routes.STRUK);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable Button Widget
class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: color == Colors.white ? 0 : null,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
