import 'package:flutter/material.dart';
import '../../../../config/theme/light_theme.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double width;
  final double height;
  final String? errorText;
  final bool hasError;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.width = 280,
    this.height = 50,
    this.errorText,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: hasError 
                    ? Colors.red.withOpacity(0.7)
                    : LightThemeColors.textHintColor
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: hasError 
                      ? Colors.red 
                      : LightThemeColors.fieldColor
                ),
              ),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.white,
                  width: hasError ? 2 : 1,
                ),
              ),
              focusColor: hasError ? Colors.red : Colors.blue,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: hasError 
                      ? Colors.red 
                      : LightThemeColors.primaryColor,
                  width: 2,
                ),
              ),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              fillColor: hasError 
                  ? Colors.red.withOpacity(0.1)
                  : LightThemeColors.fieldColor,
            ),
          ),
        ),
        if (hasError && errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
