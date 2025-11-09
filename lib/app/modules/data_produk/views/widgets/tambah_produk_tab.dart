// File: lib/app/modules/data_produk/views/widgets/tambah_produk_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payoo/app/components/currency_input.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/kategori/controllers/kategori_controller.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/pembayaran_modal.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/image_upload_service.dart';

class TambahProdukTab extends StatefulWidget {
  final bool isEdit;
  final VoidCallback? onNextTab;

  const TambahProdukTab({
    super.key,
    this.onNextTab,
    this.isEdit = false,
  });

  @override
  State<TambahProdukTab> createState() => _TambahProdukTabState();
}

class _TambahProdukTabState extends State<TambahProdukTab>
    with AutomaticKeepAliveClientMixin {
  final ProdukController controller = Get.find<ProdukController>();
  final KategoriController kategoriController =
      Get.put<KategoriController>(KategoriController());
  final ImageUploadService imageController =
      Get.put<ImageUploadService>(ImageUploadService());

  // Flag to prevent multiple submissions
  bool _isSubmitting = false;

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadProdukCategories() async {
    if (kategoriController.list.isEmpty) {
      await kategoriController.fetchKategori();
    }
    if (controller.produk.value == null) {
      controller.resetCreateForm();
    } else {
      controller.setFormFromProduk(controller.produk.value!);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _loadProdukCategories();
    } else {
      controller.resetCreateForm();
    }
  }

  @override
  void dispose() {
    _isSubmitting = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildImageUpload(imageController, controller),
            const SizedBox(height: 40),
            _buildTextField('nama produk*', controller.namaController),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            _buildTextField('Stok*', controller.stokController, isNumber: true),
            const SizedBox(height: 16),
            CurrencyInput(
              valueController: controller.hargaJualController,
              hintText: 'harga jual*',
              enabled: true,
              label: '',
            ),
            const SizedBox(height: 16),
            CurrencyInput(
              valueController: controller.hargaModalController,
              hintText: 'harga modal*',
              enabled: true,
              label: '',
            ),
            // Komposisi info section
            GetBuilder<ProdukController>(
              id: 'komposisi_info',
              builder: (ctrl) {
                if (ctrl.selectedKomposisi.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _buildKomposisiInfo(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 80),

            Obx(() {
              final isCreateLoading =
                  controller.statusCreate.value == ApiCallStatus.loading;
              final isUpdateLoading =
                  controller.statusUpdate.value == ApiCallStatus.loading;
              final isLoading =
                  isCreateLoading || isUpdateLoading || _isSubmitting;

              return CustomSaveButton(
                onPressed: isLoading ? () {} : () => _submitProduk(),
                label: isLoading ? 'MENYIMPAN...' : 'SIMPAN',
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKomposisiInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Komposisi (${controller.selectedKomposisi.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2FA36B),
                ),
              ),
              if (widget.onNextTab != null)
                GestureDetector(
                  onTap: widget.onNextTab,
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Color(0xFF2FA36B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...controller.selectedKomposisi.take(3).map(
                (komposisi) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '• ${komposisi.namaKomposisi}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
          if (controller.selectedKomposisi.length > 3)
            Text(
              'dan ${controller.selectedKomposisi.length - 3} lainnya...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submitProduk() async {
    // Prevent multiple submissions
    if (_isSubmitting) return;

    // Close any open snackbars first
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // Comprehensive input validation
    if (controller.namaController.text.trim().isEmpty) {
      _showErrorSnackbar('Nama produk harus diisi');
      return;
    }

    if (controller.selectedKategoriId.value.isEmpty) {
      _showErrorSnackbar('Kategori produk harus dipilih');
      return;
    }

    if (controller.hargaJualController.text.trim().isEmpty) {
      _showErrorSnackbar('Harga jual harus diisi');
      return;
    }

    if (controller.hargaModalController.text.trim().isEmpty) {
      _showErrorSnackbar('Harga modal harus diisi');
      return;
    }

    // Validate price format
    final hargaJual =
        double.tryParse(controller.hargaJualController.text.trim());
    if (hargaJual == null || hargaJual <= 0) {
      _showErrorSnackbar(
          'Harga jual harus berupa angka yang valid dan lebih dari 0');
      return;
    }

    // Validate modal price
    final hargaModal =
        double.tryParse(controller.hargaModalController.text.trim());
    if (hargaModal == null || hargaModal < 0) {
      _showErrorSnackbar('Harga modal harus berupa angka yang valid');
      return;
    }

    // Set submitting flag
    setState(() {
      _isSubmitting = true;
    });

    // Set selected category to controller
    controller.setKategori(controller.selectedKategoriId.value);

    bool success = false;

    try {
      // Submit produk
      if (!widget.isEdit) {
        success = await controller.createProduk();
      } else {
        success = await controller.updateProduk(controller.produk.value!.id);
      }

      // Reset submitting flag
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }

      if (success) {
        // Store the product ID before closing snackbars
        final int? productId = controller.produk.value?.id;
        
        // Close all snackbars before navigation
        Get.closeAllSnackbars();

        // Refresh product list
        await controller.fetchProduk();

        // Navigate back based on edit mode
        if (mounted) {
          if (widget.isEdit && productId != null) {
            // For edit mode: Go back with result and pass the product ID
            Get.back(result: productId);
          } else {
            // For create mode: Just go back to list
            Get.back(result: true);
          }
        }

        // Reset form after navigation
        controller.resetCreateForm();

        // Show success message after navigation
        await Future.delayed(const Duration(milliseconds: 400));
        if (Get.context != null && !Get.isSnackbarOpen) {
          Get.snackbar(
            'Berhasil',
            widget.isEdit
                ? 'Produk berhasil diperbarui'
                : 'Produk berhasil ditambahkan',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(10),
          );
        }
      } else {
        final errorMessage = widget.isEdit
            ? controller.errorUpdate.value
            : controller.errorCreate.value;

        _showErrorSnackbar(errorMessage.isNotEmpty
            ? errorMessage
            : 'Gagal ${widget.isEdit ? "memperbarui" : "menambahkan"} produk');
      }
    } catch (e) {
      // Reset submitting flag on error
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
      _showErrorSnackbar('Terjadi kesalahan: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    // Close existing snackbar if any
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    // Use Future.delayed to ensure previous snackbar is closed
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Get.snackbar(
          'Error',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(10),
        );
      }
    });
  }

  void _showSuccessSnackbar(String message) {
    // Close existing snackbar if any
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    // Use Future.delayed to ensure previous snackbar is closed
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Get.snackbar(
          'Berhasil',
          message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(10),
        );
      }
    });
  }

  Widget _buildImageUpload(
      ImageUploadService imageController, ProdukController controller) {
    return Center(
      child: GestureDetector(
        onTap: () {
          imageController.pickAndUploadImage(ImageSource.gallery, 'produk');
          imageController.uploadStatus.listen((status) {
            if (status == ApiCallStatus.success &&
                imageController.image.value != null) {
              controller.linkImage.value = imageController.image.value!.url;
            } else if (status == ApiCallStatus.error) {
              _showErrorSnackbar('Gagal mengunggah gambar');
            }
          });
        },
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey[300]!,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Obx(() {
                  if (imageController.uploadStatus.value ==
                      ApiCallStatus.loading) {
                    return const CircularProgressIndicator();
                  }
                  
                  // Get current image URL with validation
                  String? currentImageUrl;
                  
                  // Priority 1: Check linkImage from controller
                  if (controller.linkImage.value.isNotEmpty && 
                      controller.linkImage.value != 'file:///' &&
                      Uri.tryParse(controller.linkImage.value)?.hasScheme == true) {
                    currentImageUrl = controller.linkImage.value;
                  }
                  // Priority 2: Check produk photo
                  else if (controller.produk.value?.photo != null && 
                           controller.produk.value!.photo!.isNotEmpty &&
                           controller.produk.value!.photo != 'file:///' &&
                           Uri.tryParse(controller.produk.value!.photo!)?.hasScheme == true) {
                    currentImageUrl = controller.produk.value!.photo;
                  }

                  // Display image if valid URL exists
                  if (currentImageUrl != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        currentImageUrl,
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 40,
                                color: Colors.grey[500],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    // Show placeholder icon
                    return Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Colors.grey[500],
                    );
                  }
                }),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2FA36B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController? textController,
      {bool isNumber = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: textController,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Obx(() {
        if (kategoriController.statusList.value == ApiCallStatus.loading) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Memuat kategori...',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ),
          );
        }

        // Check if categories list is empty
        if (kategoriController.list.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Text(
              'Tidak ada kategori tersedia',
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
          );
        }

        // Get unique categories to avoid duplicates
        final uniqueKategori = kategoriController.list.toSet().toList();

        // Ensure selected value exists in the list
        String? selectedValue = controller.selectedKategoriId.value;
        if (selectedValue != null &&
            selectedValue.isNotEmpty &&
            !uniqueKategori
                .any((kategori) => kategori.id.toString() == selectedValue)) {
          selectedValue = null; // Reset if selected value doesn't exist in list
          controller.selectedKategoriId.value = '';
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue?.isNotEmpty == true ? selectedValue : null,
            hint: Text(
              'kategori produk*',
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down,
                color: Colors.grey, size: 20),
            items: uniqueKategori.map((kategori) {
              return DropdownMenuItem<String>(
                value: kategori.id.toString(),
                child: Text(
                  kategori.name ?? 'Unknown Category',
                  style: const TextStyle(fontSize: 15),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.selectedKategoriId.value = newValue;
              }
            },
          ),
        );
      }),
    );
  }
}
