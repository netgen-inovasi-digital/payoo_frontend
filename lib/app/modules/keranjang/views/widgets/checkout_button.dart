import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/components/custom_save_button.dart';
import 'package:payoo/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:payoo/app/modules/keranjang/views/widgets/pembayaran_modal.dart';
import 'package:payoo/app/modules/struk/views/struk_user_view.dart';
import 'package:payoo/app/modules/struk/views/struk_view.dart';
import 'package:payoo/app/modules/transaksi/views/transaksi_berhasil_view.dart';
import 'package:payoo/app/routes/app_pages.dart';
import 'package:payoo/config/theme/light_theme.dart';

class CheckoutButton extends StatefulWidget {
  CheckoutButton({super.key, required this.price, required this.controller, required this.cartItems, required this.totalPrice});
  final double totalPrice;
  final List cartItems;
  final String price;
  final KeranjangController controller;

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  bool expanded = false; // Moved to state class

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // White Card
          AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.only(
              top: 12,
              right: 25,
              left: 25,
              bottom: 12, // Added bottom padding
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
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
                      "Rp ${widget.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                    ),
                  ],
                ),
                // Animated note field
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: expanded
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
                          child: TextField(
                            controller: widget.controller.notesController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Catatan untuk pesanan Anda',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(8),
                            ),
                            maxLines: 3,
                            onChanged: (value) {
                              // Store note value if needed
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          // Green Button
          CustomSaveButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PembayaranModal(
                  controller: widget.controller,
                ),
              );
            },
            label:'Rp.${widget.totalPrice.toStringAsFixed(0)}  |  ${widget.cartItems.length} Item',
          )
        ],
      ),
    );
  }
}