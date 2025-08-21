// Notes gak bisa di pake di lain karena bair reaktif di dalam keranjang 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_product_image.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:payoo/app/modules/keranjang/views/edit_transaksi_produk.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/keranjang_modal.dart';

class KeranjangCard extends StatelessWidget {
  final Produk produk;
  final KeranjangController controller;
  final VoidCallback? onTap;
  final Color cardColor;

  const KeranjangCard({
    super.key,
    required this.produk,
    required this.controller,
    this.onTap,
    this.cardColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(height: 5),
                  
                  // Wrap entire row in Obx
                  Obx(() {
                    final count = controller.getProductCount(produk.id);
                    final totalPrice = count * produk.price;
                    
                    return Row(
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
                        GestureDetector(
                          onTap: () {
                            keranjangModal(
                              context: context,
                              produk: produk,
                              controller: controller,
                            );
                          },
                          child: Container(
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
                        ),
                      ],
                    );
                  }),
                  
                  const SizedBox(height: 5),
                  Container(
                    width: 50,
                    height: 22,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => EditTransaksiProduk(produk: produk));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}