import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/icons/Icons.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

class NewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showBackButton;

  const NewAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
      ),
      leading:
          showBackButton
              ? IconButton(
                icon: IconWidget(
                  iconName: 'back',
                  size: 28,
                  color: AppColors.white,
                ),
                onPressed: onBack ?? () => Navigator.of(context).pop(),
              )
              : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          fontFamily: 'Forum',
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
