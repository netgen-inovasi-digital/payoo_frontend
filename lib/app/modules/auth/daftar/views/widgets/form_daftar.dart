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
        CustomTextField(hintText: 'nama pemilik*', controller: daftarController.name),
        const SizedBox(height: 20),
        // TextField email
        CustomTextField(hintText: 'email*', controller: daftarController.email),
        const SizedBox(height: 20),
        // TextField nomor ponsel
        CustomTextField(hintText: 'nomor ponsel pemilik*', controller: daftarController.phone),
        const SizedBox(height: 20),
        // TextField kata sandi
        CustomTextField(hintText: 'kata sandi*', controller: daftarController.password, obscureText: true),
        const SizedBox(height: 20),
        // TextField ulang kata sandi
        CustomTextField(hintText: 'ulang kata sandi*', controller: daftarController.passwordConfirm, obscureText: true),
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
