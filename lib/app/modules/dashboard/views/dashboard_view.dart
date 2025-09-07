import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:payoo/app/components/custom_drawer_menu.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/custom_card.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/custom_card_premium.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/profile_header.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardController dashboardController =
      Get.put<DashboardController>(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawerMenu(),
      body: Obx(
        () {
          if (dashboardController.status.value == LoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (dashboardController.status.value == LoadingStatus.error) {
            return Center(
              child: Text(
                'Error: ${dashboardController.errorMessage.value}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return Column(
            children: [
              CustomHeaderClipPath(
                mainAxisAlignment: MainAxisAlignment.start,
                height: 340,
                strokeWidth: 20,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Builder(
                      builder: (context) {
                        // Gunakan Builder untuk mendapatkan konteks yang benar
                        return ProfileHeader(
                          businessName: dashboardController
                                  .tokoController.toko.value?.name ??
                              'Nama Toko',
                          address:
                              dashboardController.tokoController.toko.value
                                      ?.address ??
                                  'Alamat Toko',
                          ownerName: dashboardController.userController.user.value?.name ?? 'Nama Pemilik',
                          phoneNumber: dashboardController.userController.user.value?.phone ?? 'Nomor Telepon',
                          onEditProfile: () {},
                          onAccountUpgrade: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 3 / 2,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    children: const [
                      CustomCard(
                          title: 'Jumlah Produk', label: 'Total', value: '178'),
                      CustomCard(
                          title: 'Kategori Produk',
                          label: 'Total',
                          value: '20'),
                      CustomCard(
                          title: 'Akun Karyawan', label: 'Total', value: '2'),
                      CustomCard(
                          title: 'Jumlah Transaksi',
                          label: '25-10-2022',
                          value: '89'),
                      CustomCard(
                          title: 'Pendapatan',
                          label: '25-10-2022',
                          value: '10.000.000'),
                      CustomCardPremium(
                          title: 'Keuntungan', description: 'Payoo Premium'),
                      CustomCardPremium(
                          title: 'Pelanggan', description: 'Payoo Premium'),
                      CustomCardPremium(
                          title: 'Bahan Baku Habis',
                          description: 'Payoo Premium'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
