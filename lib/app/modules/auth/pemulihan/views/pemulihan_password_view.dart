import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/auth/pemulihan/controllers/pemulihan_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/theme/light_theme.dart';

class PemulihanPasswordView extends StatefulWidget {
  const PemulihanPasswordView({super.key});

  @override
  State<PemulihanPasswordView> createState() => _PemulihanPasswordViewState();
}

class _PemulihanPasswordViewState extends State<PemulihanPasswordView> {
  final PemulihanController pemulihanController = Get.put<PemulihanController>(PemulihanController());
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void _onSubmitPassword() async {
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field harus diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Password tidak cocok',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password minimal 6 karakter',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Call API to reset password
    final email = pemulihanController.forgetPasswordController.text;
    final success = await pemulihanController.resetPassword(email, newPasswordController.text, confirmPasswordController.text);
    
    if (success) {
      Get.snackbar(
        'Berhasil',
        'Password berhasil diubah',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to login screen
      Get.offAllNamed('/login');
    } else {
      Get.snackbar(
        'Error',
        pemulihanController.errorReset.value.isNotEmpty 
            ? pemulihanController.errorReset.value 
            : 'Gagal mengubah password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Konten Utama
                Column(
                  children: [
                    const SizedBox(height: 150),
                    const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: LightThemeColors.displayTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Enter your new password below and check the hint while setting it.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Set New Password Field
                          const Text(
                            "Set New Password",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: LightThemeColors.displayTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: newPasswordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "*****",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: LightThemeColors.primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Confirm New Password Field
                          const Text(
                            "Confirm New Password",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: LightThemeColors.displayTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: !isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "*****",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: LightThemeColors.primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // Submit Password Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _onSubmitPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LightThemeColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Submit Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Background Lengkungan Gradasi
                const CustomHeaderClipPath(
                  height: 130,
                  strokeWidth: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}