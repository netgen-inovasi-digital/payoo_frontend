import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:payoo/app/components/confirm_dialog.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/data_produk/views/data_produk_view.dart';
import 'package:payoo/app/modules/data_produk/views/tambah_produk_view.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/theme/light_theme.dart';
import 'package:payoo/config/utils/constant.dart';

class DetailProdukView extends StatefulWidget {
  const DetailProdukView({super.key, required this.produkId});

  final int produkId;

  @override
  State<DetailProdukView> createState() => _DetailProdukViewState();
}

class _DetailProdukViewState extends State<DetailProdukView> {
  final ProdukController controller = Get.find<ProdukController>();

  @override
  void initState() {
    super.initState();
    controller.produk.value = null;
    // Fetch data only once when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProdukById(widget.produkId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Produk'),
      body: Obx(() {
        if (controller.statusProdukById.value == ApiCallStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.statusProdukById.value == ApiCallStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading product: ${controller.errorList.value}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchProdukById(widget.produkId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final Produk? produk = controller.produk.value;

        if (produk == null) {
          return const Center(
            child: Text('Product not found'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 60, 0, 10),
                child: Center(
                  child: Image.network(
                    produk.photo,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.error_outline,
                              color: Colors.red, size: 40),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        width: 200,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        produk.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Center(
                      child: Text(
                        produk.kategori.name,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Harga Jual : ${formatRupiah(produk.sellingPrice)}',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Harga Modal : ${formatRupiah(produk.costPrice)}',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Stok : ${produk.stock}',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    // Only show compositions section if there are compositions
                    if (produk.compositions.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      const Text(
                        'Komposisi :',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: produk.compositions.length,
                        itemBuilder: (context, index) {
                          final composition = produk.compositions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${index + 1}. ${composition.namaKomposisi}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  '${composition.quantity} ${composition.satuan}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Close any open snackbars before navigation
                                if (Get.isSnackbarOpen) {
                                  Get.closeAllSnackbars();
                                }

                                // Navigate to edit view and wait for result
                                final result = await Get.to(
                                  () => const TambahProdukView(isEdit: true)
                                );

                                // Refresh the product details after editing
                                if (result != null && result is int && mounted) {
                                  // Result is the product ID
                                  // Add a small delay to ensure snackbars are cleared
                                  await Future.delayed(const Duration(milliseconds: 200));
                                  
                                  // Refresh the product detail using the returned ID
                                  await controller.fetchProdukById(result);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF4F4F4),
                                foregroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Edit produk',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Close any open snackbars immediately
                                if (Get.isSnackbarOpen) {
                                  Get.closeAllSnackbars();
                                }

                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmDialog(
                                      itemName: produk.name,
                                      confirmButtonColor:
                                          LightThemeColors.buttonColor,
                                      onConfirm: () async {
                                        // Close the confirmation dialog
                                        Get.back();

                                        // Close any open snackbars before deletion
                                        if (Get.isSnackbarOpen) {
                                          Get.closeAllSnackbars();
                                        }

                                        // Perform delete
                                        final success = await controller.deleteProduk(
                                            produk.id);

                                        if (success) {
                                          // Reset controller state
                                          controller.produk.value = null;

                                          // Refresh the product list
                                          await controller.fetchProduk();

                                          // Navigate back FIRST
                                          if (mounted) {
                                            Get.back(result: true);
                                          }

                                          // THEN show success message after a delay
                                          await Future.delayed(
                                              const Duration(milliseconds: 400));

                                          // Only show snackbar if context is still valid
                                          if (Get.context != null &&
                                              !Get.isSnackbarOpen) {
                                            Get.snackbar(
                                              'Berhasil',
                                              'Produk berhasil dihapus',
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration:
                                                  const Duration(seconds: 2),
                                              snackPosition: SnackPosition.TOP,
                                              margin: const EdgeInsets.all(10),
                                            );
                                          }
                                        } else {
                                          // Show error message with delay
                                          await Future.delayed(
                                              const Duration(milliseconds: 100));
                                          if (mounted && !Get.isSnackbarOpen) {
                                            Get.snackbar(
                                              'Error',
                                              controller.errorDelete.value
                                                  .isNotEmpty
                                                  ? controller.errorDelete.value
                                                  : 'Gagal menghapus produk',
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                              duration:
                                                  const Duration(seconds: 3),
                                              snackPosition: SnackPosition.TOP,
                                              margin: const EdgeInsets.all(10),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF4F4F4),
                                foregroundColor: Colors.grey[600],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Hapus produk',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}