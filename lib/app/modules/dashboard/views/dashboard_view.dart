import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_drawer_menu.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/custom_card.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/custom_card_premium.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/profile_header.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Move this inside a callback to avoid build-time updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Make sure controller exists and the page is fully visible
      controller.refreshData();
    });
    
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawerMenu(),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: Obx(
          () {
            // Store values locally to prevent changes during build
            final status = controller.status.value;
            final errorMessage = controller.errorMessage.value;
            
            if (status == LoadingStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (status == LoadingStatus.error) {
              return Center(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            // Store these values before building to avoid reactive updates
            final photo = controller.tokoController.toko.value?.photo ?? '';
            final businessName = controller.tokoController.toko.value?.name ?? 'Nama Toko';
            final address = controller.tokoController.toko.value?.address ?? 'Alamat Toko';
            final ownerName = controller.userController.user.value?.name ?? 'Nama Pemilik';
            final phoneNumber = controller.userController.user.value?.phone ?? 'Nomor Telepon';

            return Column(
              children: [
                CustomHeaderClipPath(
                  mainAxisAlignment: MainAxisAlignment.start,
                  height: 340,
                  strokeWidth: 20,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: ProfileHeader(
                        photo: photo,
                        businessName: businessName,
                        address: address,
                        ownerName: ownerName,
                        phoneNumber: phoneNumber,
                        onEditProfile: () {},
                        onAccountUpgrade: () {},
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
      ),
    );
  }
}
