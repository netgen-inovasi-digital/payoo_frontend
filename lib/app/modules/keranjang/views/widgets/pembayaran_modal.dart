import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/currency_input.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:payoo/app/modules/transaksi/views/transaksi_berhasil_view.dart';
import 'package:payoo/config/utils/constant.dart';

class PembayaranModal extends StatefulWidget {
  final KeranjangController controller;
  const PembayaranModal({super.key, required this.controller});

  @override
  State<PembayaranModal> createState() => _PembayaranModalState();
}

class _PembayaranModalState extends State<PembayaranModal> {
  final List<Map<String, String>> paymentMethods = [
    {'id': 'cash', 'name': 'Cash'},
    {'id': 'gopay', 'name': 'GoPay'},
    {'id': 'ovo', 'name': 'OVO'},
    {'id': 'dana', 'name': 'DANA'},
    {'id': 'qris', 'name': 'QRIS'},
  ];

  String? selectedMethod = 'cash';

  double get diskonAmount {
    return double.tryParse(widget.controller.diskonController.text) ?? 0;
  }

  double get totalSetelahDiskon {
    final total = widget.controller.totalPrice - diskonAmount;
    return total > 0 ? total : 0;
  }

  void _updateKembalian() {
    final bayar = double.tryParse(widget.controller.enteredAmount.text) ?? 0;
    final total = widget.controller.totalPrice;
    final diskon = double.tryParse(widget.controller.diskonController.text) ?? 0;
    
    final totalSetelahDiskon = total - diskon;
    final kembalian = bayar - totalSetelahDiskon;
    
    widget.controller.kembalianController.text = 
        kembalian > 0 ? kembalian.toStringAsFixed(0) : '0';
  }

  void _onBayarChanged(String value) {
    final numericOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    widget.controller.enteredAmount.text = numericOnly;
    _updateKembalian();
    setState(() {});
  }

  void _onDiskonChanged(String value) {
    final numericOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    widget.controller.diskonController.text = numericOnly;
    _updateKembalian();
    setState(() {});
  }

  void _onKembalianChanged(String value) {
    final numericOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    widget.controller.kembalianController.text = numericOnly;
    setState(() {});
  }

  Future<void> _handlePay() async {
    final controller = widget.controller;

    if (controller.enteredAmount.text.trim().isEmpty) {
      controller.enteredAmount.text = totalSetelahDiskon.toString();
    }

    if (controller.countItem.isEmpty) {
      Get.snackbar(
        'Error',
        'Jumlah item tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final enteredAmountValue = double.tryParse(controller.enteredAmount.text);
    if (enteredAmountValue == null || enteredAmountValue < totalSetelahDiskon) {
      Get.snackbar(
        'Error',
        'Jumlah uang tidak mencukupi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    controller.paymentAmount.value = enteredAmountValue;
    controller.selectedPaymentMethod.value = selectedMethod ?? 'cash';

    final price = totalSetelahDiskon;
    final success = await controller.createOrder();

    if (success) {
      Get.back();
      Get.off(TransaksiBerhasilView(
        kembalian: double.tryParse(controller.kembalianController.text) ?? 0,
        orderId: controller.orderId.value,
      ));
    } else {
      Get.snackbar(
        'Error',
        controller.error.string,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Detail Pesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Detail Pesanan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // List produk
                    Obx(() => Column(
                          children: controller.product.map((prod) {
                            final qty = controller.countItem[prod.id] ?? 0;
                            final subtotal = prod.sellingPrice * qty;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${prod.name} (${qty}x)',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(subtotal),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )),
                    const Divider(height: 16, color: Color(0xFFE0E0E0)),

                    // Subtotal
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              formatRupiah(controller.totalPrice),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Input Bayar
              CurrencyInput(
                label: 'Bayar',
                hintText: formatRupiah(totalSetelahDiskon),
                onChanged: _onBayarChanged,
                valueController: controller.enteredAmount,
              ),
              const SizedBox(height: 16),

              // Input Diskon
              CurrencyInput(
                label: 'Diskon',
                hintText: 'Rp. 0',
                onChanged: _onDiskonChanged,
                valueController: controller.diskonController,
              ),
              
              const SizedBox(height: 16),

              // Input Kembalian
              CurrencyInput(
                label: 'Kembalian',
                hintText: 'Rp. 0',
                onChanged: _onKembalianChanged,
                valueController: controller.kembalianController,
              ),

              const SizedBox(height: 16),
              // Grid layout metode pembayaran
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: paymentMethods.take(3).map((method) {
                      final isSelected = selectedMethod == method['id'];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: _buildPaymentButton(method, isSelected),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: paymentMethods.skip(3).take(2).map((method) {
                      final isSelected = selectedMethod == method['id'];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: _buildPaymentButton(method, isSelected),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5F5F5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _handlePay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton(Map<String, String> method, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method['id'];
        });
      },
      child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF50).withOpacity(0.1)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 3),
            Text(
              method['name']!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}