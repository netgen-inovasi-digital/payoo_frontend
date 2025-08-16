import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/pesanan/views/pesanan_view.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.apps, 'Semua', onTap: () {}),
          _buildNavItem(Icons.favorite_border, 'Favorit', onTap: () {}),
          const SizedBox(width: 40), // Space for Cart Button
          _buildNavItem(Icons.local_offer, 'Promo', onTap: () {}),
          _buildNavItem(Icons.campaign, 'Pesanan', onTap: () {
            Get.to(() => const PesananView());
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {VoidCallback? onTap}) {
    return _AnimatedNavItem(
      icon: icon,
      label: label,
      onTap: onTap,
    );
  }
}

class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> {
  double _scale = 1.0;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.85;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
