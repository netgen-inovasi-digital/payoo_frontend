import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/akun/views/ganti_password_view.dart';
import 'package:payoo/app/modules/auth/pemulihan/controllers/pemulihan_controller.dart';
import 'package:payoo/app/modules/auth/pemulihan/views/pemulihan_password_view.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/theme/light_theme.dart';

class PemulihanOtpView extends StatefulWidget {
  const PemulihanOtpView({super.key});

  @override
  State<PemulihanOtpView> createState() => _PemulihanOtpViewState();
}

class _PemulihanOtpViewState extends State<PemulihanOtpView> {
  final PemulihanController pemulihanController = Get.find<PemulihanController>();
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  
  int remainingSeconds = 60;
  bool canResend = false;
  
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  
  void startTimer() {
    setState(() {
      remainingSeconds = 60;
      canResend = false;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
        if (remainingSeconds > 0) {
          startTimer();
        } else {
          setState(() {
            canResend = true;
          });
        }
      }
    });
  }

  void _onVerifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      Get.snackbar(
        'Error',
        'Kode OTP harus 6 digit',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final email = pemulihanController.forgetPasswordController.text;
    final success = await pemulihanController.verifyForgotPassword(email, otp);

    if (success) {
      Get.snackbar(
        'Berhasil',
        'Verifikasi OTP berhasil',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Navigate to reset password screen
       Get.off(const PemulihanPasswordView());
    } else {
      Get.snackbar(
        'Error',
        pemulihanController.errorVerify.value.isNotEmpty 
            ? pemulihanController.errorVerify.value 
            : 'Verifikasi OTP gagal',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _onResendOtp() async {
    final success = await pemulihanController.forgotPassword();
    
    if (success) {
      Get.snackbar(
        'Berhasil',
        'Kode OTP telah dikirim ulang',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Clear all OTP fields
      for (var controller in otpControllers) {
        controller.clear();
      }
      focusNodes[0].requestFocus();
    } else {
      Get.snackbar(
        'Error',
        'Gagal mengirim ulang kode OTP',
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
                      "VERIFIKASI OTP",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: LightThemeColors.displayTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            "Masukkan kode OTP yang telah dikirim ke email Anda",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            pemulihanController.forgetPasswordController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: LightThemeColors.displayTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          
                          // OTP Input Fields (6 boxes, 1 digit each)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return Container(
                                decoration: BoxDecoration(
                                
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                                width: 50,
                                height: 60,
                                child: TextField(
                                  controller: otpControllers[index],
                                  focusNode: focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: LightThemeColors.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 5) {
                                      // Move to next field
                                      focusNodes[index + 1].requestFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      // Move to previous field on backspace
                                      focusNodes[index - 1].requestFocus();
                                    }
                                    
                                    // Auto verify when all fields are filled
                                    if (index == 5 && value.isNotEmpty) {
                                      final allFilled = otpControllers.every((c) => c.text.isNotEmpty);
                                      if (allFilled) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Verify Button
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: pemulihanController.statusVerify.value == ApiCallStatus.loading
                                  ? null
                                  : _onVerifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LightThemeColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: pemulihanController.statusVerify.value == ApiCallStatus.loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Verifikasi",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          )),
                          
                          const SizedBox(height: 20),
                          
                          // Resend OTP Button
                          Center(
                            child: TextButton(
                              onPressed: _onResendOtp,
                              child: const Text(
                                "Kirim Ulang Kode OTP",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: LightThemeColors.primaryColor,
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
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}