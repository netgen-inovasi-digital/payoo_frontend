import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/product_card.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/laporan/views/widgets/laporan_detail_card.dart';
import 'package:payoo/app/routes/app_pages.dart';

class LaporanDetailView extends StatelessWidget {
  const LaporanDetailView({super.key, required this.produkList});
  final List<Produk> produkList;

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Laporan'),
      body: ListView.builder(
        itemCount: produkList.length,
        itemBuilder: (context, index) {
          final produk = produkList[index];
          return LaporanDetailCard(produk: produk, count: 1);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomSaveButton(onPressed: (){
          Get.toNamed(Routes.STRUK );
        }, label: 'Lihat Struk'),
      ),
    );
  }
}