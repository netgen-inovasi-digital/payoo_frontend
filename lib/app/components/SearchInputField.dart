import 'package:flutter/material.dart';

class SearchInputField extends StatelessWidget {
  final Function(String) onSearchChanged;
  final TextEditingController controller;
  final String? hintText;
  final double? verticalPadding;

  const SearchInputField({
    super.key,
    required this.onSearchChanged,
    required this.controller,
    this.hintText,
    this.verticalPadding = 7.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onSearchChanged,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        // Teks petunjuk yang akan hilang saat pengguna mengetik
        hintText: hintText ?? 'Cari produk (kode | nama)',
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        // Ikon yang ditampilkan di sebelah kiri
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade500,
          size: 30,
        ),
        // Ikon clear di sebelah kanan (muncul saat ada text)
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey.shade500,
                ),
                onPressed: () {
                  controller.clear();
                  onSearchChanged('');
                },
              )
            : null,
        // Mengatur padding di dalam text field
        contentPadding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 7.0,
          horizontal: 7.0,
        ),
        // Mengatur warna latar belakang
        filled: true,
        fillColor: Colors.grey.shade100,
        // Mengatur border saat text field tidak dalam fokus
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.grey.shade200, // Warna border
            width: 1.0,
          ),
        ),
        // Mengatur border saat text field dalam fokus (diklik)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.green, // Warna border saat fokus
            width: 1,
          ),
        ),
      ),
    );
  }
}