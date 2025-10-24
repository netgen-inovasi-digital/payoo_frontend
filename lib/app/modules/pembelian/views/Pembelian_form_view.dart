import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  late final KomposisiController _komposisiController;
  late final ProdukController _produkController;
  late final StokController _stokController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _produkController = Get.put<ProdukController>(ProdukController());
    _stokController = Get.find<StokController>();
    _komposisiController = Get.put<KomposisiController>(KomposisiController());
    _produkController.fetchProduk();
    _komposisiController.fetchKomposisi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stokController.clearValidationErrors();
    });
  }

  Future<void> _onSave() async {
    if (_stokController.statusCreate.value == ApiCallStatus.loading) return;

    // Validate product selection
    if (_selectedProdukId <= 0) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal',
        message: 'Silakan pilih produk terlebih dahulu',
      );
      return;
    }

    // Find the selected product
    final selectedProduct = _produkController.list.firstWhereOrNull(
      (produk) => produk.id == _selectedProdukId,
    );

    if (selectedProduct == null) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal',
        message: 'Produk tidak ditemukan',
      );
      return;
    }

    // Set the date in ISO format for API
    if (_selectedDate != null && _selectedTime != null) {
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      // Format as YYYY-MM-DD HH:mm:ss for API
      _stokController.dateController.text =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00';
    }

    const stockType = 'in';
    final success = await _stokController.createStock(
      _selectedProdukId,
      stockType,
      selectedProduct.name,
    );

    if (!mounted) return;

    if (success) {
      _handleSuccessfulSave();
    } else {
      _handleSaveError();
    }
  }

  void _handleSuccessfulSave() {
    _stokController.resetForm();

    setState(() {
      _selectedProdukId = 0;
      _selectedDate = null;
      _selectedTime = null;
    });

    Get.back();
    _stokController.fetchStockList();

    CustomSnackBar.showCustomSnackBar(
      title: 'Sukses',
      message: 'Pembelian berhasil diperbarui',
    );
  }

  void _handleSaveError() {
    if (_stokController.errorCreate.value.isNotEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal Memperbarui',
        message: _stokController.errorCreate.value,
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
      // Display format for user (DD-MM-YYYY HH:mm)
      final displayFormat = _formatDateTimeForDisplay(pickedDate, pickedTime);
      _stokController.dateController.text = displayFormat;
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
      appBar: const CustomAppBar(title: 'Manajemen Stok'),
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
            _buildNotesField(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProdukDropdownWrapper() {
    return Obx(() {
      final status = _produkController.statusList.value;

      if (status == ApiCallStatus.loading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (status == ApiCallStatus.error) {
        return Text(
          'Error: ${_produkController.errorList.value}',
          style: const TextStyle(color: Colors.red),
        );
      }

      return _buildProdukDropdown();
    });
  }

  Widget _buildProdukDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Obx(() {
        if (_produkController.list.isEmpty) {
          return _buildEmptyState('Tidak ada produk tersedia');
        }
        final uniqueKomposisi = _komposisiController.list.toSet().toList();
        final uniqueProduk = _produkController.list.toSet().toList();
        final selectedValue = _getValidatedSelectedValue(uniqueProduk);

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            hint: Text(
              'Produk*',
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
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
      }),
    );
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
        child: Obx(() => CustomTextField(
              hintText: 'Tanggal*',
              controller: _stokController.dateController,
              width: double.infinity,
              height: 50,
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
              hasError: _stokController.hasAttemptedSubmit.value &&
                  _stokController.dateError.value.isNotEmpty,
              errorText: _stokController.dateError.value,
            )),
      ),
    );
  }

  Widget _buildQuantityField() {
    return Obx(() => CustomTextField(
          hintText: 'Jumlah Stok*',
          controller: _stokController.quantityController,
          keyboardType: TextInputType.number,
          width: double.infinity,
          height: 50,
          hasError: _stokController.hasAttemptedSubmit.value &&
              _stokController.quantityError.value.isNotEmpty,
          errorText: _stokController.quantityError.value,
        ));
  }

  Widget _buildBuyPriceField() {
    return Obx(() => CustomTextField(
          hintText: 'Harga Beli*',
          controller: _stokController.buyPriceController,
          keyboardType: TextInputType.number,
          width: double.infinity,
          height: 50,
          hasError: _stokController.hasAttemptedSubmit.value &&
              _stokController.buyPriceError.value.isNotEmpty,
          errorText: _stokController.buyPriceError.value,
        ));
  }

  Widget _buildNotesField() {
    return Obx(() => CustomTextField(
          hintText: 'Catatan',
          controller: _stokController.notesController,
          width: double.infinity,
          height: 80,
          hasError: _stokController.hasAttemptedSubmit.value &&
              _stokController.notesError.value.isNotEmpty,
          errorText: _stokController.notesError.value,
        ));
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Obx(() {
        final isLoading =
            _stokController.statusCreate.value == ApiCallStatus.loading;
        return CustomSaveButton(
          onPressed: _onSave,
          label: isLoading ? 'Menyimpan...' : 'SIMPAN',
        );
      }),
    );
  }
}
