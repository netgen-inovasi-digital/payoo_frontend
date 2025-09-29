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
  CheckoutButton({super.key, required this.price, required this.controller});
  final String price;
  final KeranjangController controller;
  var expanded = false;
  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
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
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        setState(() {
                          widget.expanded = !widget.expanded;
                        });
                      },
                    ),
                  ],
                ),

// Add this AnimatedContainer for the note
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: widget.expanded ? 100 : 0,
                  child: widget.expanded
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0,top: 5),
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
                          ),
                        )
                      : const SizedBox(),
                )
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

                // showDialog(
                //   context: context,
                //   builder: (dialogContext) {
                //     return AlertDialog(
                //       contentPadding: EdgeInsets.zero,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       content: Container(
                //         height: 160,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(15),
                //         ),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             // Take Away Option
                //             Expanded(
                //               child: InkWell(
                //                 onTap: () {
                //                   // Take away logic
                //                   Get.to(StrukUserView());
                //                 },
                //                 child: Container(
                //                   padding: const EdgeInsets.all(15),
                //                   decoration: const BoxDecoration(
                //                     color: Colors.white,
                //                     borderRadius: BorderRadius.only(
                //                       topLeft: Radius.circular(20),
                //                       bottomLeft: Radius.circular(20),
                //                     ),
                //                   ),
                //                   child: const Center(
                //                     child: Text(
                //                       "Take Away",
                //                       style: TextStyle(
                //                         color: Color(0xFF2E7D32),
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 16,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),

                //             // Makan Ditempat Option
                //             Expanded(
                //               child: InkWell(
                //                 onTap: () {
                //                   Get.to(StrukUserView());
                //                   // Dine in logic
                //                 },
                //                 child: Container(
                //                   padding: const EdgeInsets.all(15),
                //                   decoration: const BoxDecoration(
                //                     color: Color(0xFF2E7D32), // Green
                //                     borderRadius: BorderRadius.only(
                //                       topRight: Radius.circular(20),
                //                       bottomRight: Radius.circular(20),
                //                     ),
                //                   ),
                //                   child: const Center(
                //                     child: Text(
                //                       "Makan Ditempat",
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(
                //                         color: Colors.white,
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 16,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
              label: "Lanjutkan Pesanan")
        ],
      ),
    );
  }
}
