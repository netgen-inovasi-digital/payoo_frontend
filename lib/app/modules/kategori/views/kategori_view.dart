import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_snackbar.dart';
import 'package:payoo/app/routes/app_pages.dart';
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
      appBar: CustomAppBar(
        title: 'Data Kategori',
        onPressed: () => Get.back(),
      ),
      // ================= Body =================
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // ========== Input kategori ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => CustomTextField(
                          hintText: 'Nama kategori*',
                          controller: c.nameController,
                          hasError: c.hasAttemptedSubmit.value && 
                                   c.nameError.value.isNotEmpty,
                          errorText: c.nameError.value,
                        )),
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        if (c.statusCreate.value == ApiCallStatus.loading) {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onPressed: () async {
                            final ok = await c.createKategori();
                            if (ok) {
                              CustomSnackBar.showCustomSnackBar(
                                title: 'Sukses', 
                                message: 'Kategori berhasil ditambahkan'
                              );
                              c.resetCreateForm();
                            }else{
                              CustomSnackBar.showCustomErrorSnackBar(
                                title: 'Gagal Menyimpan', 
                                message: c.errorCreate.value.isNotEmpty 
                                  ? c.errorCreate.value 
                                  : 'Terjadi kesalahan saat menyimpan kategori'
                              );
                            } 
                          },
                        );
                      }),
                    ],
                  ),
                  // Optional description field
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
                        CustomSnackBar.showCustomSnackBar(
                          title: 'Sukses', 
                          message: 'Kategori "${k.name}" berhasil dihapus'
                        );
                      } else {
                        CustomSnackBar.showCustomErrorSnackBar(
                          title: 'Gagal Menghapus', 
                          message: c.errorDelete.value.isNotEmpty 
                            ? c.errorDelete.value 
                            : 'Terjadi kesalahan saat menghapus kategori'
                        );
                      }
                    },
                  );
                }),
              ),
            ),
            // ========== Tombol Simpan ==========
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            //   child: CustomButton(
            //     label: 'SIMPAN',
            //     onPressed: () {
            //       Get.snackbar('Info', 'Semua perubahan sudah realtime');
            //     },
            //     width: double.infinity,
            //     height: 54,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
