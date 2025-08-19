// app/modules/data_produk/views/widgets/product_card.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_product_image.dart';
import 'package:payoo/config/theme/light_theme.dart';
import '../data/models/produk_model.dart';

class ProductCard extends StatelessWidget {
  final Produk produk;
  final VoidCallback? onTap;
  final Color cardColor;
  final bool underlined;
  final double paddingVertical;
  final double paddingHorizontal; 
  const ProductCard({
    super.key,
    required this.produk,
    this.onTap,
    this.cardColor = Colors.white,
    this.underlined = true,
    this.paddingVertical = 15.0,
    this.paddingHorizontal = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          border: underlined ? Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
            ),
          ) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomProductImage(imageUrl: produk.imageUrl),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Rp.${produk.price.toStringAsFixed(0)},-",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        "Stok = ${produk.stock}pcs",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
