import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/config/theme/light_theme.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String hintText;
  final RxList<T>? items; // Data dinamis dari API
  final List<T>? itemsStatic; // Data statis fallback
  final String Function(T item)?
      itemTextBuilder; // Optional, fungsi untuk membangun teks
  final ValueChanged<T>? onChanged; // Callback saat item dipilih

  const CustomDropdown({
    super.key,
    required this.hintText,
    this.items,
    this.itemsStatic,
    this.itemTextBuilder, // Bisa tidak disediakan
    this.onChanged,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    // Pilih sumber data
    final dropdownItems = (widget.items != null && widget.items!.isNotEmpty)
        ? widget.items!.toList()
        : (widget.itemsStatic ??
            []); // Fallback ke data statis atau list kosong

    return Container(
      width: 280,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(
        color: LightThemeColors.fieldColor, // Sesuaikan dengan tema
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: DropdownButtonFormField<T>(
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Quicksand'),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        items: dropdownItems
            .map((T item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    widget.itemTextBuilder != null
                        ? widget
                            .itemTextBuilder!(item) // Gunakan builder jika ada
                        : item.toString(), // Gunakan default toString()
                  ),
                ))
            .toList(),
        onChanged: (newValue) {
          // Aksi saat item dipilih
          if (widget.onChanged != null && newValue != null) {
            widget.onChanged!(newValue); // Panggil callback
          }
        },
      ),
    );
  }
}
