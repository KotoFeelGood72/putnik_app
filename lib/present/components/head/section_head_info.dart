import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import 'package:putnik_app/present/theme/app_colors.dart';

class SectionHeadInfo extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  const SectionHeadInfo({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            title!,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Container(
            child: GestureDetector(
              onTap: onTap,
              child: Iconify(Ph.info_light, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
