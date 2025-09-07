import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/akun/views/akun_edit_view.dart';
import 'package:payoo/app/modules/akun/views/ganti_password_view.dart';
import 'package:payoo/app/modules/akun/views/widgets/custom_akun_text_field.dart';
import 'package:payoo/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:payoo/app/modules/dashboarduser/controllers/dashboard_user_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/theme/light_theme.dart';

class AkunForm extends StatelessWidget {
  const AkunForm({super.key, required this.isEditing, required this.userController});
  final bool isEditing;
  final DashboardUserController userController;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama akun field
          CustomAkunTextField(
            label: 'Nama akun*', 
            initialValue: '', // Not needed when using controller
            isEditing: isEditing,
            controller: userController.namaController, // Always pass controller
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),
          CustomAkunTextField(
            label: 'Email*', 
            initialValue: '', // Not needed when using controller
            isEditing: isEditing,
            controller: userController.emailController, // Always pass controller
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          CustomAkunTextField(
            label: 'Nomor ponsel*', 
            initialValue: '', // Not needed when using controller
            isEditing: isEditing,
            controller: userController.phoneController, // Always pass controller
            keyboardType: TextInputType.phone,
          ),
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
                  Get.to(AkunEditView());
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
            // Save button with loading state
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 50),
              child: CustomSaveButton(
                onPressed: userController.statusUpdate.value == ApiCallStatus.loading 
                  ? () {}
                  : _handleSave,
                label: userController.statusUpdate.value == ApiCallStatus.loading 
                  ? 'Menyimpan...' 
                  : 'Simpan',
              ),
            )),
            // Error message
            Obx(() {
              if (userController.statusUpdate.value == ApiCallStatus.error) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    userController.errorUpdate.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ]
        ],
      ),
    );
  }

  void _handleSave() async {
    // Validate fields
    if (userController.namaController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Nama akun tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (userController.emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (userController.phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Nomor ponsel tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Email validation
    if (!GetUtils.isEmail(userController.emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Phone validation (basic Indonesian phone number validation)
    final phone = userController.phoneController.text.trim();
    if (!RegExp(r'^(\+62|62|0)[0-9]{9,12}$').hasMatch(phone)) {
      Get.snackbar(
        'Error',
        'Format nomor ponsel tidak valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Reset any previous error
    userController.resetForm();

    // Call update user
    final success = await userController.updateUser();

    if (success) {
      Get.snackbar(
        'Sukses',
        'Data akun berhasil diperbarui',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Go back to previous screen
      Get.back();
    } else {
      // Error message is already set in controller
      Get.snackbar(
        'Error',
        'Gagal memperbarui data akun',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}