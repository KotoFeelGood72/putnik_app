import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'dart:math' as math;
import 'package:putnik_app/present/components/icons/Icons.dart';

class MainBar extends StatefulWidget {
  final TabsRouter tabsRouter;
  final List<PageRouteInfo> routes;
  const MainBar({super.key, required this.tabsRouter, required this.routes});

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  int _currentIndex = 0;

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
  static const Color barBg = Color(0xFF181A23);
  static const Color activeColor = Colors.white;
  static const Color inactiveColor = Color(0x99FFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barHeight,
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: barBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.routes.length, (index) {
          final route = widget.routes[index];
          final iconData = _iconDataForRoute(route);
          return _buildMaterialNavIcon(
            context,
            iconData,
            index,
            _currentIndex == index,
          );
        }),
      ),
    );
  }

  Widget _buildMaterialNavIcon(
    BuildContext context,
    IconData icon,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        widget.tabsRouter.setActiveIndex(index);
        setState(() => _currentIndex = index);
      },
      child: Container(
        width: 56,
        height: barHeight,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: iconSize,
          color: isSelected ? activeColor : inactiveColor,
        ),
      ),
    );
  }

  IconData _iconDataForRoute(PageRouteInfo route) {
    final name = route.runtimeType.toString();
    if (name.contains('HeroListRoute')) return Icons.pets;
    if (name.contains('MainRoute')) return Icons.dashboard;
    if (name.contains('GlossaryRoute')) return Icons.menu_book;
    if (name.contains('ProfileRoute')) return Icons.account_circle;
    if (name.contains('GalarionMapRoute')) return Icons.map;
    if (name.contains('NotesListRoute')) return Icons.edit_note;
    if (name.contains('ChatListRoute')) return Icons.chat;
    return Icons.circle;
  }
}

class _NotchedBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final double notchRadius = 28;
    final double notchCenterX = size.width / 2;
    final double barHeight = size.height - 6;
    final double cornerRadius = 18;

    final path = Path();
    // Left rounded corner
    path.moveTo(0, barHeight - cornerRadius);
    path.quadraticBezierTo(0, barHeight, cornerRadius, barHeight);
    // Left to notch
    path.lineTo(notchCenterX - notchRadius - 10, barHeight);
    // Notch curve up
    path.quadraticBezierTo(
      notchCenterX - notchRadius - 2,
      barHeight,
      notchCenterX - notchRadius,
      barHeight - 2,
    );
    // Notch arc
    path.arcTo(
      Rect.fromCircle(
        center: Offset(notchCenterX, barHeight - notchRadius + 2),
        radius: notchRadius,
      ),
      math.pi,
      -math.pi,
      false,
    );
    // Notch curve down
    path.quadraticBezierTo(
      notchCenterX + notchRadius + 2,
      barHeight,
      notchCenterX + notchRadius + 10,
      barHeight,
    );
    // Right to corner
    path.lineTo(size.width - cornerRadius, barHeight);
    path.quadraticBezierTo(
      size.width,
      barHeight,
      size.width,
      barHeight - cornerRadius,
    );
    // Top right
    path.lineTo(size.width, cornerRadius);
    path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);
    // Top left
    path.lineTo(cornerRadius, 0);
    path.quadraticBezierTo(0, 0, 0, cornerRadius);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.08), 4, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
