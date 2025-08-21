import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomGreyDropdown<T> extends StatefulWidget {
  final String hintText;
  final RxList<T>? items; // Data dinamis dari API
  final List<T>? itemsStatic; // Data statis fallback
  final String Function(T item)?
      itemTextBuilder; // Optional, fungsi untuk membangun teks
  final ValueChanged<T>? onChanged; // Callback saat item dipilih
  final T? selectedValue;
  final IconData? icon;
  const CustomGreyDropdown({
    super.key,
    required this.hintText,
    this.icon,
    this.items,
    this.itemsStatic,
    this.itemTextBuilder,
    this.onChanged,
    this.selectedValue,
  });

  @override
  State<CustomGreyDropdown<T>> createState() => _CustomGreyDropdownState<T>();
}

class _CustomGreyDropdownState<T> extends State<CustomGreyDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    // Pilih sumber data
    final dropdownItems = (widget.items != null && widget.items!.isNotEmpty)
        ? widget.items!.toList()
        : (widget.itemsStatic ??
            []); // Fallback ke data statis atau list kosong

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          icon: widget.icon != null ? Icon(widget.icon, color: Colors.grey,) : null,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0), // Match container radius
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent, // Let container handle the color
        ),
        value: widget.selectedValue,
        items: dropdownItems.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(widget.itemTextBuilder != null
                ? widget.itemTextBuilder!(item)
                : item.toString()),
          );
        }).toList(),
        onChanged: (T? value) {
          if (value != null && widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
      ),
    );
  }
}
