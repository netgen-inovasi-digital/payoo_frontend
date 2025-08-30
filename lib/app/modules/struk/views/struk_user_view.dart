import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/pesanan/views/pesanan_view.dart';
import 'package:payoo/config/theme/light_theme.dart';

class ScallopPainter extends CustomPainter {
  final Color color;

  const ScallopPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    
    // Start from the top-left corner
    path.moveTo(0, 0);

    // Draw the top edge with scallops
    final double scallopsWidth = 35.0;
    final int scallopsCount = (size.width / scallopsWidth).ceil();

    for (int i = 0; i < scallopsCount; i++) {
      final double startX = i * scallopsWidth;
      final double midX = startX + (scallopsWidth / 2);
      final double endX = startX + scallopsWidth;

      if (i == 0) {
        path.lineTo(startX, 0);
      }
      path.quadraticBezierTo(midX, size.height, endX, 0);
    }

    // Complete the path
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StrukUserView extends StatelessWidget {
  const StrukUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Struk Pesanan',
        dividerLine: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: LightThemeColors.primaryColor,
              width: 24.0,
              style: BorderStyle.solid,
            ),
            left: BorderSide(
              color: LightThemeColors.primaryColor,
              width: 12.0,
              style: BorderStyle.solid,
            ),
            right: BorderSide(
              color: LightThemeColors.primaryColor,
              width: 12.0,
              style: BorderStyle.solid,
            ),
            bottom: BorderSide(
              color: LightThemeColors.primaryColor,
              width: 12.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            SizedBox(
              width: double.infinity,
              height: 25,
              child: CustomPaint(
                painter: ScallopPainter(color: LightThemeColors.primaryColor),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Info
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            'Query Burger',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Jl Guntung Alaban',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '0819-9656-9998',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),

                    // Transaction Info
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '22-02-2022',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '13.00',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No Transaksi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '2025123456789',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Point',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '+10',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Items Section Header
                    const Center(
                      child: Text(
                        'Pesanan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Classic Burger
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Classic Burger',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '2x25.000',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Rp. 50.000',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Beef Mentai
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beef Mentai',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '1x25.000',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Rp. 25.000',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),

                    // Summary Section
                    _buildSummaryRow('Total Item', '3'),
                    _buildSummaryRow('Sub Total', 'Rp. 75.000'),
                    _buildSummaryRow('Potongan', 'Rp. 0'),
                    const SizedBox(height: 5),
                    _buildSummaryRow('Total', 'Rp. 75.000', isBold: true),
                    _buildSummaryRow('Metode Pembayaran', 'Cash', isBold: true),
                    _buildSummaryRow('Bayar', 'Rp. 100.000', isBold: true),
                    _buildSummaryRow('Kembali', 'Rp. 25.000', isBold: true),

                    const SizedBox(height: 10),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),

                    // Thank you message
                    const Center(
                      child: Text(
                        'Terima kasih telah berbelanja',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  35.0,vertical: 16),
        child: CustomSaveButton(onPressed: () {
          Get.to(PesananView());
        }, label: "Lihat Pesanan"),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
