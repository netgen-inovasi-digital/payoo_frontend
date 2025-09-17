import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/akun/controllers/akun_controller.dart';
import 'package:payoo/app/modules/auth/login/controllers/login_controller.dart';
import 'package:payoo/app/modules/akun/views/akun_detail_view.dart';
import 'package:payoo/app/modules/dashboarduser/controllers/dashboard_user_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/config/theme/light_theme.dart';
import 'package:payoo/config/utils/storage_manager.dart';

class CustomDrawerMenu extends StatelessWidget {
  CustomDrawerMenu({super.key});
  final AkunController userController = Get.put(AkunController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(() {
        if (userController.status.value == ApiCallStatus.error) {
          return Center(child: Text("Error loading user data"));
        }

        if (userController.status.value == ApiCallStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        return _succes_drawer();
      }),
    );
  }

  Column _succes_drawer() {
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: DrawerHeader(
            decoration: const BoxDecoration(
              color: LightThemeColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
              children: [
                Row(
                  children: [
                    // Foto Profil
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                LightThemeColors.primaryColor,
                                LightThemeColors.accentColor
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipOval(
                              child: Container(
                                width: 84,
                                height: 84,
                                color: Colors.white,
                                child: userController.user.value?.photo ==
                                            null ||
                                        userController.user.value?.photo == ""
                                    ? const Icon(Icons.person,
                                        size: 40, color: Colors.grey)
                                    : Image.network(
                                        userController.user.value!.photo!,
                                        width: 84,
                                        height: 84,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                              strokeWidth: 2,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                          Color>(
                                                      LightThemeColors
                                                          .primaryColor),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.person,
                                                    size: 40,
                                                    color: Colors.grey),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Jarak antara gambar dan teks
                GestureDetector(
                  onTap: () => Get.to(() => AkunDetailView()),
                  child: Row(
                    children: [
                      Text(
                        userController.user.value?.name ?? "Nama profil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "(Pemilik)",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      userController.user.value?.email ?? "Email",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      userController.user.value?.phone ?? "08115100900",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // Menu Items
        ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.database,
            color: LightThemeColors.primaryColor,
            size: 25,
          ),
          title: const Text(
            "Produk",
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          onTap: () {
            // Aksi saat produk dipilih
            Get.toNamed(Routes.PRODUK);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart,
              color: LightThemeColors.primaryColor, size: 25),
          title: const Text("Transaksi Penjualan",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          onTap: () {
            // Aksi saat transaksi dipilih
            Get.toNamed(Routes.TRANSAKSI);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: const Icon(
            Icons.receipt_long,
            color: LightThemeColors.primaryColor,
            size: 25,
          ),
          title: const Text("Laporan",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          onTap: () {
            // Aksi saat laporan dipilih
            Get.toNamed(Routes.LAPORAN, arguments: userController.user.value?.shopId);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 20),
          leading: const FaIcon(
            FontAwesomeIcons.user,
            color: LightThemeColors.primaryColor,
            size: 20,
          ),
          title: const Text("Edit Akun",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          onTap: () {
            // Aksi saat edit akun dipilih
            Get.to(() => AkunDetailView());
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: const Icon(
            Icons.info,
            color: LightThemeColors.primaryColor,
            size: 25,
          ),
          title: const Text("Tentang Payoo",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          onTap: () {
            // Aksi saat tentang dipilih
            Get.toNamed(Routes.TENTANG_PAYOO);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: LightThemeColors.primaryColor,
            size: 25,
          ),
          title: const Text("Logout",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          onTap: () {
            // Aksi saat logout: gunakan method logout pada controller agar tidak gunakan controller yang sudah disposed
            final controller = Get.find<LoginController>();
            controller.logout();
            Get.offAllNamed(Routes.LOGIN);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.user,
            color: LightThemeColors.primaryColor,
            size: 20,
          ),
          title: const Text("Dashboard User",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          onTap: () {
            // Aksi saat logout
            Get.toNamed(Routes.DASHBOARD_USER);
          },
        ),
      ],
    );
  }
}
