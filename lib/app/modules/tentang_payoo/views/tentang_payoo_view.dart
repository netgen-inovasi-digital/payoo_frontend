import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_app_bar.dart';

class TentangPayooView extends StatelessWidget {
  const TentangPayooView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:  CustomAppBar(title: 'Tentang Payoo'),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang\ndi Payoo,',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'aplikasi Point of Sales yang dirancang khusus untuk membantu UKM di Indonesia dalam mengelola stok, transaksi produk dan penanganan dari setiap produk.',
              style: TextStyle(fontSize: 14, fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,),
            ),
            SizedBox(height: 20),
            Text(
              'Versi 1.0.0',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}