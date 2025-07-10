import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/icons/Icons.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

class IconBtn extends StatelessWidget {
  final String iconName;
  final VoidCallback? onTap;
  final Color? color;
  final double? size;
  final double? padding;
  const IconBtn({
    super.key,
    required this.iconName,
    this.onTap,
    this.color,
    this.size,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        width: size ?? 40,
        height: size ?? 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 2, color: const Color(0xFFF8EDEB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconWidget(
          iconName: iconName,
          size: 24,
          color: color ?? AppColors.blue,
        ),
      ),
    );
  }
}
