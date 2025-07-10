import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

class MainBar extends StatelessWidget {
  final TabsRouter tabsRouter;
  const MainBar({super.key, required this.tabsRouter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem('assets/icons/cup.svg', 0),
          _buildNavItem('assets/icons/chart.svg', 1),
          _buildNavItem('assets/icons/pets.svg', 2),
          _buildNavItem('assets/icons/bag.svg', 3),
          _buildNavItem('assets/icons/target.svg', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(String assetPath, int index) {
    bool isSelected = index == tabsRouter.activeIndex;
    return GestureDetector(
      onTap: () => tabsRouter.setActiveIndex(index),
      child: SvgPicture.asset(
        assetPath,
        width: 28,
        height: 28,
        color:
            isSelected
                ? (index == 2 ? Colors.orange : AppColors.blue)
                : AppColors.black,
      ),
    );
  }
}
