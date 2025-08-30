import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/struk/views/struk_user_view.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({super.key});

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // White Card
          AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            duration: const Duration(milliseconds: 300),
            padding: expanded
                ? const EdgeInsets.symmetric(horizontal: 25, vertical: 12)
                : const EdgeInsets.only(
                    top: 12,
                    right: 25,
                    left: 25,
                  ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Rp 100.000",
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Rp 80.000",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                    ),
                  ],
                ),

                // Expanded list
                if (expanded) ...[
                  const SizedBox(height: 8),
                  buildPaymentOption("QRIS"),
                  buildPaymentOption("Bank"),
                  buildPaymentOption("Dana"),
                  buildPaymentOption("Bayar Ditempat"),
                ],
              ],
            ),
          ),

          // Green Button
          CustomSaveButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      content: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Take Away Option
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // Take away logic
                                  Get.to(StrukUserView());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Take Away",
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Makan Ditempat Option
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(StrukUserView());
                                  // Dine in logic
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2E7D32), // Green
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Makan Ditempat",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              label: "Lanjutkan Pesanan")
        ],
      ),
    );
  }

  Widget buildPaymentOption(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, top: 4, right: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
