import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar_secondary.dart';
import '../controllers/pesanan_controller.dart';

class PesananView extends GetView<PesananController> {
  const PesananView({super.key});

  @override
  Widget build(BuildContext context) {
    final pesananList = [
      {
        'nama': 'Classic Burger',
        'jumlah': 1,
        'harga': 25000,
        'total': 25000,
      },
      {
        'nama': 'Beef Mentai',
        'jumlah': 1,
        'harga': 25000,
        'total': 25000,
      },
    ];

    return Scaffold(
      appBar: const CustomAppBarSecondary(
        title: 'Pesanan',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ilustrasi chef
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Center(
                child: Image.asset(
                  'assets/images/dimasak.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Step status pesanan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Step 1
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2FA36B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.access_time,
                                  color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                        // Garis hijau
                        Expanded(
                          child: Container(
                            height: 6,
                            color: const Color(0xFF1F8755),
                          ),
                        ),
                        // Step 2
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2FA36B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.restaurant,
                                  color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                        // Garis abu
                        Expanded(
                          child: Container(
                            height: 6,
                            color: Colors.grey[300],
                          ),
                        ),
                        // Step 3
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2FA36B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text('Menunggu Konfirmasi',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text('Pesanan disiapkan',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text('Pesanan Selesai',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Pesanan
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text('Pesanan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: pesananList
                    .map((pesanan) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pesanan['nama'].toString(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${pesanan['jumlah']} x Rp.${pesanan['harga']} = Rp.${pesanan['total']}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            // Pembayaran
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text('Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('QRIS', style: TextStyle(fontSize: 14)),
                  Text('Rp100.000',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
