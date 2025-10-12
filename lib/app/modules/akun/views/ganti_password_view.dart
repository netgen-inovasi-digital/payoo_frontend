import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_editable_image.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/akun/views/widgets/akun_form.dart';
import 'package:payoo/app/modules/akun/views/widgets/custom_akun_text_field.dart';
import 'package:payoo/config/theme/light_theme.dart';

class GantiPasswordView extends GetView<AkunController> {
  const GantiPasswordView({super.key});

  _changePassword() async {
    if (controller.oldPasswordController.text.isEmpty || controller.newPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    bool success = await controller.changePassword();
    if (success) {

      Get.snackbar('Success', 'Password berhasil diubah',
          snackPosition: SnackPosition.BOTTOM);
      Get.back(); // Go back to the previous screen
    } else {
      Get.snackbar('Error', controller.errorUpdate.value,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Ganti Password',
      ),
      body: Stack(
        children: [
          // Top background
          Container(
            height: 500,
            color: LightThemeColors.primaryColor,
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Editable image
                EditableImage(
                  isEditable: false,
                  photo:
                     controller.user.value?.photo ?? 'http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcR0NrOJEpfjkM0zxD-aO9b-bWqW3mhY57jPMg3aSbxTYO__R4jOvx8T2Oa7Fm9yxXOGg4B_ns3SZaZGCiBOPQw',
                  onEdit: () {
                  },
                ),
                const SizedBox(height: 60),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama akun field
                        CustomAkunTextField(
                          controller: controller.oldPasswordController,
                          label: 'Password Lama*',
                          initialValue: '',
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(height: 20),
                        CustomAkunTextField(
                          controller: controller.newPasswordController,
                          label: 'Password Baru*',  
                          initialValue: '',
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(height: 90),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 50),
                          child:
                              CustomSaveButton(onPressed: () {_changePassword();}, label: 'Simpan'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
