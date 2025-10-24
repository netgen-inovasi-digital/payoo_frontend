import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/app/modules/pembelian/views/pembelian_detail_view.dart';
import 'package:payoo/app/modules/stok/views/stok_detail_view.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:get/get.dart';

class ListViewPembelian extends StatelessWidget {
  final List<Stock> stokList;

  const ListViewPembelian({
    super.key,
    required this.stokList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 120.0),
      itemCount: stokList.length,
      itemBuilder: (context, index) {
        final item = stokList[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => PembelianDetailView(stok: item));
          },
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        formatRupiah(item.buyPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.productType == "product" ? "produk" : "komposisi",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'jumlah : ${item.quantity}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
