import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_dropdown.dart';
import 'package:payoo/app/components/custom_grey_dropdown.dart';
import 'package:payoo/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:payoo/app/modules/laporan/views/riwayat_transaksi_view.dart';
import 'package:payoo/app/modules/laporan/views/widgets/laporan_card.dart';
import 'package:payoo/app/services/api_call_status.dart';

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
            Obx(() => CustomGreyDropdown<String>(
              itemsStatic: const ['bulan ini', 'minggu ini', 'hari ini'],
              icon: Icons.calendar_today_outlined,
              hintText: 'bulan ini',
              selectedValue: controller.selectedPeriod.value,
              onChanged: (value) {
              controller.selectedPeriod.value = value;
              //menggunakan apiPeriod dan di pass aja karena makai controller tadi error dan gak dapat datanya 
              apiPeriod = 'this_month';
              if (value == 'minggu ini') apiPeriod = 'this_week';
              if (value == 'hari ini') apiPeriod = 'today';
              controller.fetchReportSummary(period: apiPeriod);
              },
            )),
  
            const SizedBox(height: 20),
            // === Hari ini ===
            Obx(() {
              if (controller.statusSummary.value == ApiCallStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.statusSummary.value == ApiCallStatus.error) {
                return Center(child: Text(controller.errorSummary.value));
              }
              return GestureDetector(
                onTap: () => {Get.to(RiwayatTransaksiView(apiPeriod: apiPeriod))},
                child: LaporanCard(
                    leftLabel: 'Total Pemasukan',
                    rigthLabel: 'Total Transaksi',
                    leftValue:
                        "RP. ${controller.reportSummary.value?.totalRevenue.toStringAsFixed(0) ?? 0},-",
                    rigthValue: 
                        "${controller.reportSummary.value?.totalTransactions ?? 0}"),
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
