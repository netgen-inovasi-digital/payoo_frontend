import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_editable_image.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/akun/views/widgets/akun_form.dart';
import 'package:payoo/app/modules/dashboarduser/controllers/dashboard_user_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/theme/light_theme.dart';

class AkunDetailView extends StatefulWidget {
  const AkunDetailView({super.key});

  @override
  State<AkunDetailView> createState() => _AkunDetailViewState();
}

class _AkunDetailViewState extends State<AkunDetailView> {
  final AkunController userController = AkunController(); 

  _loadAkun() async {
    await userController.fetchUser();
    userController.fillProfile();
  }

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
        title: 'Detail Akun',
      ),
      body: Stack(
        children: [
          // Top background
          Container(
            height: 500,
            color: LightThemeColors.primaryColor,
          ),
          // Main content
          Obx( () {

            if (userController.status.value == ApiCallStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (userController.status.value == ApiCallStatus.error) {
              return Center(child: Text('Error: ${userController.error.value}'));
            }
            return SingleChildScrollView(
              child: Column(    
                children: [
                  const SizedBox(height: 60),
                  // Editable image
                  EditableImage(
                    isEditable: false,
                    photo: userController.user.value?.photo ?? 'http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcR0NrOJEpfjkM0zxD-aO9b-bWqW3mhY57jPMg3aSbxTYO__R4jOvx8T2Oa7Fm9yxXOGg4B_ns3SZaZGCiBOPQw',
                    onEdit: () {
                    },
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
                    child: AkunForm(isEditing: false, userController: userController),
                  )
                ],
              ),
            );}
          ),
        ],
      ),
    ); 
    
  }
}