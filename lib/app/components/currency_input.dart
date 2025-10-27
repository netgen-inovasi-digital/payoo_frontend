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
  final bool required; // Parameter wajib dengan default true
  final String? requiredMessage; // Custom message untuk validasi

  const CurrencyInput({
    Key? key,
    required this.label,
    required this.valueController,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.required = true, // Default value true
    this.requiredMessage,
  }) : super(key: key);

  @override
  State<CurrencyInput> createState() => _CurrencyInputState();
}

class _CurrencyInputState extends State<CurrencyInput> {
  late TextEditingController _displayController;
  bool _hasError = false;

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
        // Reset error state jika value valid
        if (_hasError) {
          setState(() {
            _hasError = false;
          });
        }
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

    // Validasi saat nilai berubah
    if (widget.required) {
      final numValue = double.tryParse(numericOnly) ?? 0;
      if (numValue <= 0) {
        setState(() {
          _hasError = true;
        });
      } else {
        setState(() {
          _hasError = false;
        });
      }
    }

    if (widget.onChanged != null) {
      widget.onChanged!(numericOnly);
    }
  }

  // Method untuk validasi yang bisa dipanggil dari luar
  bool validate() {
    if (!widget.required) return true;

    final value = double.tryParse(widget.valueController.text) ?? 0;
    
    if (widget.label.isEmpty || widget.label.trim().isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Label tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
      setState(() {
        _hasError = true;
      });
      return false;
    }

    if (value <= 0) {
      final message = widget.requiredMessage ?? 
          '${widget.label} tidak boleh kosong atau 0';
      
      Get.snackbar(
        'Validasi Gagal',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
      setState(() {
        _hasError = true;
      });
      return false;
    }

    setState(() {
      _hasError = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != "") ...[
          Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (widget.required) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25),
            border: _hasError
                ? Border.all(color: Colors.red, width: 2)
                : null,
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
              hintStyle: TextStyle(
                fontSize: 16,
                color: _hasError ? Colors.red.shade300 : const Color(0xFF9E9E9E),
                fontWeight: FontWeight.w300,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: _hasError ? Colors.red : Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        if (_hasError && widget.required) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              widget.requiredMessage ?? 
                  '${widget.label} tidak boleh kosong atau 0',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
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