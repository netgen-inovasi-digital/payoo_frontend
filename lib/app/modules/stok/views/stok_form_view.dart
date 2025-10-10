import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/components/custom_snackbar.dart';
import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/modules/stok/views/widgets/stok_info.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/components/custom_app_bar.dart';

class StokFormView extends StatefulWidget {
  final ProductWithStock stok;
  const StokFormView({super.key, required this.stok});

  @override
  State<StokFormView> createState() => _StokFormViewState();
}

class _StokFormViewState extends State<StokFormView> {
  int _mode = 1; // 1: tambah, 2: kurangi
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final StokController stokController = Get.put(StokController());
  @override
  void initState() {
    super.initState();
    // Clear any previous validation errors when opening the form
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stokController.clearValidationErrors();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onSave() async {
    bool success;
    int currentQuantity =
        int.tryParse(stokController.quantityController.text) ?? 0;
    
    // Business rule validation for reducing stock
    if (_mode == 2 && currentQuantity > widget.stok.stock) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error', 
        message: 'Jumlah pengurangan melebihi stok yang ada'
      );
      return;
    }

    // Create stock entry
    if (_mode == 1) {
      success = await stokController.createStock(widget.stok.id, 'in');
    } else {
      success = await stokController.createStock(widget.stok.id, 'out');
    }

    if (success) {
      // Reset form after success
      stokController.resetForm();
      
      // Navigate back using route name
      Get.back();
      Get.back();
      // Refresh the products with stock data 
      stokController.fetchProductsWithStock();
      
      // Show success message
      CustomSnackBar.showCustomSnackBar(
        title: 'Sukses', 
        message: 'Stok berhasil diperbarui'
      );
    } else {
      // Check if it's a validation error or API error
      if (stokController.errorCreate.value.isNotEmpty) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Gagal Memperbarui', 
          message: stokController.errorCreate.value
        );
      }
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      helpText: 'Pilih Tanggal',
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
        helpText: 'Pilih Jam',
      );
      setState(() {
        _selectedDate = pickedDate;
        _selectedTime = pickedTime;
        String dateStr =
            '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
        String timeStr = pickedTime != null ? pickedTime.format(context) : '';
        stokController.dateController.text =
            timeStr.isNotEmpty ? '$dateStr $timeStr' : dateStr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stok = widget.stok;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Manajemen Stok',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StokInfo(stok: stok),
            const SizedBox(height: 16),
            Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _mode,
                  onChanged: (val) => setState(() => _mode = val ?? 1),
                  activeColor: const Color(0xFF36A86F),
                ),
                const Text('Tambah'),
                const SizedBox(width: 16),
                Radio<int>(
                  value: 2,
                  groupValue: _mode,
                  onChanged: (val) => setState(() => _mode = val ?? 2),
                  activeColor: const Color(0xFF36A86F),
                ),
                const Text('Kurangi'),
              ],
            ),
            const SizedBox(height: 16),

            // Date picker
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: Obx(() => CustomTextField(
                  hintText: 'Tanggal*',
                  controller: stokController.dateController,
                  width: double.infinity,
                  height: 50,
                  suffixIcon: const Icon(Icons.calendar_today, size: 18),
                  hasError: stokController.hasAttemptedSubmit.value && 
                           stokController.dateError.value.isNotEmpty,
                  errorText: stokController.dateError.value,
                )),
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => CustomTextField(
              hintText: 'Jumlah Stok*',
              controller: stokController.quantityController,
              keyboardType: TextInputType.number,
              width: double.infinity,
              height: 50,
              hasError: stokController.hasAttemptedSubmit.value && 
                       stokController.quantityError.value.isNotEmpty,
              errorText: stokController.quantityError.value,
            )),
            const SizedBox(height: 16),

            // Buy Price field - only show when mode is "Tambah" (in)
            if (_mode == 1) ...[
              Obx(() => CustomTextField(
                hintText: 'Harga Beli*',
                controller: stokController.buyPriceController,
                keyboardType: TextInputType.number,
                width: double.infinity,
                height: 50,
                hasError: stokController.hasAttemptedSubmit.value && 
                         stokController.buyPriceError.value.isNotEmpty,
                errorText: stokController.buyPriceError.value,
              )),
              const SizedBox(height: 16),
            ],

            // Notes field - always show
            Obx(() => CustomTextField(
              hintText: 'Catatan',
              controller: stokController.notesController,
              width: double.infinity,
              height: 80,
              hasError: stokController.hasAttemptedSubmit.value && 
                       stokController.notesError.value.isNotEmpty,
              errorText: stokController.notesError.value,
            )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Obx(() {
          final isLoading = stokController.statusCreate.value == ApiCallStatus.loading;
          return CustomSaveButton(
            onPressed: () {
              if (isLoading) return; // guard
              onSave();
            },
            label: isLoading
                ? 'Menyimpan...'
                : 'SIMPAN',
          );
        }),
      ),
    );
  }
}
