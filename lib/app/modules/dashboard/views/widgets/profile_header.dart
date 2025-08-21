import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/edit_toko/views/edit_toko_view.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class ProfileHeader extends StatelessWidget {
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
    required this.onAccountUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            // Nama bisnis
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: 200,
                  height: 50,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 0.0), // Geser ikon ke kiri
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
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
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
              child: Text(
                address,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.penToSquare,
                    color: Colors.white, size: 11),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () { Get.to(EditTokoView()); },
                  child: const Text('Ubah Profil',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
                )
              ],
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
    );
  }
}
