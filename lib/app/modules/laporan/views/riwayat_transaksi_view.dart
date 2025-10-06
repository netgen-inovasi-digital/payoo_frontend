import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:payoo/app/modules/laporan/views/laporan_detail_view.dart';
import 'package:payoo/app/modules/laporan/views/widgets/laporan_card.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/utils/constant.dart';

class RiwayatTransaksiView extends StatefulWidget {
  const RiwayatTransaksiView({super.key, required this.apiPeriod});

  final String apiPeriod;

  @override
  State<RiwayatTransaksiView> createState() => _RiwayatTransaksiViewState();
}

class _RiwayatTransaksiViewState extends State<RiwayatTransaksiView> {
  late LaporanController controller;

  @override
  void initState() {
    super.initState();
    try {
      controller = Get.find<LaporanController>();
    } catch (e) {
      controller = Get.put(LaporanController());
    }
    controller.fetchOrderReport( period: widget.apiPeriod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Riwayat Transaksi'),
      body: Obx(() {
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
