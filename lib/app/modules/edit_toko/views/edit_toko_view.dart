import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_editable_image.dart';
import 'package:payoo/app/modules/edit_toko/views/widgets/form_edit_toko.dart';
import 'package:payoo/app/modules/toko/controllers/toko_controller.dart';
import 'package:payoo/app/services/image_upload_service.dart';
import 'package:payoo/config/theme/light_theme.dart';

class EditTokoView extends StatefulWidget {
  const EditTokoView({super.key});

  @override
  State<EditTokoView> createState() => _EditTokoViewState();
}

class _EditTokoViewState extends State<EditTokoView> {
  bool belumDaftar = true;
  final TokoController controller = TokoController();
  ImageUploadService imageUploadService = ImageUploadService();

  @override
  void initState() {
    super.initState();
    controller.akunController.fetchUser();
    controller.fetchTokoById(controller.akunController.user.value?.shopId ?? 0);
  }

  void _toggleWidget() {
    setState(() {
      belumDaftar = !belumDaftar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Edit Toko',
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
                Obx(
                  () => EditableImage(
                    photo:
                      controller.toko.value?.photo != null && controller.toko.value!.photo.isNotEmpty ? controller.toko.value!.photo : 'http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcR0NrOJEpfjkM0zxD-aO9b-bWqW3mhY57jPMg3aSbxTYO__R4jOvx8T2Oa7Fm9yxXOGg4B_ns3SZaZGCiBOPQw',
                    onEdit: () {
                      imageUploadService.pickAndUploadImage(ImageSource.gallery, 'toko').then((success) {
                        if (success && imageUploadService.image.value != null) {
                          setState(() {
                            controller.imageLink.value = imageUploadService.image.value!.url;
                            
                          });
                        } else {
                          Get.snackbar('Error', 'Gagal mengunggah gambar',
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      }).catchError((error) {
                        Get.snackbar('Error', 'Gagal mengunggah gambar: $error',
                            snackPosition: SnackPosition.BOTTOM);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 60),
                // White container for the form
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: FormEditToko(controller: controller),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
