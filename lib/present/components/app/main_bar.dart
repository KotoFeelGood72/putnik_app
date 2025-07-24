import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/mdi_light.dart';
import 'package:iconify_flutter/icons/ion.dart';

class MainBar extends StatefulWidget {
  final TabsRouter tabsRouter;
  final List<PageRouteInfo> routes;
  const MainBar({super.key, required this.tabsRouter, required this.routes});

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  int _currentIndex = 0;

  // Массив строк с именами иконок Iconify
  final List<String> navIcons = [
    Mdi.paw, // pets
    Mdi.view_dashboard, // dashboard
    Ion.book_outline, // glossary
    Mdi.account_circle, // profile
    Mdi.map, // map
    Mdi.note_edit, // notes
    Mdi.chat, // chat
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tabsRouter.activeIndex;
  }

  @override
  void didUpdateWidget(MainBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabsRouter.activeIndex != oldWidget.tabsRouter.activeIndex) {
      setState(() => _currentIndex = widget.tabsRouter.activeIndex);
    }
  }

  static const double barHeight = 64;
  static const double iconSize = 28;
  static const Color activeColor = Colors.white;
  static const Color inactiveColor = Color(0x99FFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barHeight,
      decoration: BoxDecoration(color: AppColors.surface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.routes.length, (index) {
          return _buildNavIcon(context, index, _currentIndex == index);
        }),
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, int index, bool isSelected) {
    return GestureDetector(
      onTap: () async {
        widget.tabsRouter.setActiveIndex(index);
        setState(() => _currentIndex = index);
      },
      child: Container(
        width: 56,
        height: barHeight,
        alignment: Alignment.center,
        child: Iconify(
          navIcons[index],
          size: iconSize,
          color: isSelected ? activeColor : inactiveColor,
        ),
      ),
    );
  }
}
