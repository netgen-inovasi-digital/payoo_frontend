import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_editable_image.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/akun/views/widgets/akun_form.dart';
import 'package:payoo/app/modules/akun/views/widgets/custom_akun_text_field.dart';
import 'package:payoo/config/theme/light_theme.dart';

class GantiPasswordView extends StatelessWidget {
  const GantiPasswordView({super.key});

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
                  imageUrl:
                      'http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcR0NrOJEpfjkM0zxD-aO9b-bWqW3mhY57jPMg3aSbxTYO__R4jOvx8T2Oa7Fm9yxXOGg4B_ns3SZaZGCiBOPQw',
                  onEdit: () {
                    print("Edit button tapped");
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
                        const CustomAkunTextField(
                          label: 'Password Lama*',
                          initialValue: '',
                        ),
                        const SizedBox(height: 20),
                        const CustomAkunTextField(
                          label: 'Password Baru*',
                          initialValue: '',
                        ),
                        const SizedBox(height: 90),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 50),
                          child:
                              CustomSaveButton(onPressed: () {}, label: 'Simpan'),
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
