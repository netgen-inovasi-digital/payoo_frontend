import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/currency_input.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/custom_snackbar.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/komposisi/controllers/komposisi_controller.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/components/custom_app_bar.dart';

class PembelianFormView extends StatefulWidget {
  const PembelianFormView({super.key});

  @override
  State<PembelianFormView> createState() => _PembelianFormViewState();
}

class _PembelianFormViewState extends State<PembelianFormView> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _selectedProdukId = 0;
  
late final ProdukController _produkController;
late final KomposisiController _komposisiController;
late final StokController _stokController;

@override
void initState() {
  super.initState();
  
  // Get or create controllers
  _stokController = Get.isRegistered<StokController>() 
      ? Get.find<StokController>() 
      : Get.put(StokController());
      
  _produkController = Get.put(ProdukController(), permanent: false);
  _komposisiController = Get.put(KomposisiController(), permanent: false);
  
  // Fetch data
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _produkController.fetchProduk();
    _komposisiController.fetchKomposisi();
    _stokController.clearValidationErrors();
  });
}
  void _fetchData() {
    if (_produkController == null || _komposisiController == null) return;
    
    _produkController!.fetchProduk().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        if (mounted) {
          CustomSnackBar.showCustomErrorSnackBar(
            title: 'Timeout',
            message: 'Gagal memuat produk. Silakan coba lagi.',
          );
        }
        return Future.value();
      },
    ).then((_) {
    }).catchError((error) {
      if (mounted) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error',
          message: 'Gagal memuat produk: $error',
        );
      }
    });

    _komposisiController!.fetchKomposisi().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        return Future.value();
      },
    ).catchError((error) {
    });
  }

  Future<void> _onSave() async {
    
    if (_stokController == null || _produkController == null) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Controller tidak tersedia',
      );
      return;
    }

    if (_stokController!.statusCreate.value == ApiCallStatus.loading) {
      return;
    }

    // Validate product selection
    if (_selectedProdukId <= 0) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal',
        message: 'Silakan pilih produk terlebih dahulu',
      );
      return;
    }

    // Find the selected product
    final selectedProduct = _produkController!.list.firstWhereOrNull(
      (produk) => produk.id == _selectedProdukId,
    );

    if (selectedProduct == null) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal',
        message: 'Produk tidak ditemukan',
      );
      return;
    }

    // Validate date and time selection
    if (_selectedDate == null || _selectedTime == null) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal',
        message: 'Silakan pilih tanggal dan waktu terlebih dahulu',
      );
      return;
    }

    // Format date and time for API
    try {
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      
      _stokController!.dateController.text =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00';
      
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Gagal memformat tanggal',
      );
      return;
    }

    const stockType = 'in';
    
    bool success = false;
    try {
      success = await _stokController!.createStock(
        _selectedProdukId,
        stockType,
        selectedProduct.name,
      );
    } catch (e, stackTrace) {
      if (mounted) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error',
          message: 'Terjadi kesalahan: ${e.toString()}',
        );
      }
      return;
    }

    if (!mounted) {
      return;
    }

    if (success) {
      _handleSuccessfulSave();
    } else {
      _handleSaveError();
    }
  }

  void _handleSuccessfulSave() {
    _stokController?.resetForm();

    setState(() {
      _selectedProdukId = 0;
      _selectedDate = null;
      _selectedTime = null;
    });

    Get.back(result: true);
    CustomSnackBar.showCustomSnackBar(
      title: 'Sukses',
      message: 'Pembelian berhasil diperbarui',
    );
  }

  void _handleSaveError() {
    if (_stokController?.errorCreate.value.isNotEmpty ?? false) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal Memperbarui',
        message: _stokController!.errorCreate.value,
      );
    } else {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal',
        message: 'Terjadi kesalahan saat menyimpan data',
      );
    }
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      helpText: 'Pilih Tanggal',
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Pilih Jam',
    );

    if (!mounted) return;

    setState(() {
      _selectedDate = pickedDate;
      _selectedTime = pickedTime;
      if (_stokController != null && pickedTime != null) {
        final displayFormat = _formatDateTimeForDisplay(pickedDate, pickedTime);
        _stokController!.dateController.text = displayFormat;
      }
    });
  }

  String _formatDateTimeForDisplay(DateTime date, TimeOfDay? time) {
    final dateStr = '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-${date.year}';

    if (time != null) {
      final timeStr = '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
      return '$dateStr $timeStr';
    }
    return dateStr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Manajemen Pembelian'),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildProdukDropdownWrapper(),
                  const SizedBox(height: 16),
                  _buildDatePicker(context),
                  const SizedBox(height: 16),
                  _buildQuantityField(),
                  const SizedBox(height: 16),
                  _buildBuyPriceField(),
                  const SizedBox(height: 16),
                  _buildTextField("Catatan", _stokController!.notesController),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProdukDropdownWrapper() {
    if (_produkController == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Text('Memuat...'),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Obx(() {
        final status = _produkController!.statusList.value;

        if (status == ApiCallStatus.loading) {
          return _buildLoadingState();
        }

        if (status == ApiCallStatus.error) {
          return _buildErrorState();
        }

        return _buildProdukDropdownContent();
      }),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Memuat produk...',
            style: TextStyle(color: Colors.grey[600], fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Gagal memuat produk',
              style: TextStyle(color: Colors.red[700], fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => _fetchData(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProdukDropdownContent() {
    return Obx(() {
      if (_produkController!.list.isEmpty) {
        return _buildEmptyState('Tidak ada produk tersedia');
      }

      final uniqueProduk = _produkController!.list.toSet().toList();
      final selectedValue = _getValidatedSelectedValue(uniqueProduk);

      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: const Text(
            'Produk*',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Colors.grey, size: 20),
          items: uniqueProduk.map((produk) {
            return DropdownMenuItem<String>(
              value: produk.id.toString(),
              child: Text(
                produk.name,
                style: const TextStyle(fontSize: 15),
              ),
            );
          }).toList(),
          onChanged: _onProdukChanged,
        ),
      );
    });
  }

  String? _getValidatedSelectedValue(List<dynamic> uniqueProduk) {
    if (_selectedProdukId <= 0) return null;

    final selectedValue = _selectedProdukId.toString();
    final exists =
        uniqueProduk.any((produk) => produk.id.toString() == selectedValue);

    if (!exists) {
      _selectedProdukId = 0;
      return null;
    }

    return selectedValue;
  }

  void _onProdukChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedProdukId = int.tryParse(newValue) ?? 0;
      });
    }
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[500], fontSize: 15),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDateTime(context),
      child: AbsorbPointer(
        child: Obx(() {
          final hasError = _stokController!.hasAttemptedSubmit.value &&
              _stokController!.dateError.value.isNotEmpty;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: hasError
                      ? Border.all(color: Colors.red, width: 1)
                      : null,
                ),
                child: TextField(
                  controller: _stokController!.dateController,
                  decoration: InputDecoration(
                    hintText: 'Tanggal*',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    suffixIcon: Icon(Icons.calendar_today_outlined,
                        color: Colors.grey[500]),
                  ),
                ),
              ),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 4),
                  child: Text(
                    _stokController!.dateError.value,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQuantityField() {
    return Obx(() {
      final hasError = _stokController!.hasAttemptedSubmit.value &&
          _stokController!.quantityError.value.isNotEmpty;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
              border: hasError
                  ? Border.all(color: Colors.red, width: 1)
                  : null,
            ),
            child: TextField(
              controller: _stokController!.quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                hintText: 'Jumlah Pembelian*',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 4),
              child: Text(
                _stokController!.quantityError.value,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBuyPriceField() {
    return Obx(() {
      final hasError = _stokController!.hasAttemptedSubmit.value &&
          _stokController!.buyPriceError.value.isNotEmpty;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrencyInput(
            label: '',
            valueController: _stokController!.buyPriceController,
            hintText: "Harga Beli*",
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 4),
              child: Text(
                _stokController!.buyPriceError.value,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, Widget? icon}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: icon,
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    if (_stokController == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Obx(() {
        final isLoading =
            _stokController!.statusCreate.value == ApiCallStatus.loading;
        return CustomSaveButton(
          onPressed:_onSave,
          label: isLoading ? 'Menyimpan...' : 'SIMPAN',
        );
      }),
    );
  }

  @override
  void dispose() {
    // Clean up controllers if we created them
    if (_produkController != null && Get.isRegistered<ProdukController>()) {
      try {
        Get.delete<ProdukController>();
      } catch (e) {
      }
    }
    
    if (_komposisiController != null && Get.isRegistered<KomposisiController>()) {
      try {
        Get.delete<KomposisiController>();
      } catch (e) {
      }
    }
    super.dispose();
  }
}