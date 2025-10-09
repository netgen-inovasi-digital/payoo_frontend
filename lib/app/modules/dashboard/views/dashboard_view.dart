import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:payoo/app/components/custom_drawer_menu.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/custom_card.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/custom_card_premium.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/profile_header.dart';
import 'package:payoo/app/services/api_call_status.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});
  final DashboardController dashboardController = Get.put<DashboardController>(DashboardController());

  void refreshData() {
    dashboardController.loadData();    
  }

  @override
  Widget build(BuildContext context) {
    // Refresh data every time this page is built/navigated to
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.refreshData();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Obx(() {
        // Pass static data from dashboard controller to drawer
        if (dashboardController.status.value == ApiCallStatus.loading) {
          return const Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final userPhoto = dashboardController.userController.user.value?.photo;
        final userName = dashboardController.userController.user.value?.name ?? 'Nama Pemilik';
        final userEmail = dashboardController.userController.user.value?.email ?? 'Email';
        final userPhone = dashboardController.userController.user.value?.phone ?? '08115100900';
        final shopId = dashboardController.userController.user.value?.shopId;

        return CustomDrawerMenu(
          photo: userPhoto,
          name: userName,
          email: userEmail,
          phone: userPhone,
          shopId: shopId,
        );
      }),
      body: Obx(
        () {
          if (dashboardController.status.value == ApiCallStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (dashboardController.status.value == ApiCallStatus.error) {
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
                        return ProfileHeader(
                          photo: dashboardController.tokoController.toko.value?.photo ?? '',
                          businessName: dashboardController
                                  .tokoController.toko.value?.name ??
                              'Nama Toko',
                          address:
                              dashboardController.tokoController.toko.value
                                      ?.address ??
                                  'Alamat Toko',
                          ownerName: dashboardController.userController.user.value?.name ?? 'Nama Pemilik',
                          phoneNumber: dashboardController.tokoController.toko.value?.phone ?? 'Nomor Telepon',
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
                    children: [
                      CustomCard(
                          title: 'Jumlah Produk', 
                          label: 'Total', 
                          value: dashboardController.dashboardData.value?.productQuantity.toString() ?? '0'),
                      CustomCard(
                          title: 'Kategori Produk',
                          label: 'Total',
                          value: dashboardController.dashboardData.value?.categoryQuantity.toString() ?? '0'),
                      CustomCard(
                          title: 'Komposisi Produk', 
                          label: 'Total', 
                          value: dashboardController.dashboardData.value?.compositionQuantity.toString() ?? '0'),
                      CustomCard(
                          title: 'Jumlah Transaksi',
                          label: dashboardController.dashboardData.value?.date ?? '0',
                          value: dashboardController.dashboardData.value?.transactionCount.toString() ?? '0'),
                      CustomCard(
                          title: 'Pendapatan',
                          label: dashboardController.dashboardData.value?.date ?? '0',
                          value: dashboardController.dashboardData.value?.revenue.toString() ?? '0'),
                      const CustomCardPremium(
                          title: 'Keuntungan', description: 'Payoo Premium'),
                      const CustomCardPremium(
                          title: 'Pelanggan', description: 'Payoo Premium'),
                      const CustomCardPremium(
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