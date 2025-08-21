import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_grey_dropdown.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/components/komposisi_card.dart';

class KomposisiProdukTab extends StatefulWidget {
  final List<Komposisi> komposisi;

  const KomposisiProdukTab({super.key, required this.komposisi});

  @override
  State<KomposisiProdukTab> createState() => _KomposisiProdukTabState();
}

class _KomposisiProdukTabState extends State<KomposisiProdukTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: CustomGreyDropdown(hintText: 'Komposisi Produk')),
        Expanded(
          child: ListView.builder(
            itemCount: widget.komposisi.length,
            itemBuilder: (context, index) {
              final komposisi = widget.komposisi[index];
              return KomposisiCard(
                komposisi: komposisi,
                useQuantities: true,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSaveButton(onPressed: () {}, label: 'SIMPAN'),
        ),
      ],
    );
  }
}
