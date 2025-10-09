import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_grey_dropdown.dart';
import 'package:payoo/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:payoo/app/modules/laporan/views/riwayat_transaksi_view.dart';
import 'package:payoo/app/modules/laporan/views/widgets/laporan_card.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/utils/constant.dart';

class LaporanView extends StatefulWidget {
  const LaporanView({super.key});

  @override
  State<LaporanView> createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> {
  final LaporanController controller = Get.put(LaporanController());
  String apiPeriod = 'this_month';

  @override
  void initState() {
    super.initState();
    controller.fetchReportSummary(period: apiPeriod);
    controller.fetchOrderReport(period: apiPeriod); // Added for dateRange
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

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
            // ===== Dropdown for Period =====
            Obx(() => CustomGreyDropdown<String>(
              itemsStatic: const ['bulan ini', 'minggu ini', 'hari ini'],
              icon: Icons.calendar_today_outlined,
              hintText: 'bulan ini',
              selectedValue: controller.selectedPeriod.value,
              onChanged: (value) {
                controller.selectedPeriod.value = value;
                // Determine API period key
                apiPeriod = 'this_month';
                if (value == 'minggu ini') apiPeriod = 'this_week';
                if (value == 'hari ini') apiPeriod = 'today';

                // Fetch both summary + orders (for dateRange)
                controller.fetchReportSummary(period: apiPeriod);
                controller.fetchOrderReport(period: apiPeriod);
              },
            )),

            const SizedBox(height: 20),

            // ===== Date Range Display =====
            Obx(() {
              if (controller.statusOrderReport.value == ApiCallStatus.loading) {
              }
              if (controller.statusOrderReport.value == ApiCallStatus.error) {
                return Center(child: Text(controller.errorOrderReport.value));
              }

              final ordersReport = controller.ordersReport.value;
              if (ordersReport?.dateRange != null) {
                final start = ordersReport!.dateRange.start;
                final end = ordersReport.dateRange.end;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "${formatDate(start)} - ${formatDate(end)}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // ===== Report Summary Card =====
            Obx(() {
              if (controller.statusSummary.value == ApiCallStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.statusSummary.value == ApiCallStatus.error) {
                return Center(child: Text(controller.errorSummary.value));
              }

              return GestureDetector(
                onTap: () => {
                  Get.to(RiwayatTransaksiView(apiPeriod: apiPeriod))
                },
                child: LaporanCard(
                  leftLabel: 'Total Pemasukan',
                  rigthLabel: 'Total Transaksi',
                  leftValue: formatRupiah(
                    controller.reportSummary.value?.totalRevenue ?? 0,
                  ),
                  rigthValue:
                      "${controller.reportSummary.value?.totalTransactions ?? 0}",
                ),
              );
            }),

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
