import 'package:flutter/material.dart';

class CustomSaveButton extends StatelessWidget {
  const CustomSaveButton({super.key, required this.onPressed, required this.label, this.labelFontSize = 16, this.paddingHeight = 18});
  final double paddingHeight;
  final VoidCallback onPressed;
  final String label;
  final double labelFontSize;
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2FA36B),
          padding: EdgeInsets.symmetric(vertical: paddingHeight),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: labelFontSize),
        ),
      ),
    );
  }
}