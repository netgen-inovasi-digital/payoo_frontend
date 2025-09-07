import 'package:flutter/material.dart';

class CustomProductImage extends StatelessWidget {
  final String photo;

  const CustomProductImage({super.key, required this.photo});
  
  @override
  Widget build(BuildContext context) {
    print("photo test123425: $photo");
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
            photo,
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
