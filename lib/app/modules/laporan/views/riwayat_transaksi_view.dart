// lib/app/modules/laporan/views/riwayat_transaksi_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:payoo/app/modules/laporan/views/laporan_detail_view.dart';
import 'package:payoo/app/modules/laporan/views/widgets/laporan_card.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/utils/constant.dart';

class RiwayatTransaksiView extends StatelessWidget { // 1. Change to StatelessWidget
  RiwayatTransaksiView({super.key, required this.apiPeriod});

  final String apiPeriod;
  
  // 2. Find the controller directly in the build method
  final LaporanController controller = Get.find<LaporanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Riwayat Transaksi'),
      body: Obx(() {
        // The rest of your build method remains exactly the same.
        // It will now display the data that was already loaded.
        if (controller.statusOrderReport.value == ApiCallStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.statusOrderReport.value == ApiCallStatus.error) {
          return Center(child: Text(controller.errorOrderReport.value));
        }

        final orders = controller.ordersReport.value?.orders ?? [];
        if (orders.isEmpty) {
          return const Center(child: Text('Tidak ada transaksi'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => LaporanDetailView(orderId: int.parse(order.id)));
                },
                child: LaporanCard(
                  leftLabel: 'Total',
                  rigthLabel: 'Jumlah Item',
                  leftValue: formatRupiah(order.total),
                  rigthValue: '${order.totalItems}',
                ),
              ),
            );
          },
        );
      }),
    );
  }
}