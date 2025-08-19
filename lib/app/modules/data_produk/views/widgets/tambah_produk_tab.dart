import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/routes/app_pages.dart';

class TambahProdukTab extends StatelessWidget {
  const TambahProdukTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildImageUpload(),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined,
                    color: Color(0xFF2FA36B), size: 22),
                SizedBox(width: 32),
                Icon(Icons.image_outlined, color: Color(0xFF2FA36B), size: 22),
              ],
            ),
            const SizedBox(height: 40),
            _buildTextField('nama produk*'),
            const SizedBox(height: 16),
            _buildDropdownField('kategori produk*'),
            const SizedBox(height: 16),
            _buildTextField('harga jual*'),
            const SizedBox(height: 16),
            _buildTextField('harga modal'),
            const SizedBox(height: 16),
            _buildTextField('stok'),
            const SizedBox(height: 80),
            CustomSaveButton(
                onPressed: () {
                  Get.toNamed(Routes.DASHBOARD);
                },
                label: 'SIMPAN'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUpload() {
    return Center(
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Center(
              child:
                  Icon(Icons.image_outlined, size: 40, color: Colors.grey[500]),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, size: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
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

  Widget _buildDropdownField(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 15)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
