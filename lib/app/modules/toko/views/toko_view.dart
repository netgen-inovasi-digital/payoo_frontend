import 'package:flutter/material.dart';
import 'package:payoo/app/modules/toko/views/widgets/button_cart.dart';
import 'package:payoo/app/modules/toko/views/widgets/header_toko.dart';
import 'widgets/list_view_menu.dart';
import 'widgets/bottom_navbar.dart';

class TokoView extends StatelessWidget {
  const TokoView({super.key});

  @override
  Widget build(BuildContext context) {
    final menuList = [
      {
        'nama': 'Classic Burger',
        'harga': 20000,
        'image': 'assets/images/classic.png',
      },
      {
        'nama': 'Cheese Burger',
        'harga': 20000,
        'image': 'assets/images/cheese.png',
      },
      {
        'nama': 'Krabby patty',
        'harga': 20000,
        'image': 'assets/images/krabby.png',
      },
      {
        'nama': 'Classic Burger',
        'harga': 20000,
        'image': 'assets/images/classic.png',
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          // Header dengan gambar toko
          const TokoHeader(),
          // Menu list
          Expanded(
            child: MenuListSection(menuList: menuList),
          ),
        ],
      ),
      // Bottom navigation
      bottomNavigationBar: const BottomNavBar(),
      // Floating action button keranjang
      floatingActionButton: const CartFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class MenuListSection extends StatelessWidget {
  final List<Map<String, dynamic>> menuList;
  const MenuListSection({super.key, required this.menuList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Filter buttons
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.red, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Menu items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final menu = menuList[index];
                return MenuListItem(menu: menu);
              },
            ),
          ),
        ],
      ),
    );
  }
}
