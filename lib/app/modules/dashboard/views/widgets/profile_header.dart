import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/edit_toko/views/edit_toko_view.dart';
import 'package:payoo/app/modules/toko/controllers/toko_controller.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class ProfileHeader extends StatelessWidget {
  final String photo;
  final String businessName;
  final String address;
  final String ownerName;
  final String phoneNumber;
  final VoidCallback onEditProfile;
  final VoidCallback onAccountUpgrade;

  const ProfileHeader({
    super.key,
    required this.businessName,
    required this.address,
    required this.ownerName,
    required this.phoneNumber,
    required this.onEditProfile,
    required this.onAccountUpgrade, required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Nama bisnis
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 200,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0), // Geser ikon ke kiri
                      // Tombol menu (ikon tiga garis)
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.bars,
                          size: 25,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    businessName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Lingkaran gambar dengan tombol edit
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 95,
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
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Container(
                            width: 84,
                            height: 84,
                            color: Colors.white,
                            child: photo.isEmpty
                                ? const Icon(Icons.person,
                                    size: 40, color: Colors.grey)
                                : Image.network(
                                    photo,
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
                                                size: 40, color: Colors.grey),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Alamat
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: const Icon(Icons.location_on,
                      color: Colors.white, size: 20)),
              const SizedBox(width: 8.0),
              SizedBox(
                width: 182,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    address,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.penToSquare,
                        color: Colors.white, size: 11),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        Get.to(EditTokoView());
                      },
                      child: const Text('Ubah Profil',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Nama pemilik
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white, size: 20),
              const SizedBox(width: 8.0),
              Text(
                ownerName,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Nomor telepon
          Row(
            children: [
              const Icon(FontAwesomeIcons.whatsapp,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8.0),
              Text(
                phoneNumber,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 100,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: onAccountUpgrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Akun Gratis',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Tombol Akun Gratis
        ],
      ),
    );
  }
}
