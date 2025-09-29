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
  final String? errorText;
  final bool hasError;
  final double width;
  final double height;

  const CustomDropdown({
    super.key,
    required this.hintText,
    this.items,
    this.itemsStatic,
    this.itemTextBuilder, // Bisa tidak disediakan
    this.onChanged,
    this.errorText,
    this.hasError = false,
    this.width = 280,
    this.height = 50,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          decoration: BoxDecoration(
            color: widget.hasError 
                ? Colors.red.withOpacity(0.1)
                : LightThemeColors.fieldColor,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: widget.hasError ? Colors.red : Colors.white,
              width: widget.hasError ? 2 : 1,
            ),
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
              hintStyle: TextStyle(
                color: widget.hasError 
                    ? Colors.red.withOpacity(0.7)
                    : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: Icon(
              Icons.arrow_drop_down, 
              color: widget.hasError ? Colors.red : Colors.grey
            ),
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
        ),
        if (widget.hasError && widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
