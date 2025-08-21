import 'package:flutter/material.dart';
import 'package:payoo/config/theme/light_theme.dart';

class LaporanCard extends StatelessWidget {
  const LaporanCard(
      {super.key, required this.leftValue,required this.leftLabel, required this.rigthLabel, required this.rigthValue});
  final String leftValue;
  final String rigthValue;
  final String leftLabel;
  final String rigthLabel;
   
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card Isi
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfo(leftLabel, leftValue),
              _buildInfo(rigthLabel, rigthValue),
            ],
          ),
        ),
      ],
    );
    ;
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: LightThemeColors.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 19.42,
          ),
        ),
      ],
    );
  }
}
