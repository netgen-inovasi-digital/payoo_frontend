// keranjang_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/checkout_button.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/keranjang_card.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/pembayaran_modal.dart';
import 'package:payoo/config/theme/light_theme.dart';
import '../controllers/keranjang_controller.dart';

class KeranjangView extends GetView<KeranjangController> {
  const KeranjangView({super.key});
  final role = 'user';
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
                    color: role == 'user'
                        ? Colors.white
                        : LightThemeColors.primaryColor,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (role == 'user') {
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            insetPadding: const EdgeInsets.only(
                                left: 200, top: 0, bottom: 0, right: 0),
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Voucher Anda',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: LightThemeColors.accentColor,
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount:
                                          3, // Replace with your actual promo list
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            // Handle voucher selection
                                            Get.back();
                                          },
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: SvgPicture.asset(
                                                  'assets/images/discount_icon.svg',
                                                  width: 35,
                                                  height: 35,
                                                ),
                                                title: const Text(
                                                  'Voucher diskon 20%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                height: 4,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          barrierDismissible: true,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => PembayaranModal(
                            jumlah: controller
                                .totalPrice, // Use .value to get current value
                          ),
                        );
                      }
                    },
                    icon: role == 'user'
                        ? SvgPicture.asset(
                            'assets/images/discount_icon.svg',
                            width: 20,
                            height: 20,
                          )
                        : const Icon(Icons.check,
                            size: 15, color: Colors.white),
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
      bottomNavigationBar: const CheckoutButton(),
    );
  }
}
