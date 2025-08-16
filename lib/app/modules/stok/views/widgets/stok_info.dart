import 'package:flutter/material.dart';


class StokInfo extends StatelessWidget {
  final Map<String, dynamic> stok;
  const StokInfo({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama komposisi : ${stok['nama']}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          'Harga komposisi : Rp. ${stok['hargaModal']}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          'Stok komposisi : ${stok['stok']}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}