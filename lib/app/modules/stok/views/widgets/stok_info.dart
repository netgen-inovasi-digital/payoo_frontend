import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/stok_model.dart';


class StokInfo extends StatelessWidget {
  final ProductWithStock stok;
  const StokInfo({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama ${stok.type == 'composition' ? 'komposisi' : 'produk'} : ${stok.name}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          'Harga ${stok.type == 'composition' ? 'komposisi' : 'produk'} : Rp. ${stok.costPrice.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          'Stok ${stok.type == 'composition' ? 'komposisi' : 'produk'} : ${stok.stock} ${stok.unit ?? 'pcs'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          'Tipe : ${stok.type == 'composition' ? 'Komposisi' : 'Produk'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}