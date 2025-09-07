import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_editable_image.dart';
import 'package:payoo/app/modules/akun/views/widgets/akun_form.dart';
import 'package:payoo/app/modules/dashboarduser/controllers/dashboard_user_controller.dart';
import 'package:payoo/config/theme/light_theme.dart';

class AkunEditView extends StatelessWidget {
   AkunEditView({super.key});
  final DashboardUserController userController = DashboardUserController();
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
                EditableImage(
                  photo:
                      'http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcR0NrOJEpfjkM0zxD-aO9b-bWqW3mhY57jPMg3aSbxTYO__R4jOvx8T2Oa7Fm9yxXOGg4B_ns3SZaZGCiBOPQw',
                  onEdit: () {
                    print("Edit button tapped");
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