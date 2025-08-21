import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/CustomFooterClipPath.dart';
import 'package:payoo/app/components/confirm_dialog.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/data_produk/views/tambah_produk_view.dart';
// import 'package:payoo/app/modules/data_produk/views/tambah_produk_view.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class DetailProdukView extends StatelessWidget {
  const DetailProdukView({super.key, required this.produk});

  final Produk produk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Produk'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 10),
              child: Center(
                child: Image.network(
                  produk.imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      produk.name,
                      style:
                          const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Center(
                    child: Text(
                      produk.category,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Harga Jual : Rp ${produk.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Harga Modal : Rp ${produk.modalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Stok : 25',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Komposisi :',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                          fontWeight: FontWeight.w700),
                  ),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('1. Roti',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          Text('2 pcs',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('2. Daging',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          Text('100 gr',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1. Selada',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          Text('1 lembar',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                             Get.to(() => const TambahProdukView());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF4F4F4),
                              foregroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Edit produk',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialog(itemName: produk.name, confirmButtonColor: LightThemeColors.buttonColor, onConfirm: () {
                                    // Add your delete logic here
                                  });
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF4F4F4),
                              foregroundColor: Colors.grey[600],
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Hapus produk',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
