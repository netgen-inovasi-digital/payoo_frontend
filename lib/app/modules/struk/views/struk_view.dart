import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/struk/controllers/struk_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';

class StrukView extends StatefulWidget {
  const StrukView({super.key, required this.orderId});
  final int orderId;

  @override
  State<StrukView> createState() => _StrukViewState();
}

class _StrukViewState extends State<StrukView> {
  StrukController controller = Get.put(StrukController());

  @override
  void initState() {
    super.initState();
    controller.getOrderById(orderId: widget.orderId);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Struk Penjualan",
        onPressed: () => Get.toNamed(Routes.DASHBOARD),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
        child: Obx(() {
          if (controller.status.value == ApiCallStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.status.value == ApiCallStatus.error) {
            return Center(child: Text('Error: ${controller.error.value}'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info
              Center(
                child: Column(
                  children: [
                    Text(
                      controller.tokoController.toko.value?.name ?? 'Nama Toko',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.tokoController.toko.value?.address ??
                          'Alamat Toko',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      controller.tokoController.toko.value?.phone ??
                          'No Telepon',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Divider after header
              const Divider(color: Colors.black),
              const SizedBox(height: 10),

              // Transaction Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // Format date from createdAt
                    controller.tokoController.toko.value?.createdAt != null
                        ? DateTime.parse(controller
                                .tokoController.toko.value!.createdAt!)
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'DD/MM/YYYY',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    // Format time from createdAt
                    controller.tokoController.toko.value?.createdAt != null
                        ? DateTime.parse(controller
                                .tokoController.toko.value!.createdAt!)
                            .toLocal()
                            .toString()
                            .split(' ')[1]
                            .substring(0, 5)
                        : 'HH:MM',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'No Transaksi (id trk)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    controller.order.value?.id.toString() ?? '0',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Items Section Header
              const Center(
                child: Text(
                  'Pesanan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Order Items List
              controller.order.value?.orderItems != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.order.value!.orderItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.order.value!.orderItems[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.produkList[index].name.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item.quantity.toStringAsFixed(0)}x${item.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  'Rp. ${(item.quantity * item.price).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    )
                  : const Center(child: Text('No items found')),

              const SizedBox(height: 10),
              const Divider(color: Colors.black),
              const SizedBox(height: 10),

              // Summary Section
              _buildSummaryRow('Total Item', controller.totalItem.value.toString()),
              _buildSummaryRow('Sub Total', 'Rp. ${controller.totalHarga.value.toStringAsFixed(0)}'),
              _buildSummaryRow('Potongan', 'Rp. 0'),
              const SizedBox(height: 5),
              _buildSummaryRow(
                'Total',
                'Rp. ${controller.totalHarga.value.toStringAsFixed(0)}',
                isBold: true,
              ),
              _buildSummaryRow('Bayar', controller.order.value?.amountPaid.toString() ?? '0', isBold: true),
              _buildSummaryRow('Kembali', 'Rp. ${(controller.order.value?.amountPaid ?? 0) - controller.totalHarga.value}', isBold: true),

              const SizedBox(height: 10),
              const Divider(color: Colors.black),

              const SizedBox(height: 10),

              // Thank you message
              const Center(
                child: Text(
                  'Terima kasih telah berbelanja',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),

              // Share Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: CustomSaveButton(
                  onPressed: () {
                    // Add share functionality here
                  },
                  label: "Share",
                  labelFontSize: 20,
                  paddingHeight: 13,
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
