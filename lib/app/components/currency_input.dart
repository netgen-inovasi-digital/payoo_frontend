import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:payoo/app/modules/transaksi/views/transaksi_berhasil_view.dart';
import 'package:payoo/config/utils/constant.dart';

// ========== CURRENCY INPUT COMPONENT ==========
class CurrencyInput extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController valueController;
  final Function(String)? onChanged;
  final bool enabled;

  const CurrencyInput({
    Key? key,
    required this.label,
    required this.valueController,
    this.hintText,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CurrencyInput> createState() => _CurrencyInputState();
}

class _CurrencyInputState extends State<CurrencyInput> {
  late TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController();
    _updateDisplay();

    widget.valueController.addListener(_updateDisplay);
  }

  @override
  void dispose() {
    widget.valueController.removeListener(_updateDisplay);
    _displayController.dispose();
    super.dispose();
  }

  void _updateDisplay() {
    if (widget.valueController.text.isNotEmpty) {
      final value = double.tryParse(widget.valueController.text) ?? 0;
      if (value > 0) {
        _displayController.text = formatRupiah(value);
        _displayController.selection = TextSelection.collapsed(
          offset: _displayController.text.length,
        );
      } else {
        _displayController.clear();
      }
    } else {
      _displayController.clear();
    }
  }

  void _onChanged(String value) {
    final numericOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    widget.valueController.text = numericOnly;

    if (widget.onChanged != null) {
      widget.onChanged!(numericOnly);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != "") ...[
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: _displayController,
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CurrencyInputFormatter(),
            ],
            onChanged: _onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: widget.hintText ?? 'Rp. 0',
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Color(0xFF9E9E9E),
                fontWeight: FontWeight.w300,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF9E9E9E),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final value = int.parse(numericOnly);
    final formatted = formatRupiah(value.toDouble());

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}