import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../../config/theme/light_theme.dart';

class CustomButtonOutline extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double borderRadius;
  final double height;
  final double width;
  final FaIcon icon;

  const CustomButtonOutline(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backgroundColor = Colors.transparent,
      this.textStyle = const TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      this.borderRadius = 50.0,
      required this.width,
      required this.height,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: ElevatedButton.icon(
          icon: icon,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              side: BorderSide(color: LightThemeColors.accentColor, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius))),
          label: Text(label, style: textStyle)),
    );
  }
}
