import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:payoo/app/modules/transaksi/views/transaksi_berhasil_view.dart';

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

  Future<void> _handlePay() async {
    final controller = widget.controller;

    if (controller.enteredAmount.text.trim().isEmpty) {
      controller.enteredAmount.text = controller.totalPrice.toString();
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
    if (enteredAmountValue == null ||
        enteredAmountValue < controller.totalPrice) {
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

    final price = controller.totalPrice;
    final success = await controller.createOrder();

    if (success) {
      Get.back(); // Close the modal
      Get.off(TransaksiBerhasilView(
        bayar: controller.paymentAmount.value,
        harga: price,
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
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Grid layout 3 di baris pertama, 2 di baris kedua
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

              const SizedBox(height: 24),
              const Text(
                'Masukkan jumlah uang',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Input jumlah uang
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Rp. ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Flexible(
                          child: TextField(
                            controller: controller.enteredAmount,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintText: controller.totalPrice.toString(),
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
                    ),
                  ),
                ),
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
        width: 75, // 🔹 Lebih kecil dari sebelumnya (90)
        padding:
            const EdgeInsets.symmetric(vertical: 8), // 🔹 Sedikit lebih rapat
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF50).withOpacity(0.1)
              : const Color(0xFFF5F5F5),
          borderRadius:
              BorderRadius.circular(10), // 🔹 Radius sedikit lebih kecil
          border: Border.all(
            color:
                isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
              size: 16, // 🔹 Icon lebih kecil
            ),
            const SizedBox(height: 3),
            Text(
              method['name']!,
              style: TextStyle(
                fontSize: 13, // 🔹 Font lebih kecil
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
