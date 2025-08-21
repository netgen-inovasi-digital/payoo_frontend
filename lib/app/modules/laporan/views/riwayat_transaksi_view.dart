import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/laporan/views/Laporan_detail_view.dart';
import 'package:payoo/app/modules/laporan/views/widgets/laporan_card.dart';

class RiwayatTransaksiView extends StatefulWidget {
  const RiwayatTransaksiView({super.key});

  @override
  State<RiwayatTransaksiView> createState() => _RiwayatTransaksiViewState();
}

class _RiwayatTransaksiViewState extends State<RiwayatTransaksiView> {
  bool isWeeklyView = true;
  String selectedWeek = '';

  // Dummy data for weekly view
  final List<Map<String, dynamic>> weeklyData = [
    {"total": "Rp 75.000", "transaksi": "Minggu ke 1", "jumlah": "25", "week": "week1"},
    {"total": "Rp 75.000", "transaksi": "Minggu ke 2", "jumlah": "25", "week": "week2"},
    {"total": "Rp 75.000", "transaksi": "Minggu ke 3", "jumlah": "25", "week": "week3"},
    {"total": "Rp 75.000", "transaksi": "Minggu ke 4", "jumlah": "25", "week": "week4"},
  ];
  final List<Produk> dummyProdukList = (List<Produk>.from(ProdukList)..shuffle()).take(5).toList();
  // Dummy data for item details (when week is clicked)
  final Map<String, List<Map<String, dynamic>>> itemDetails = {
    "week1": [
      {"total": "Rp 25.000", "transaksi": "Nasi Goreng", "jumlah": "8",},
      {"total": "Rp 30.000", "transaksi": "Ayam Bakar", "jumlah": "10"},
      {"total": "Rp 20.000", "transaksi": "Es Teh Manis", "jumlah": "7"},
    ],
    "week2": [
      {"total": "Rp 35.000", "transaksi": "Soto Ayam", "jumlah": "12"},
      {"total": "Rp 20.000", "transaksi": "Gado-gado", "jumlah": "8"},
      {"total": "Rp 20.000", "transaksi": "Jus Jeruk", "jumlah": "5"},
    ],
    "week3": [
      {"total": "Rp 40.000", "transaksi": "Rendang", "jumlah": "15"},
      {"total": "Rp 25.000", "transaksi": "Sayur Lodeh", "jumlah": "6"},
      {"total": "Rp 10.000", "transaksi": "Kopi", "jumlah": "4"},
    ],
    "week4": [
      {"total": "Rp 30.000", "transaksi": "Mie Ayam", "jumlah": "10"},
      {"total": "Rp 25.000", "transaksi": "Bakso", "jumlah": "8"},
      {"total": "Rp 20.000", "transaksi": "Es Campur", "jumlah": "7"},
    ],
  };

  void _onWeekTapped(String week, String weekName) {
    setState(() {
      isWeeklyView = false;
      selectedWeek = week;
    });
  }

  void _onDayTapped(String week, String weekName) {
    Get.to(
      LaporanDetailView(
        produkList: dummyProdukList,
      ),
    );
  }

  void _goBackToWeekly() {
    setState(() {
      isWeeklyView = true;
      selectedWeek = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentData = isWeeklyView 
        ? weeklyData 
        : itemDetails[selectedWeek] ?? [];
    
    final appBarTitle = isWeeklyView 
        ? 'Riwayat Transaksi'
        : 'Detail ${weeklyData.firstWhere((week) => week['week'] == selectedWeek, orElse: () => {'transaksi': 'Item'})['transaksi']}';

    return Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currentData.length,
        itemBuilder: (context, index) {
          final item = currentData[index];
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: isWeeklyView && item['week'] != null
                  ? () => _onWeekTapped(item['week'], item['transaksi'])
                  : () => _onDayTapped(selectedWeek, item['transaksi']),
              child: LaporanCard(
                leftLabel: 'Total',
                rigthLabel: isWeeklyView ? item['transaksi'] : 'Jumlah Item',
                leftValue: item['total'],
                rigthValue: item['jumlah'],
              ),
            ),
          );
        },
      ),
    );
  }
}