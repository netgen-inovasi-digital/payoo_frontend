import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/modules/auth/login/controllers/login_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool passwordSee = true;
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 250),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 120),
                          // TextField Email
                          CustomTextField(
                            hintText: 'email/nomor ponsel',
                            controller: loginController.email,
                          ),
                          const SizedBox(height: 20),
                          // TextField Password
                          CustomTextField(
                            hintText: 'kata sandi',
                            controller: loginController.password,
                            obscureText: passwordSee,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  passwordSee = !passwordSee;
                                  setState(() {});
                                },
                                child: Icon(
                                  passwordSee
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: passwordSee
                                      ? LightThemeColors.textHintColor
                                      : LightThemeColors.bodyTextColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(() {
                            if (loginController.status.value == ApiCallStatus.loading) {
                              return const CircularProgressIndicator();
                            }
                            final success = loginController.status.value == ApiCallStatus.success &&
                                (loginController.apiResponse.value?.isSuccess ?? false);
                            return CustomButton(
                              height: 50,
                              width: 280,
                              label: success ? 'Berhasil' : 'Masuk',
                              onPressed: () async {
                                await loginController.login();
                                final resp = loginController.apiResponse.value;
                                if (loginController.status.value == ApiCallStatus.success &&
                                    (resp?.isSuccess ?? false)) {
                                  Get.toNamed(Routes.DASHBOARD);
                                } else if (loginController.errorMessage.isNotEmpty) {
                                  Get.snackbar('Login Gagal', loginController.errorMessage.value,
                                      backgroundColor: Colors.redAccent, colorText: Colors.white);
                                }
                              },
                            );
                          }),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Belum Punya Akun? Daftar ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.DAFTAR);
                                },
                                child: const Text(
                                  'Disini.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.PEMULIHAN);
                            },
                            child: const Text(
                              'Lupa Kata Sandi?',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const CustomHeaderClipPath(
                  height: 350,
                  strokeWidth: 20,
                  children: [
                    Text(
                      "PAYOO",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text("Point of Sales",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
