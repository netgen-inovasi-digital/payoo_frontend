import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar_secondary.dart';
import '../controllers/kategori_controller.dart';
import 'widgets/list_view_kategori.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_button.dart';

class KategoriView extends GetView<KategoriController> {
  const KategoriView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller untuk input kategori
    final TextEditingController kategoriController = TextEditingController();
    // List kategori (observable agar UI update otomatis)
    final RxList<String> kategoriList = <String>['Makanan', 'Minuman'].obs;

    return Scaffold(
      // ================= AppBar Custom =================
      appBar: const CustomAppBarSecondary(
        title: 'Kategori Produk',
      ),
      // ================= Body =================
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // ========== Input kategori ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'nama kategori*',
                      controller: kategoriController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: () {
                      final nama = kategoriController.text.trim();
                      if (nama.isNotEmpty && !kategoriList.contains(nama)) {
                        kategoriList.add(nama);
                        kategoriController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // ========== List kategori ==========
            Expanded(
              child: Container(
                color: Colors.white,
                child: Obx(() => ListViewKategori(
                  kategoriList: kategoriList.toList(),
                  onDelete: (index) => kategoriList.removeAt(index),
                )),
              ),
            ),
            // ========== Tombol Simpan ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: CustomButton(
                label: 'SIMPAN',
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
