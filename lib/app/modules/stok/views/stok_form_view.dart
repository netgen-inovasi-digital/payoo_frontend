import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar_secondary.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/stok/controllers/stok_controller.dart';
import 'package:payoo/app/modules/stok/views/widgets/stok_info.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';

class StokFormView extends StatefulWidget {
  final Komposisi stok;
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
  void dispose() {
    super.dispose();
  }

  Future<void> onSave() async {
    bool success;
    int currentQuantity =
        int.tryParse(stokController.quantityController.text) ?? 0;
    if (_mode == 1) {
      success = await stokController.createStock(widget.stok.id, 'in');
    } else {
      if (currentQuantity > widget.stok.stokKomposisi) {
        Get.snackbar('Error', 'Jumlah pengurangan melebihi stok yang ada',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }
      success = await stokController.createStock(widget.stok.id, 'out');
    }
    if (success) {
      Get.toNamed(Routes.STOK);
      Get.snackbar('Sukses', 'Stok berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Gagal memperbarui stok',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
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
      appBar: const CustomAppBarSecondary(
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
                child: CustomTextField(
                  hintText: 'Tanggal',
                  controller: stokController.dateController,
                  width: double.infinity,
                  height: 50,
                  suffixIcon: const Icon(Icons.calendar_today, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              hintText: 'Stok',
              controller: stokController.quantityController,
              keyboardType: TextInputType.number,
              width: double.infinity,
              height: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Obx(
          () => CustomButton(
            label: stokController.statusCreate.value == ApiCallStatus.loading
                ? 'Menyimpan...'
                : 'SIMPAN',
            onPressed: () {
              onSave();
            },
            width: double.infinity,
            height: 54,
          ),
        ),
      ),
    );
  }
}
