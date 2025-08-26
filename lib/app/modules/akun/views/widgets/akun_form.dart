import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/akun/views/akun_edit_view.dart';
import 'package:payoo/app/modules/akun/views/ganti_password_view.dart';
import 'package:payoo/app/modules/akun/views/widgets/custom_akun_text_field.dart';
import 'package:payoo/config/theme/light_theme.dart';

class AkunForm extends StatelessWidget {
  const AkunForm({super.key, required this.isEditing});
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama akun field
          CustomAkunTextField(label: 'Nama akun*', initialValue: 'Setyo WS', isEditing: isEditing),
          const SizedBox(height: 20),

          CustomAkunTextField(label: 'Email*', initialValue: 'setyo@gmail.com', isEditing: isEditing),
          const SizedBox(height: 20),

          CustomAkunTextField(label: 'Nomor ponsel*', initialValue: '0819-9656-9998', isEditing: isEditing),
          const SizedBox(height: 40),

          // Buttons - only show when not editing
          if (!isEditing) ...[
            // Edit Data Akun button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle edit data akun
                  Get.to(const AkunEditView());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightThemeColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Edit Data Akun',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ganti Password button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle ganti password
                  Get.to(const GantiPasswordView());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Ganti Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ]
          else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:80, vertical: 50),
              child: CustomSaveButton(onPressed: (){}, label: 'Simpan'),
            )
          ]
          
        ],
      ),
    );
  }
}
