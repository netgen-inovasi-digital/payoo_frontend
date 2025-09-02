import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/keranjang/views/keranjang_view.dart';
import 'package:payoo/app/modules/pesanan/views/pesanan_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/pesanan/views/pesanan_view.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  final Color backgroundColor;
  final LinearGradient gradient;
  final double height = 72;
  final double strokeWidth = 15;
  final MainAxisAlignment? mainAxisAlignment;

  const BottomNavBar({
    super.key,
    this.backgroundColor = LightThemeColors.primaryColor,
    this.gradient = const LinearGradient(
      colors: [
      LightThemeColors.accentColor,
      LightThemeColors.accentColor,
      LightThemeColors.primaryColor
      ],
      stops: [0.0, 0.4, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.bottomRight,
    ),
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height + 38, // Extra space for floating button
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Custom background curve
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, height + 15),
            painter: _CustomGradientCurveLinePainter(
              gradient: gradient,
              strokeWidth: strokeWidth,
              backgroundColor: backgroundColor,
            ),
          ),
          // Navigation items
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 10,left: 15,right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.menu, 'Semua', onTap: () {}),
                  _buildNavItem(Icons.favorite, 'Favorit', onTap: () {}),
                  _buildNavItem(Icons.percent, 'Diskon', onTap: () {}),
                  _buildNavItem(Icons.campaign, 'Promo', onTap: () {}),
                ],
              ),
            ),
          ),
          // Floating Cart Button
          Positioned(
            top: -10,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  // Handle cart button tap
                  Get.toNamed(Routes.KERANJANG);
                },
                child: Icon(
                  Icons.shopping_cart,
                  color: LightThemeColors.primaryColor,
                  size: 30,
                ),
              ),
            ),
          ),
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

class _CustomGradientCurveLinePainter extends CustomPainter {
  final LinearGradient gradient;
  final double strokeWidth;
  final Color backgroundColor;

  _CustomGradientCurveLinePainter({
    required this.gradient,
    required this.strokeWidth,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Only paint if height is greater than 0
    if (size.height <= 15) return; // 15 is the added offset
    
    // Create the curved path
    Path curvePath = Path()
      ..moveTo(-10, size.height - 15)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height - 120, // Adjusted for the offset
        size.width + 10,
        size.height - 10,
      );

    // Create fill path (area below the curve)
    Path fillPath = Path()
      ..moveTo(-10, size.height - 15)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height - 120, // Adjusted for the offset
        size.width + 10,
        size.height - 15,
      )
      ..lineTo(size.width + 10, size.height + 200) // extend below
      ..lineTo(-10, size.height + 200) // go across bottom
      ..close();

    // Fill paint for the area below the curve
    Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // Draw the filled area below the curve
    canvas.drawPath(fillPath, fillPaint);

    // Stroke paint for the curve line with gradient
    Paint strokePaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw the gradient stroke on the curve
    canvas.drawPath(curvePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
            Icon(widget.icon, color: Colors.white, size: 25),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
