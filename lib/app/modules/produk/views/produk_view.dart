import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payoo/app/components/custom_app_bar_clip_path.dart';
import 'package:payoo/app/components/custom_header_clip_path.dart';
import 'package:payoo/app/modules/produk/views/widgets/custom_button_outline.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';
import 'package:get/get.dart';

class ProdukView extends StatefulWidget {
  const ProdukView({super.key});

  @override
  State<ProdukView> createState() => _ProdukViewState();
}

class _ProdukViewState extends State<ProdukView> {
  bool belumDaftar = true;

  // mengubah state daftar
  void _toggleWidget() {
    setState(() {
      belumDaftar = !belumDaftar; //ubah state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarClipPath(
        title: 'Produk',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const CustomHeaderClipPath(
                height: 50,
                strokeWidth: 20,
                children: [],
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Column(
                  children: [
                    CustomButtonOutline(
                      label: 'Data Produk',
                      onPressed: () {},
                      width: 280,
                      height: 50,
                      icon: const FaIcon(
                        FontAwesomeIcons.database,
                        size: 14,
                        color: LightThemeColors.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButtonOutline(
                      label: 'Daftar Komposisi',
                      onPressed: () {},
                      width: 280,
                      height: 50,
                      icon: const FaIcon(
                        FontAwesomeIcons.layerGroup,
                        size: 14,
                        color: LightThemeColors.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButtonOutline(
                      label: 'Kategori Produk',
                      onPressed: () {
                        Get.toNamed(Routes.KATEGORI);
                      },
                      width: 280,
                      height: 50,
                      icon: const FaIcon(
                        FontAwesomeIcons.slack,
                        size: 14,
                        color: LightThemeColors.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButtonOutline(
                      label: 'Manajemen Stok',
                      onPressed: () {},
                      width: 280,
                      height: 50,
                      icon: const FaIcon(
                        FontAwesomeIcons.boxOpen,
                        size: 14,
                        color: LightThemeColors.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
