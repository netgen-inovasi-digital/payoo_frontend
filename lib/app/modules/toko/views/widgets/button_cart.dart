import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/keranjang/views/keranjang_view.dart';

class CartFloatingButton extends StatelessWidget {
  const CartFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman keranjang dengan GetX
          Get.to(() => const KeranjangView());
        },
        backgroundColor: Colors.white,
        elevation: 0,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.green,
          size: 28,
        ),
      ),
    );
  }
}