import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomAppBarSecondary extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? titleColor;

  const CustomAppBarSecondary({
    super.key,
    required this.title,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: 1,
      centerTitle: true,
      leading: IconButton(
        icon: FaIcon(FontAwesomeIcons.chevronLeft,
            color: iconColor ?? Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: iconColor ?? Colors.black),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          color: borderColor ?? const Color(0xFFFF9781),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2);
}
