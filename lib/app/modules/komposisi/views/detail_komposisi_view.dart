import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/confirm_dialog.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/komposisi/views/tambah_komposisi_view.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class DetailKomposisiView extends StatelessWidget {
  const DetailKomposisiView({super.key, required this.komposisi});
  final Komposisi komposisi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Komposisi'),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildDetailRow(
                label: 'Nama komposisi', value: komposisi.namaKomposisi),
            const SizedBox(height: 12),
            _buildDetailRow(
                label: 'Harga modal', value: 'Rp. ${komposisi.hargaModal}'),
            const SizedBox(height: 12),
            _buildDetailRow(
                label: 'Harga jual', value: 'Rp. ${komposisi.hargaJual}'),
            const SizedBox(height: 12),
            _buildDetailRow(
                label: 'Stok komposisi', value: '${komposisi.stokKomposisi}'),
            const SizedBox(height: 12),
            _buildDetailRow(label: 'satuan', value: komposisi.satuan),
            const SizedBox(height: 32),
            _buildActionButton(
              text: 'edit komposisi',
              backgroundColor: Colors.grey[200]!,
              textColor: Colors.green,
              icon: Icons.chevron_right,
              onPressed: () {
                // Handle edit komposisi action
                Get.to(() => TambahKomposisiView(komposisi: komposisi));
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton( 
              text: 'hapus komposisi',
              backgroundColor: Colors.grey[200]!,
              textColor: Colors.grey,
              icon: null,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                        itemName: komposisi.namaKomposisi,
                        confirmButtonColor: LightThemeColors.buttonColor,
                        onConfirm: () {
                          // Add your delete logic here
                        });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label : $value',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String text,
      required Color backgroundColor,
      required Color textColor,
      IconData? icon,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (icon != null)
              Icon(
                icon,
                color: textColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
