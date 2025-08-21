import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_product_image.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/keranjang/views/edit_transaksi_produk.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/keranjang_modal.dart';

class LaporanDetailCard extends StatelessWidget {
  final Produk produk;
  final int count;
  final VoidCallback? onTap;
  final Color cardColor;

  const LaporanDetailCard({
    super.key,
    required this.produk,
    required this.count,
    this.onTap,
    this.cardColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = count * produk.price;

    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          CustomProductImage(imageUrl: produk.imageUrl),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$count x Rp.${produk.price.toStringAsFixed(0)} = Rp.${totalPrice.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          count.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
