import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/currency_input.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/custom_snackbar.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/components/custom_app_bar.dart';

class StokFormView extends StatefulWidget {
  const StokFormView({super.key});

  @override
  State<StokFormView> createState() => _StokFormViewState();
}

class _StokFormViewState extends State<StokFormView> {
  static const int _modeAdd = 1;
  static const int _modeSubtract = 2;

  int _mode = _modeAdd;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _selectedProdukId = 0;

  late final ProdukController _produkController;
  late final StokController _stokController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _stokController = Get.isRegistered<StokController>() 
        ? Get.find<StokController>() 
        : Get.put(StokController());
        
    _produkController = Get.put(ProdukController(), permanent: false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _produkController.fetchProduk();
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

    // Validate date and time selection
    if (_selectedDate == null || _selectedTime == null) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal',
        message: 'Silakan pilih tanggal dan waktu terlebih dahulu',
      );
      return;
    }

    // Set the date in ISO format for API
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    _stokController.dateController.text = 
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00';

    final stockType = _mode == _modeAdd ? 'in' : 'out';
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
      _mode = _modeAdd;
    });
    
    Get.back(result: true);
    
    CustomSnackBar.showCustomSnackBar(
      title: 'Sukses',
      message: 'Stok berhasil diperbarui',
    );
  }

  void _handleSaveError() {
    if (_stokController.errorCreate.value.isNotEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Gagal Memperbarui',
        message: _stokController.errorCreate.value,
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
      if (pickedTime != null) {
        final displayFormat = _formatDateTimeForDisplay(pickedDate, pickedTime);
        _stokController.dateController.text = displayFormat;
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
      appBar: const CustomAppBar(title: 'Manajemen Stok'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildModeSelector(),
            const SizedBox(height: 16),
            _buildProdukDropdownWrapper(),
            const SizedBox(height: 16),
            _buildDatePicker(context),
            const SizedBox(height: 16),
            _buildQuantityField(),
            const SizedBox(height: 16),
            if (_mode == _modeAdd) ...[
              _buildBuyPriceField(),
              const SizedBox(height: 16),
            ],
            _buildNotesField(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      children: [
        _buildRadioOption(_modeAdd, 'Tambah'),
        const SizedBox(width: 16),
        _buildRadioOption(_modeSubtract, 'Kurangi'),
      ],
    );
  }

  Widget _buildRadioOption(int value, String label) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: _mode,
          onChanged: (val) => setState(() => _mode = val ?? _modeAdd),
          activeColor: const Color(0xFF36A86F),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildProdukDropdownWrapper() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Obx(() {
        final status = _produkController.statusList.value;
        
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
            onPressed: () => _produkController.fetchProduk(),
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
      if (_produkController.list.isEmpty) {
        return _buildEmptyState('Tidak ada produk tersedia');
      }

      final uniqueProduk = _produkController.list.toSet().toList();
      final selectedValue = _getValidatedSelectedValue(uniqueProduk);

      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: const Text(
            'Produk*',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
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
    final exists = uniqueProduk.any((produk) => produk.id.toString() == selectedValue);
    
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
          final hasError = _stokController.hasAttemptedSubmit.value &&
              _stokController.dateError.value.isNotEmpty;
          
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
                  controller: _stokController.dateController,
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
                    _stokController.dateError.value,
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
      final hasError = _stokController.hasAttemptedSubmit.value &&
          _stokController.quantityError.value.isNotEmpty;
      
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
              controller: _stokController.quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                hintText: 'Jumlah Stok*',
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
                _stokController.quantityError.value,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBuyPriceField() {
    return Obx(() {
      final hasError = _stokController.hasAttemptedSubmit.value &&
          _stokController.buyPriceError.value.isNotEmpty;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrencyInput(
            label: '',
            valueController: _stokController.buyPriceController,
            hintText: "Harga Beli*",
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 4),
              child: Text(
                _stokController.buyPriceError.value,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildNotesField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _stokController.notesController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Catatan',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Obx(() {
        final isLoading = _stokController.statusCreate.value == ApiCallStatus.loading;
        return CustomSaveButton(
          onPressed: _onSave,
          label: isLoading ? 'Menyimpan...' : 'SIMPAN',
        );
      }),
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<ProdukController>()) {
      try {
        Get.delete<ProdukController>();
      } catch (e) {}
    }
    super.dispose();
  }
}