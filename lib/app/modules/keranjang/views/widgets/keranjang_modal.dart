// app/modules/keranjang/views/widgets/keranjang_modal.dart

import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_product_image.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';

// Fungsi ini akan kita panggil dari KeranjangCard
void keranjangModal({
  required BuildContext context,
  required Produk produk,
  required KeranjangController controller,
}) {
  showDialog(
    context: context,
    builder: (context) {
      // Ambil jumlah item saat ini dari controller
      int count = controller.getProductCount(produk.id);

      // Gunakan StatefulBuilder agar state 'count' di dalam dialog bisa diperbarui
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Info Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomProductImage(imageUrl: produk.imageUrl),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              produk.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rp.${produk.price.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF999999),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "${controller.getProductCount(produk.id)} item",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF999999),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // --- Bagian Counter (Tambah/Kurang) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCounterButton(
                        icon: Icons.remove,
                        onPressed: count > 1
                            ? () => setState(() => count--)
                            : null, // Nonaktifkan jika jumlah = 1
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Text(
                          "$count",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      _buildCounterButton(
                        icon: Icons.add,
                        onPressed: () => setState(() => count++),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- Bagian Tombol Aksi (Hapus & OK) ---
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFE8E8E8),
                              foregroundColor: const Color(0xFF666666),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              controller.removeProduct(produk.id);
                              Navigator.pop(context); // Tutup dialog
                            },
                            child: const Text(
                              "Hapus",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              controller.setProductCount(produk.id, count);
                              Navigator.pop(context); // Tutup dialog
                            },
                            child: const Text(
                              "Ok",
                              style: TextStyle(
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
        },
      );
    },
  );
}

// Widget helper untuk tombol counter agar tidak duplikasi kode
Widget _buildCounterButton({required IconData icon, VoidCallback? onPressed}) {
  return Container(
    width: 60,
    height: 44,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 20,
      color: onPressed != null ? Colors.black : const Color(0xFFBBBBBB),
      padding: EdgeInsets.zero,
    ),
  );
}