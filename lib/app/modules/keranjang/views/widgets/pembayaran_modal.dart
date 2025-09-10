import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:payoo/app/modules/transaksi/views/transaksi_berhasil_view.dart';
import 'package:payoo/app/routes/app_pages.dart';

class PembayaranModal extends StatelessWidget {
  final KeranjangController controller;
  const PembayaranModal({
    super.key,
    required this.controller,
  });
  Future<void> _handlePay() async {
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
    
    // Parse the entered amount once and store it
    final enteredAmountValue = double.tryParse(controller.enteredAmount.text);
    if (enteredAmountValue == null || enteredAmountValue < controller.totalPrice) {
      Get.snackbar(
        'Error',
        'Jumlah uang tidak mencukupi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Set the payment amount in the controller
    controller.paymentAmount.value = enteredAmountValue;
    final price = controller.totalPrice;
    // Call create order
    final success = await controller.createOrder();

    if (success) {
      Get.to(TransaksiBerhasilView(
        bayar: controller.paymentAmount.value,
        harga: price,
        orderId: controller.orderId.value,
      ));
    } else {
      // Error message is already set in controller
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Masukkan jumlah uang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                      onPressed: () {
                        Get.back();
                      },
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
                      onPressed: () {
                        _handlePay();
                      },
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
    );
  }
}
