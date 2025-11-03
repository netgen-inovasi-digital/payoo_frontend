import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:payoo/app/components/custom_drawer_menu.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/auth/login/controllers/login_controller.dart';
import 'package:payoo/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/custom_card.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/custom_card_premium.dart';
import 'package:payoo/app/modules/dashboard/views/widgets/profile_header.dart';
import 'package:payoo/app/services/api_call_status.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    if (!_hasLoadedData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dashboardController.refreshData();
      });
      _hasLoadedData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Obx(() {
        if (dashboardController.status.value == ApiCallStatus.loading) {
          return const Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final userPhoto = dashboardController.userController.user.value?.photo;
        final userName = dashboardController.userController.user.value?.name ??
            'Nama Pemilik';
        final userEmail =
            dashboardController.userController.user.value?.email ?? 'Email';
        final userPhone =
            dashboardController.userController.user.value?.phone ??
                '08115100900';
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
          // Loading state
          if (dashboardController.status.value == ApiCallStatus.loading ||
              dashboardController.statusDashboardData ==
                  ApiCallStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (dashboardController.status.value == ApiCallStatus.error ||
              dashboardController.statusDashboardData == ApiCallStatus.error) {
            // Check if it's a 401 error (token expired)
            final isTokenExpired =
                dashboardController.errorStatusCode.value == 401;

            if (isTokenExpired) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_clock,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Sesi Anda Telah Berakhir",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Silakan login kembali untuk melanjutkan",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        final LoginController loginController =
                            Get.put<LoginController>(LoginController());
                        loginController.logout();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("KELUAR"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Handle other errors
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Terjadi Kesalahan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Gagal memuat data. Silakan coba lagi.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      dashboardController.refreshData();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("COBA LAGI"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF36A86F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Success state
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
                          photo: dashboardController
                                  .tokoController.toko.value?.photo ??
                              '',
                          businessName: dashboardController
                                  .tokoController.toko.value?.name ??
                              'Nama Toko',
                          address: dashboardController
                                  .tokoController.toko.value?.address ??
                              'Alamat Toko',
                          ownerName: dashboardController
                                  .userController.user.value?.name ??
                              'Nama Pemilik',
                          phoneNumber: dashboardController
                                  .tokoController.toko.value?.phone ??
                              'Nomor Telepon',
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
                          value: dashboardController
                                  .dashboardData.value?.productQuantity
                                  .toString() ??
                              '0'),
                      CustomCard(
                          title: 'Kategori Produk',
                          label: 'Total',
                          value: dashboardController
                                  .dashboardData.value?.categoryQuantity
                                  .toString() ??
                              '0'),
                      CustomCard(
                          title: 'Jumlah Transaksi',
                          label:
                              dashboardController.dashboardData.value?.date ??
                                  '0',
                          value: dashboardController
                                  .dashboardData.value?.transactionCount
                                  .toString() ??
                              '0'),
                      CustomCard(
                          title: 'Pendapatan',
                          label:
                              dashboardController.dashboardData.value?.date ??
                                  '0',
                          value: dashboardController
                                  .dashboardData.value?.revenue
                                  .toString() ??
                              '0'),
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
