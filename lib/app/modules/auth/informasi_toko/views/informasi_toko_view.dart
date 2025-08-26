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
                            CustomTextField(
                              hintText: 'nama toko*',
                              controller: controller.name,
                            ),
                            const SizedBox(height: 20),
                            // TextField jenis usaha
                            Obx(() => CustomDropdown<String>(
                                  hintText: controller.selectedType.value.isEmpty
                                      ? 'jenis toko*'
                                      : controller.selectedType.value,
                                  itemsStatic: const ['mandiri', 'perusahaan'],
                                  onChanged: (val) {
                                    controller.setType(val);
                                  },
                                )),
                            const SizedBox(height: 20),
                            // TextField nomor ponsel
                            CustomTextField(
                              hintText: 'nomor ponsel*',
                              controller: controller.phone,
                            ),
                            const SizedBox(height: 20),
                            // TextField email
                            CustomTextField(
                              hintText: 'email*',
                              controller: controller.email,
                            ),
                            const SizedBox(height: 20),
                            // TextField alamat toko
                            CustomTextField(
                              hintText: 'alamat toko*',
                              controller: controller.address,
                            ),
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
                                    Get.toNamed(Routes.DASHBOARD);
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
