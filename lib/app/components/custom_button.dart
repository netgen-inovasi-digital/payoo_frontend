import 'package:flutter/material.dart';
import '../../../../config/theme/light_theme.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double borderRadius;
  final double height;
  final double width;

  const CustomButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backgroundColor = LightThemeColors.primaryColor,
      this.textStyle = const TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
      this.borderRadius = 50.0,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius))),
          child: Text(label, style: textStyle)),
    );
  }
}
