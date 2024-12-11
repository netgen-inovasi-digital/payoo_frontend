import 'package:flutter/material.dart';
import 'package:payoo/config/theme/light_theme.dart';

class CustomTextFieldWithLabel extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const CustomTextFieldWithLabel({
    super.key,
    required this.labelText,
    required this.hintText,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            labelText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: LightThemeColors.textHintColor,
            ),
          ),
        ),
        const SizedBox(height: 8), // Jarak antara label dan TextField
        SizedBox(
          width: 280,
          height: 50,
          child: TextField(
            keyboardType: keyboardType,
            controller: controller,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: LightThemeColors.textHintColor),
              contentPadding: const EdgeInsets.symmetric(horizontal: 35),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                    const BorderSide(color: LightThemeColors.fieldColor),
              ),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.white, // Border saat tidak fokus
                ),
              ),
              focusColor: Colors.red,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: LightThemeColors.primaryColor,
                  width: 2, // Border saat fokus
                ),
              ),
              fillColor: LightThemeColors.fieldColor, // Warna latar
            ),
          ),
        ),
      ],
    );
  }
}
