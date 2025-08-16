import 'package:flutter/material.dart';
import '../../../components/custom_button.dart';
import 'widgets/list_view_store.dart';
import 'widgets/top_bar.dart';

class DashboardUserView extends StatelessWidget {
  const DashboardUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokoList = [
      {
        'nama': 'Kebab Jaya',
        'kategori': 'Makanan',
        'rating': 4.8,
        'jarak': '400m',
        'image': 'assets/images/kebab.png',
      },
      {
        'nama': 'Burger Mekar',
        'kategori': 'Makanan',
        'rating': 4.8,
        'jarak': '200m',
        'image': 'assets/images/burger.png',
      },
      {
        'nama': 'Terang Bulan Uhuy',
        'kategori': 'Makanan',
        'rating': 4.8,
        'jarak': '500m',
        'image': 'assets/images/terangbulan.png',
      },
      {
        'nama': 'Capcin Intansari',
        'kategori': 'Minuman',
        'rating': 4.8,
        'jarak': '200m',
        'image': 'assets/images/capcin.png',
      },
      {
        'nama': 'Terang Bulan Uhuy',
        'kategori': 'Makanan',
        'rating': 4.8,
        'jarak': '300m',
        'image': 'assets/images/terangbulan.png',
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          // Map Section with Overlay
          SizedBox(
            height: 290,
            child: Stack(
              children: [
                // Map container
                Container(
                  height: 290,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'MAP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Search bar and user icon overlay
                const Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: TopBar(),
                ),
                // Find nearest store button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: CustomButton(
                    label: 'Cari toko terdekat',
                    onPressed: () {},
                    backgroundColor: Colors.green[400]!,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    borderRadius: 25,
                    width: 140,
                    height: 40,
                  ),
                ),
              ],
            ),
          ),
          // Store list section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.redAccent, width: 3),
                ),
              ),
              child: ListViewStore(tokoList: tokoList),
            ),
          ),
        ],
      ),
    );
  }
}
