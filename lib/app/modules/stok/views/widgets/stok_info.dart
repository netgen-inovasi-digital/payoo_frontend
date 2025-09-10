import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';


class StokInfo extends StatelessWidget {
  final Komposisi stok;
  const StokInfo({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama komposisi : ${stok.namaKomposisi}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          'Harga komposisi : Rp. ${stok.hargaModal}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          'Stok komposisi : ${stok.stokKomposisi}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}