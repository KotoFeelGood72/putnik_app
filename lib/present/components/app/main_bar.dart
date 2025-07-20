import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/routes/app_router.dart';

class MainBar extends StatefulWidget {
  final TabsRouter tabsRouter;
  const MainBar({super.key, required this.tabsRouter});

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
    // Синхронизируем состояние при изменении активной вкладки
    if (widget.tabsRouter.activeIndex != oldWidget.tabsRouter.activeIndex) {
      setState(() => _currentIndex = widget.tabsRouter.activeIndex);
    }
  }

  static const double barHeight = 50;
  static const double iconSize = 16;
  static const Color barBg = Color(0xFF1A1A1A);
  static const Color cardBg = Color(0xFF2A2A2A);
  static const Color activeColor = Color(0xFF5B2333);
  static const Color textColor = Colors.white;
  static const Color inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    int active = widget.tabsRouter.activeIndex;
    return Container(
      height: barHeight,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: barBg,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildNavItem(
              context,
              Icons.pets,
              0,
              'Герои',
              _currentIndex == 0,
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            child: _buildNavItem(
              context,
              Icons.dashboard,
              1,
              'Дашборд',
              _currentIndex == 1,
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            child: _buildNavItem(
              context,
              Icons.menu_book,
              3,
              'Глоссарий',
              _currentIndex == 3,
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            child: _buildNavItem(
              context,
              Icons.settings,
              4,
              'Настройки',
              _currentIndex == 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    int index,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        if (index == 0) {
          // Герои
          widget.tabsRouter.setActiveIndex(0);
          setState(() => _currentIndex = 0);
        } else if (index == 1) {
          // Дашборд
          widget.tabsRouter.setActiveIndex(1);
          setState(() => _currentIndex = 1);
        } else if (index == 3) {
          // Глоссарий
          setState(() => _currentIndex = 3);
          final result = await context.router.push(GlossaryRoute());
          // После возврата из глоссария, сбрасываем состояние на активную вкладку
          if (result == null) {
            setState(() => _currentIndex = widget.tabsRouter.activeIndex);
          }
        } else if (index == 4) {
          // Настройки
          setState(() => _currentIndex = 4);
          final result = await context.router.push(ProfileRoute());
          // После возврата из профиля, сбрасываем состояние на активную вкладку
          if (result == null) {
            setState(() => _currentIndex = widget.tabsRouter.activeIndex);
          }
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : cardBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child:
            isSelected
                ? Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: iconSize, color: textColor),
                      SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
                : Center(
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: isSelected ? textColor : inactiveColor,
                  ),
                ),
      ),
    );
  }
}
