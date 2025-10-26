import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/auth/login/controllers/login_controller.dart';
import 'package:payoo/app/modules/akun/views/akun_detail_view.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class CustomDrawerMenu extends StatelessWidget {
  final String? photo;
  final String name;
  final String email;
  final String phone;
  final int? shopId;

  const CustomDrawerMenu({
    super.key,
    this.photo,
    required this.name,
    required this.email,
    required this.phone,
    this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 260,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: LightThemeColors.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Profile Photo
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
                                  child: photo == null || photo == ""
                                      ? const Icon(Icons.person,
                                          size: 40, color: Colors.grey)
                                      : Image.network(
                                          photo!,
                                          width: 84,
                                          height: 84,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Get.to(() => AkunDetailView()),
                    child: Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
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
                      const SizedBox(width: 5),
                      Text(
                        email,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        phone,
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
          const SizedBox(height: 10),
          // Menu Items
          ListTile(
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 19),
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
              Get.toNamed(Routes.PRODUK);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 19),
            leading: const Icon(Icons.shopping_cart,
                color: LightThemeColors.primaryColor, size: 25),
            title: const Text("Transaksi Penjualan",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            onTap: () {
              Get.toNamed(Routes.TRANSAKSI);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 19),
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
              Get.toNamed(Routes.LAPORAN, arguments: shopId);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 19),
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
              Get.to(() => AkunDetailView());
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 19),
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
              Get.toNamed(Routes.TENTANG_PAYOO);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 19),
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
              final controller = Get.put<LoginController>(LoginController());
              controller.logout();
              Get.offAllNamed(Routes.LOGIN);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}