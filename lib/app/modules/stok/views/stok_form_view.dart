import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_app_bar_secondary.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/modules/stok/views/widgets/stok_info.dart';

class StokFormView extends StatefulWidget {
  final Map<String, dynamic> stok;
  const StokFormView({super.key, required this.stok});

  @override
  State<StokFormView> createState() => _StokFormViewState();
}

class _StokFormViewState extends State<StokFormView> {
  int _mode = 1; // 1: tambah, 2: kurangi
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _jumlahController.dispose();
    _hargaController.dispose();
    _dateController.dispose();
    super.dispose();
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
        String dateStr = '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
        String timeStr = pickedTime != null ? pickedTime.format(context) : '';
        _dateController.text = timeStr.isNotEmpty ? '$dateStr $timeStr' : dateStr;
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
            if (_mode == 1) ...[
              // Date picker
              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    hintText: 'Tanggal',
                    controller: _dateController,
                    width: double.infinity,
                    height: 50,
                    suffixIcon: const Icon(Icons.calendar_today, size: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Harga',
                controller: _hargaController,
                keyboardType: TextInputType.number,
                width: double.infinity,
                height: 50,
              ),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              hintText: 'Stok',
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              width: double.infinity,
              height: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: CustomButton(
          label: 'SIMPAN',
          onPressed: () {
            // TODO: Simpan perubahan stok
            Navigator.of(context).pop();
          },
          width: double.infinity,
          height: 54,
        ),
      ),
    );
  }
}
