import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar_secondary.dart';
import '../controllers/keranjang_controller.dart';
import 'widgets/list_view_keranjang.dart';
import 'package:payoo/app/components/custom_button.dart';

class KeranjangView extends GetView<KeranjangController> {
  const KeranjangView({super.key});

  @override
  Widget build(BuildContext context) {
    // Data pesanan
    final RxList<Map<String, dynamic>> pesananList = <Map<String, dynamic>>[
      {
        'nama': 'Classic Burger',
        'jumlah': 1,
        'harga': 25000,
        'total': 25000,
        'active': true,
      },
      {
        'nama': 'Beef Mentai',
        'jumlah': 1,
        'harga': 25000,
        'total': 25000,
        'active': false,
      },
    ].obs;

    return Scaffold(
      // ================= AppBar Custom =================
      appBar: const CustomAppBarSecondary(
        title: 'Keranjang',
      ),
      // ================= Body =================
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            // ========== List pesanan ========== 
            Expanded(
              child: Container(
                color: Colors.white,
                child: Obx(() => ListViewKeranjang(
                  pesananList: pesananList.toList(),
                  onEdit: (index) {
                    // TODO: Implementasi edit pesanan
                  },
                  onDelete: (index) => pesananList.removeAt(index),
                )),
              ),
            ),
            // ========== Tombol Simpan ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: CustomButton(
                label: 'Lanjutkan Pesanan',
                onPressed: () {
                  // TODO: Implementasi simpan kategori
                },
                width: double.infinity,
                height: 54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
