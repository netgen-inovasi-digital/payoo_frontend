import 'package:flutter/material.dart';

class CustomProductImage extends StatelessWidget {
  final String imageUrl;

  const CustomProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 85,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, _) => Container(
              color: Colors.white,
              child: const Icon(Icons.fastfood),
            ),
          ),
        ),
      ),
    );
  }
}
