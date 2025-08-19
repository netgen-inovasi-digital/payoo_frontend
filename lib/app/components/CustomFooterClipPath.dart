import 'package:flutter/material.dart';
import '../../../../config/theme/light_theme.dart';

class CustomFooterClipPath extends StatelessWidget {
  final Color backgroundColor;
  final LinearGradient gradient;
  final List<Widget>? children;
  final double height;
  final double strokeWidth;
  final MainAxisAlignment? mainAxisAlignment;

  const CustomFooterClipPath({
    super.key,
    this.children, // Konten dinamis
    required this.height,
    required this.strokeWidth,
    this.backgroundColor = LightThemeColors.primaryColor,
    this.gradient = const LinearGradient(
      colors: [LightThemeColors.accentColor, LightThemeColors.primaryColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none, 
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, height + 15),
              painter: _CustomGradientCurveLinePainter(
                gradient: gradient,
                strokeWidth: strokeWidth,
                backgroundColor: backgroundColor,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                children: [
                  ...?children,
                ],
              ),
            ),
          ],
        ),
      ],
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
        size.height - 125, // Adjusted for the offset
        size.width + 10,
        size.height - 15,
      );

    // Create fill path (area below the curve)
    Path fillPath = Path()
      ..moveTo(-10, size.height - 15)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height - 125, // Adjusted for the offset
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