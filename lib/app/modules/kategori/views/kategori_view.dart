import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import '../controllers/kategori_controller.dart';
import 'widgets/list_view_kategori.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/data/models/kategori_model.dart';

class KategoriView extends GetView<KategoriController> {
  const KategoriView({super.key});

  @override
  Widget build(BuildContext context) {
  final c = controller; // alias

    return Scaffold(
      // ================= AppBar Custom =================
      appBar: const CustomAppBar(title: 'Data Kategori'),
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
                      controller: c.nameController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: () async {
                      final nama = c.nameController.text.trim();
                      if (nama.isEmpty) return;
                      final ok = await c.createKategori();
                      if (ok) {
                        Get.snackbar('Sukses', 'Kategori ditambahkan');
                        c.resetCreateForm();
                      } else {
                        Get.snackbar('Gagal', c.errorCreate.value, snackPosition: SnackPosition.BOTTOM);
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
                child: Obx(() {
                  if (c.statusList.value == ApiCallStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (c.statusList.value == ApiCallStatus.error) {
                    return Center(
                      child: Text('Gagal memuat: ${c.errorList.value}'),
                    );
                  }
                  return ListViewKategori(
                    kategoriList: c.list.toList(),
                    controller: c,
                    onDelete: (Kategori k) async {
                      final ok = await c.deleteKategori(k.id);
                      if (ok) {
                        Get.snackbar('Sukses', 'Kategori dihapus');
                      } else {
                        Get.snackbar('Gagal', c.errorDelete.value, snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                  );
                }),
              ),
            ),
            // ========== Tombol Simpan ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: CustomButton(
                label: 'SIMPAN',
                onPressed: () {
                  Get.snackbar('Info', 'Semua perubahan sudah realtime');
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
