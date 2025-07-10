import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/icons/Icons.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

class NewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const NewAppBar({super.key, required this.title, this.onBack, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: IconWidget(iconName: 'back', size: 34, color: AppColors.black),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
