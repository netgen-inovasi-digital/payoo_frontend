import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_button.dart';
import 'package:payoo/app/components/custom_dropdown.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/components/custom_text_field.dart';
import 'package:payoo/app/modules/auth/informasi_toko/controllers/informasi_toko_controller.dart';
import 'package:payoo/app/services/api_call_status.dart';
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
                            const CustomTextField(hintText: 'nama toko'),
                            const SizedBox(height: 20),
                            // TextField jenis usaha
                            const CustomDropdown(
                              hintText: 'jenis toko*',
                              itemsStatic: ['mandiri', 'perusahaan'],
                            ),
                            const SizedBox(height: 20),
                            // TextField nomor ponsel
                            const CustomTextField(hintText: 'nomor ponsel'),
                            const SizedBox(height: 20),
                            // TextField email
                            const CustomTextField(hintText: 'email'),
                            const SizedBox(height: 20),
                            // TextField alamat toko
                            const CustomTextField(hintText: 'alamat toko*'),
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
                                return CustomDropdown(
                                  hintText: 'provinsi*',
                                  items: controller.provinces,
                                  itemTextBuilder: (item) =>
                                      item.text, // Tampilkan properti `text`
                                  onChanged: (selectedProvince) {
                                    // Gunakan `id` dari model yang dipilih
                                    controller
                                        .getDataCities(selectedProvince.id);
                                  },
                                );
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
                                return CustomDropdown(
                                  hintText: 'kabupaten kota*',
                                  items: controller.cities,
                                  itemTextBuilder: (item) =>
                                      item.text, // Tampilkan properti `text`
                                );
                              } else {
                                return const CustomDropdown(
                                  hintText: 'kabupaten kota*',
                                  itemsStatic: ['kabupaten kota*'],
                                ); // Default widget jika tidak ada kondisi terpenuhi
                              }
                            }),
                            const SizedBox(height: 20),
                            // Tombol Masuk
                            CustomButton(
                              label: 'SIMPAN',
                              onPressed: () {},
                              height: 50,
                              width: 280,
                            ),
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
