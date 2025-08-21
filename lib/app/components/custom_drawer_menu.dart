import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class CustomDrawerMenu extends StatelessWidget {
  const CustomDrawerMenu({super.key});

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
                            child: const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person,
                                    size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Jarak antara gambar dan teks
                  const Row(
                    children: [
                      Text(
                        "Setyo WS",
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
                  const SizedBox(height: 8),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.envelope,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "setyo@gmail.com",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "0819-9656-9998",
                        style: TextStyle(
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
              Get.toNamed(Routes.LAPORAN);
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
              Get.toNamed(Routes.AKUN);
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
              // Aksi saat logout
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
      ),
    );
  }
}
