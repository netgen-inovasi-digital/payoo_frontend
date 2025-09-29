import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/modules/auth/daftar/controllers/daftar_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/routes/app_pages.dart';

class FormDaftar extends StatelessWidget {
  final VoidCallback onDaftarSuccess;

  const FormDaftar({super.key, required this.onDaftarSuccess});

  @override
  Widget build(BuildContext context) {
  final DaftarController daftarController = Get.find<DaftarController>();

  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // TextField nama pemilik
        Obx(() => CustomTextField(
          hintText: 'Nama pemilik*', 
          controller: daftarController.name,
          hasError: daftarController.hasAttemptedSubmit.value && 
                   daftarController.nameError.value.isNotEmpty,
          errorText: daftarController.nameError.value,
        )),
        const SizedBox(height: 20),
        // TextField email
        Obx(() => CustomTextField(
          hintText: 'Email*', 
          controller: daftarController.email,
          keyboardType: TextInputType.emailAddress,
          hasError: daftarController.hasAttemptedSubmit.value && 
                   daftarController.emailError.value.isNotEmpty,
          errorText: daftarController.emailError.value,
        )),
        const SizedBox(height: 20),
        // TextField nomor ponsel
        Obx(() => CustomTextField(
          hintText: 'Nomor ponsel pemilik*', 
          controller: daftarController.phone,
          keyboardType: TextInputType.phone,
          hasError: daftarController.hasAttemptedSubmit.value && 
                   daftarController.phoneError.value.isNotEmpty,
          errorText: daftarController.phoneError.value,
        )),
        const SizedBox(height: 20),
        // TextField kata sandi
        Obx(() => CustomTextField(
          hintText: 'Kata sandi*', 
          controller: daftarController.password, 
          obscureText: true,
          hasError: daftarController.hasAttemptedSubmit.value && 
                   daftarController.passwordError.value.isNotEmpty,
          errorText: daftarController.passwordError.value,
        )),
        const SizedBox(height: 20),
        // TextField ulang kata sandi
        Obx(() => CustomTextField(
          hintText: 'Ulang kata sandi*', 
          controller: daftarController.passwordConfirm, 
          obscureText: true,
          hasError: daftarController.hasAttemptedSubmit.value && 
                   daftarController.passwordConfirmError.value.isNotEmpty,
          errorText: daftarController.passwordConfirmError.value,
        )),
        const SizedBox(height: 20),

        // Tombol Masuk
        Obx(() {
          if (daftarController.status.value == ApiCallStatus.loading) {
            return const CircularProgressIndicator();
          }
          final success = daftarController.status.value == ApiCallStatus.success &&
              (daftarController.apiResponse.value?.isSuccess ?? false);
          return CustomButton(
            label: success ? 'Berhasil' : 'DAFTAR',
            onPressed: () async {
              await daftarController.register();
              if (daftarController.status.value == ApiCallStatus.success &&
                  (daftarController.apiResponse.value?.isSuccess ?? false)) {
                onDaftarSuccess();
              } else if (daftarController.errorMessage.isNotEmpty) {
                Get.snackbar('Register Gagal', daftarController.errorMessage.value,
                    backgroundColor: Colors.redAccent, colorText: Colors.white);
              }
            },
            height: 50,
            width: 280,
          );
        }),
        const SizedBox(height: 20),
        // Teks Daftar dan Lupa Kata Sandi
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sudah Punya Akun? Masuk ',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.LOGIN);
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
      ],
    );
  }
}
