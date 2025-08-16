import 'package:flutter/material.dart';
import 'package:payoo/app/modules/toko/views/widgets/button_cart.dart';
import 'package:payoo/app/modules/toko/views/widgets/header_toko.dart';
import 'package:payoo/app/modules/toko/views/widgets/list_view_ulasan.dart';
import 'widgets/bottom_navbar.dart';

class UlasanTokoView extends StatelessWidget {
  const UlasanTokoView({super.key});

  @override
  Widget build(BuildContext context) {
    final ulasanList = [
      {
        'user': 'User 1',
        'review': 'Burgernya enak, lezat.......',
        'menu': 'Cheese Burger',
        'date': '10-10-2024',
        'rating': 4,
      },
      {
        'user': 'User 2',
        'review': 'Kurang enak kaya di burg......',
        'menu': 'Krabby Patty',
        'date': '10-10-2024',
        'rating': 3,
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          const TokoHeader(),
          // Rating summary & distribusi bintang
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon bintang besar dan rating rata-rata
                const Column(
                  children: [
                    Icon(Icons.star, color: Color(0xFFFFC107), size: 48),
                    SizedBox(height: 4),
                    Text('4.5',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 16),
                // Distribusi bintang
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 5; i >= 1; i--)
                        Row(
                          children: [
                            Text('$i', style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 3),
                            const Icon(Icons.star,
                                color: Color(0xFFFFC107), size: 16),
                            const SizedBox(width: 4),
                            // Bar rating
                            Container(
                              height: 12,
                              width: [60, 40, 30, 20, 10][5 - i].toDouble(),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC107),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // List ulasan
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListViewUlasan(ulasanList: ulasanList),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: const CartFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
