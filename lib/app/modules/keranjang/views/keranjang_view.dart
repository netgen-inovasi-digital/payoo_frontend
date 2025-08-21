// keranjang_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/keranjang_card.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/pembayaran_modal.dart';
import 'package:payoo/config/theme/light_theme.dart';
import '../controllers/keranjang_controller.dart';

class KeranjangView extends GetView<KeranjangController> {
  const KeranjangView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => CustomAppBar(
              title: 'Rp.${controller.totalPrice.toStringAsFixed(0)}',
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: LightThemeColors.primaryColor,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => PembayaranModal(
                          jumlah: controller.totalPrice, // Use .value to get current value
                        ),
                      );
                    },
                    icon: const Icon(Icons.check, size: 15, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                )
              ],
            )),
      ),
      body: Obx(
        () {
          // Check if cart is empty
          if (controller.product.isEmpty) {
            return const Center(
              child: Text(
                'Keranjang kosong',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100.0),
            itemCount: controller.product.length,
            itemBuilder: (context, index) {
              final currentProduct = controller.product[index];
              return KeranjangCard(
                produk: currentProduct,
                controller: controller,
              );
            },
          );
        },
      ),
    );
  }
}