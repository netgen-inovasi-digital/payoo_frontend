import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/product_card.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:payoo/app/modules/laporan/views/widgets/laporan_detail_card.dart';
import 'package:payoo/app/modules/struk/views/struk_view.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';

class LaporanDetailView extends StatefulWidget {
  const LaporanDetailView({super.key, required this.orderId});
  final int orderId;

  @override
  State<LaporanDetailView> createState() => _LaporanDetailViewState();
}

class _LaporanDetailViewState extends State<LaporanDetailView> {
  LaporanController controller = Get.find<LaporanController>();

  @override
  void initState() {
    super.initState();
    // Delay API call until after the first frame is built
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetail(orderId: widget.orderId);
    });
  }

  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const CustomAppBar(title: 'Detail Laporan'),
    body: Obx(() {
      if (controller.statusOrderDetail.value == ApiCallStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.statusOrderDetail.value == ApiCallStatus.error) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(controller.errorOrderDetail.value),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  controller.fetchOrderDetail(orderId: widget.orderId);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final orderItems = controller.orderDetail.value?.orderItems ?? [];
      if (orderItems.isEmpty) {
        return const Center(child: Text('No items found in this order'));
      }

      return ListView.builder(
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final orderItem = orderItems[index];

          if (controller.produkList.length <= index) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 12),
                  Text('Loading product details...'),
                ],
              ),
            );
          }

          return LaporanDetailCard(
            produk: controller.produkList[index],
            count: orderItem.quantity ?? 0,
          );
        },
      );
    }),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Padding(
      padding: const EdgeInsets.all(12.0),
      child: CustomSaveButton(
        onPressed: () {
          Get.to(() => StrukView(orderId: widget.orderId));
        },
        label: 'Lihat Struk',
      ),
    ),
  );
}

}