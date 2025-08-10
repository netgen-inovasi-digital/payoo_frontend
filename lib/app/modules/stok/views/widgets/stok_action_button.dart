import 'package:flutter/material.dart';

class StokActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color textColor;
  final EdgeInsetsGeometry? margin;

  const StokActionButton({
    super.key,
    required this.label,
    this.onTap,
    this.textColor = Colors.grey,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(100),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                      label,
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
