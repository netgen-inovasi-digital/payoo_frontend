import 'package:flutter/material.dart';
import '../../../../config/theme/light_theme.dart';

class CustomHeaderClipPath extends StatelessWidget {
  final Color backgroundColor;
  final LinearGradient gradient;
  final List<Widget>? children;
  final double height;
  final double strokeWidth;
  final MainAxisAlignment? mainAxisAlignment;

  const CustomHeaderClipPath(
      {super.key,
      this.children, // Konten dinamis
      required this.height,
      required this.strokeWidth,
      this.backgroundColor = LightThemeColors.primaryColor,
      this.gradient = const LinearGradient(
        colors: [LightThemeColors.accentColor, LightThemeColors.primaryColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, height + 15),
              painter: _CustomGradientCurveLinePainter(
                gradient: gradient,
                strokeWidth: strokeWidth,
              ),
            ),
            ClipPath(
              clipper: _CustomClipPath(),
              child: Container(
                height: height,
                color: backgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        mainAxisAlignment ?? MainAxisAlignment.center,
                    children: [
                      ...?children, // Tambahkan widget dinamis setelah header
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();
    path.lineTo(0, h); // pojok kiri atas ke pojok kiri bawah
    path.quadraticBezierTo(w * 0.5, h - 100, w, h); // lengkungan
    path.lineTo(w, 0); // pojok kanan bawah ke pojok kanan atas
    path.close(); // tutup path

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _CustomGradientCurveLinePainter extends CustomPainter {
  final LinearGradient gradient;
  final double strokeWidth;

  _CustomGradientCurveLinePainter(
      {required this.gradient, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(10, 0, size.width, size.height),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Path path = Path()
      ..moveTo(-10, size.height)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height - 110,
        size.width + 10,
        size.height,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
