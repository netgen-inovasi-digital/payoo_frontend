import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_editable_image.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/akun/views/widgets/akun_form.dart';
import 'package:payoo/app/modules/dashboarduser/controllers/dashboard_user_controller.dart';
import 'package:payoo/app/services/image_upload_service.dart';
import 'package:payoo/config/theme/light_theme.dart';

class AkunEditView extends StatefulWidget {
  const AkunEditView({super.key});

  @override
  State<AkunEditView> createState() => _AkunEditViewState();
}

class _AkunEditViewState extends State<AkunEditView> {
  final AkunController userController = AkunController();

    _loadAkun() async {
    await userController.fetchUser();
    userController.fillProfile();
  } 

  ImageUploadService imageUploadService = ImageUploadService();

  @override
  void initState() {
    super.initState();
    // Load categories when widget initializes
    _loadAkun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Edit Akun',
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
                      userController.user.value?.photo != null && userController.user.value!.photo.isNotEmpty ? userController.user.value!.photo : 'http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcR0NrOJEpfjkM0zxD-aO9b-bWqW3mhY57jPMg3aSbxTYO__R4jOvx8T2Oa7Fm9yxXOGg4B_ns3SZaZGCiBOPQw',
                    onEdit: () {
                      imageUploadService.pickAndUploadImage(ImageSource.gallery, 'akun').then((success) {

                        if (success && imageUploadService.image.value != null) {
                        
                          setState(() {
                            userController.imageLink.value = imageUploadService.image.value!.url;
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
                  child: AkunForm(isEditing: true, userController: userController),
                )
              ],
            ),
          ),
        ],
      ),
    ); 
    
  }
}