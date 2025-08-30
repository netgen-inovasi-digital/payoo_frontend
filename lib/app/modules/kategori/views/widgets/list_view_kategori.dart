import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/kategori_model.dart';
import 'package:payoo/app/modules/kategori/controllers/kategori_controller.dart';
import 'package:payoo/app/components/empty_state.dart';
import 'package:get/get.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/components/confirm_dialog.dart';
import 'package:payoo/app/components/custom_button.dart';

class ListViewKategori extends StatelessWidget {
  final List<Kategori> kategoriList;
  final void Function(Kategori kategori) onDelete;
  final KategoriController controller;

  const ListViewKategori({
    super.key,
    required this.kategoriList,
    required this.onDelete,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (kategoriList.isEmpty) {
      return const EmptyState(
        title: 'Belum ada kategori',
        subtitle: 'Tambah kategori baru',
        icon: Icons.inventory_2_outlined,
      );
    }
    return ListView.builder(
      itemCount: kategoriList.length,
      itemBuilder: (context, index) {
        final item = kategoriList[index];
        final deleting = controller.deletingIds.contains(item.id);
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            title: Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            onTap: () async {
              // Prefill form controllers
              controller.nameController.text = item.name;
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Edit Kategori',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(labelText: 'Nama*'),
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          final updating = controller.statusUpdate.value ==
                              ApiCallStatus.loading;
                          return CustomButton(
                            label:
                                updating ? 'MENYIMPAN...' : 'SIMPAN PERUBAHAN',
                            onPressed: updating
                                ? () {}
                                : () async {
                                    final ok = await controller
                                        .updateKategori(item.id);
                                    if (ok) {
                                      Get.back();
                                      Get.snackbar(
                                          'Sukses', 'Kategori diperbarui');
                                    } else {
                                      Get.snackbar(
                                          'Gagal', controller.errorUpdate.value,
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  },
                            width: double.infinity,
                            height: 54,
                            backgroundColor: Colors.green,
                          );
                        }),
                      ],
                    ),
                  );
                },
              );
              controller.resetCreateForm(); // clear after editing
            },
            trailing: deleting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ConfirmDialog(
                          itemName: item.name,
                          confirmButtonColor: Colors.red,
                          onConfirm: () {
                            onDelete(item);
                          },
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
