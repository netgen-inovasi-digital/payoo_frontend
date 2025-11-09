import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_dropdown.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/modules/auth/informasi_toko/controllers/informasi_toko_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/routes/app_pages.dart';
import '../../../../../config/theme/light_theme.dart';

class InformasiTokoView extends StatelessWidget {
  const InformasiTokoView({super.key});

  @override
  Widget build(BuildContext context) {
    final InformasiTokoController controller =
        Get.find<InformasiTokoController>();

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
                    const SizedBox(
                        height: 150), // Spasi untuk menyesuaikan posisi
                    const Text(
                      "INFORMASI TOKO",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: LightThemeColors.displayTextColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            // TextField nama toko
                            Obx(() => CustomTextField(
                              hintText: 'nama toko*',
                              controller: controller.name,
                              hasError: controller.hasAttemptedSubmit.value && 
                                       controller.nameError.value.isNotEmpty,
                              errorText: controller.nameError.value,
                            )),
                            const SizedBox(height: 20),
                            // TextField jenis usaha
                            Obx(() => CustomDropdown<String>(
                              hintText: controller.selectedType.value.isEmpty
                                  ? 'jenis toko*'
                                  : controller.selectedType.value,
                              itemsStatic: const ['mandiri', 'perusahaan'],
                              hasError: controller.hasAttemptedSubmit.value && 
                                       controller.typeError.value.isNotEmpty,
                              errorText: controller.typeError.value,
                              onChanged: (val) {
                                controller.setType(val);
                              },
                            )),
                            const SizedBox(height: 20),
                            // TextField nomor ponsel
                            Obx(() => CustomTextField(
                              hintText: 'nomor ponsel*',
                              controller: controller.phone,
                              keyboardType: TextInputType.phone,
                              hasError: controller.hasAttemptedSubmit.value && 
                                       controller.phoneError.value.isNotEmpty,
                              errorText: controller.phoneError.value,
                            )),
                            const SizedBox(height: 20),
                            // TextField email
                            Obx(() => CustomTextField(
                              hintText: 'email*',
                              controller: controller.email,
                              keyboardType: TextInputType.emailAddress,
                              hasError: controller.hasAttemptedSubmit.value && 
                                       controller.emailError.value.isNotEmpty,
                              errorText: controller.emailError.value,
                            )),
                            const SizedBox(height: 20),
                            // TextField alamat toko
                            Obx(() => CustomTextField(
                              hintText: 'alamat toko*',
                              controller: controller.address,
                              hasError: controller.hasAttemptedSubmit.value && 
                                       controller.addressError.value.isNotEmpty,
                              errorText: controller.addressError.value,
                            )),
                            const SizedBox(height: 20),
                            // TextField provinsi
                            Obx(() {
                              if (controller.provinceStatus.value ==
                                  ApiCallStatus.loading) {
                                return const CustomDropdown(
                                  hintText: 'provinsi*',
                                  itemsStatic: [''],
                                );
                              } else if (controller.provinceStatus.value ==
                                  ApiCallStatus.error) {
                                return TextButton(
                                  onPressed: controller.getDataProvinces,
                                  child: const Text(
                                    "Gagal memuat data provinsi, coba lagi",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: LightThemeColors.hintTextColor),
                                  ),
                                );
                              } else if (controller.provinceStatus.value ==
                                  ApiCallStatus.success) {
                                return Obx(() => CustomDropdown(
                                      hintText: controller.selectedProvince.value.isEmpty
                                          ? 'provinsi*'
                                          : controller.selectedProvince.value,
                                      items: controller.provinces,
                                      itemTextBuilder: (item) => item.text,
                                      hasError: controller.hasAttemptedSubmit.value && 
                                               controller.provinceError.value.isNotEmpty,
                                      errorText: controller.provinceError.value,
                                      onChanged: (selectedProvince) {
                                        controller.setProvince(selectedProvince.text);
                                        controller.getDataCities(selectedProvince.id);
                                      },
                                    ));
                              } else {
                                return const CustomDropdown(
                                  hintText: 'provinsi*',
                                  itemsStatic: [],
                                ); // Default widget jika tidak ada kondisi terpenuhi
                              }
                            }),
                            // Province error message
                            const SizedBox(height: 20),
                            // TextField kabupaten kota
                            Obx(() {
                              if (controller.cityStatus.value ==
                                  ApiCallStatus.loading) {
                                return const CustomDropdown(
                                  hintText: 'kabupaten kota*',
                                  itemsStatic: ['kabupaten kota*'],
                                );
                              } else if (controller.cityStatus.value ==
                                  ApiCallStatus.error) {
                                return TextButton(
                                  onPressed: controller.getDataProvinces,
                                  child: const Text(
                                    "Gagal memuat data kabupaten kota, coba lagi",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: LightThemeColors.hintTextColor),
                                  ),
                                );
                              } else if (controller.cityStatus.value ==
                                  ApiCallStatus.success) {
                                return Obx(() => CustomDropdown(
                                      hintText: controller.selectedCity.value.isEmpty
                                          ? 'kabupaten kota*'
                                          : controller.selectedCity.value,
                                      items: controller.cities,
                                      itemTextBuilder: (item) => item.text,
                                      hasError: controller.hasAttemptedSubmit.value && 
                                               controller.cityError.value.isNotEmpty,
                                      errorText: controller.cityError.value,
                                      onChanged: (selectedCity) {
                                        controller.setCity(selectedCity.text);
                                      },
                                    ));
                              } else {
                                return const CustomDropdown(
                                  hintText: 'kabupaten kota*',
                                  itemsStatic: ['kabupaten kota*'],
                                ); // Default widget jika tidak ada kondisi terpenuhi
                              }
                            }),
                            // City error message
                            const SizedBox(height: 20),
                            // Error message
                            Obx(() => controller.saveError.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      controller.saveError.value,
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : const SizedBox.shrink()),
                            Obx(() {
                              if (controller.isSaving.value) {
                                return const CircularProgressIndicator();
                              }
                              return CustomButton(
                                label: controller.saveSuccess.value
                                    ? 'TERSIMPAN'
                                    : 'SIMPAN',
                                onPressed: () async {
                                  await controller.saveShop();
                                  if (controller.saveSuccess.value) {
                                    Get.snackbar('Berhasil', 'Informasi toko tersimpan',
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white);
                                    // arahkan ke halaman dashboard
                                    Get.offAllNamed(Routes.LOGIN);
                                  }
                                },
                                height: 50,
                                width: 280,
                              );
                            }),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Background Lengkungan Gradasi
                const CustomHeaderClipPath(
                  height: 130,
                  strokeWidth: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
