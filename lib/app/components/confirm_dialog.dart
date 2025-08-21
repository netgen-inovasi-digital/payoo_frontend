import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String? title;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;

  const ConfirmDialog({
    super.key,
    required this.itemName,
    required this.onConfirm,
    this.onCancel,
    this.title,
    this.confirmText,
    this.cancelText,
    this.confirmButtonColor,
    this.cancelButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: 285,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title or confirmation text
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: title ?? 'Apakah Anda yakin ingin menghapus ',
                  ),
                  TextSpan(
                    text: itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ' ?'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancel ?? () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cancelButtonColor ?? Colors.grey[200],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      cancelText ?? 'Batal',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                
                // Confirm button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirm();
                      Get.back(); // Close dialog after action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmButtonColor ?? Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmText ?? 'Hapus',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Static method to show the dialog easily
  static Future<void> show({
    required BuildContext context,
    required String itemName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? title,
    String? confirmText,
    String? cancelText,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return ConfirmDialog(
          itemName: itemName,
          onConfirm: onConfirm,
          onCancel: onCancel,
          title: title,
          confirmText: confirmText,
          cancelText: cancelText,
          confirmButtonColor: confirmButtonColor,
          cancelButtonColor: cancelButtonColor,
        );
      },
    );
  }
}