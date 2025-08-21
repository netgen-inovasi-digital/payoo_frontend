import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_grey_dropdown.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/komposisi_card.dart';
import 'package:payoo/app/components/product_card.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/data/models/produk_model.dart';

class EditTransaksiProduk extends StatefulWidget {
  const EditTransaksiProduk({super.key, required this.produk});
  final Produk produk;

  @override
  State<EditTransaksiProduk> createState() => _EditTransaksiProdukState();
}

class _EditTransaksiProdukState extends State<EditTransaksiProduk> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleSimpan() {
    // Handle simpan logic here
    final notes = _notesController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Produk'),
      body: Stack(
        children: [
          Column(
            children: [
              ProductCard(produk: widget.produk),
               const Padding(
                 padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10 ),
                 child: CustomGreyDropdown(hintText: "Add On", ),
               ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 180.0, // Increased padding for bottom container
                  ),
                  itemCount: komposisiList.length,
                  itemBuilder: (context, index) {
                    final komposisi = komposisiList[index];
                    return KomposisiCard(
                      komposisi: komposisi,
                      useQuantities: true,
                      onTap: () => () {},
                    );
                  },
                ),
              ),
            ],
          ),
          // Bottom container with text area and button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text Area
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 3,
                      minLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Tambahkan catatan...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Save Button
                  CustomSaveButton(onPressed: (){}, label: 'Simpan')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}