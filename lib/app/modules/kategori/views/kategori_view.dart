import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/kategori_controller.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Kategori Produk',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color: Colors.red[100],
          ),
        ),
      ),
      // ================= Body =================
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // ========== Input kategori ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: kategoriController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'nama kategori*',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 15), // padding atas bawah
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.green),
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
            ),
            const SizedBox(height: 14),
            // ========== List kategori ==========
            Expanded(
              child: Container(
                color: Colors.white,
                child: Obx(() => ListView.builder(
                      itemCount: kategoriList.length,
                      itemBuilder: (context, index) {
                        final item = kategoriList[index];
                        return Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            title: Text(
                              item,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.redAccent),
                              onPressed: () => kategoriList.removeAt(index),
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ),
            // ========== Tombol Simpan ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implementasi simpan kategori
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2BA86B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'SIMPAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
