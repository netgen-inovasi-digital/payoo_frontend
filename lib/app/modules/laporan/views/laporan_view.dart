import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_dropdown.dart';
import 'package:payoo/app/components/custom_grey_dropdown.dart';
import 'package:payoo/app/modules/laporan/views/riwayat_transaksi_view.dart';
import 'package:payoo/app/modules/laporan/views/widgets/laporan_card.dart';

class LaporanView extends StatelessWidget {
  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const CustomGreyDropdown(
              hintText: 'Pilih Bulan',
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => {Get.to(const RiwayatTransaksiView())},
              child: const LaporanCard(
                  leftLabel: 'Total Pemasukan',
                  rigthLabel: 'Total Transaksi',
                  leftValue: "Rp 1.250.000",
                  rigthValue: "100"),
            ),
            const SizedBox(height: 20),
            const CustomGreyDropdown(
              hintText: 'Hari Ini',
              icon: Icons.calendar_today_outlined,
            ),

            const SizedBox(height: 20),
            // === Hari ini ===
            GestureDetector(
              onTap: () => {Get.to(const RiwayatTransaksiView())},
              child: const LaporanCard(
                  leftLabel: 'Total Pemasukan',
                  rigthLabel: 'Total Transaksi',
                  leftValue: "Rp 50.000",
                  rigthValue: "2"),
            ),
            const SizedBox(height: 7),
            const Text(
              "*Tekan untuk melihat detail",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
