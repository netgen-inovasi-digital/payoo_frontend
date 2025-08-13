import 'package:flutter/material.dart';

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
          // TODO: Implement navigation to cart page
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