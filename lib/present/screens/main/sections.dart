import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:putnik_app/present/routes/app_router.dart';

class SectionData {
  final String title;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;
  const SectionData(this.title, this.icon, this.primaryColor, this.accentColor);
}

final List<SectionData> sections = [
  SectionData('Персонажи', Icons.shield, Color(0xFF8B4513), Color(0xFFD2691E)),
  SectionData(
    'Друзья',
    Icons.auto_awesome,
    Color(0xFF2E8B57),
    Color(0xFF3CB371),
  ),
  SectionData('Чаты', Icons.chat, Color(0xFF5B2333), Color(0xFF7A2F42)),
  SectionData('Комнаты', Icons.castle, Color(0xFF4B0082), Color(0xFF8A2BE2)),
  SectionData(
    'Настройки',
    Icons.menu_book,
    Color(0xFFB8860B),
    Color(0xFFDAA520),
  ),
  SectionData(
    'Глоссарий',
    Icons.menu_book,
    Color(0xFF8B0000),
    Color(0xFFDC143C),
  ),
  SectionData('Карта', Icons.map, Color(0xFF006400), Color(0xFF228B22)),
  SectionData('Заметки', Icons.edit_note, Color(0xFF483D8B), Color(0xFF6A5ACD)),
  SectionData(
    'Приключения',
    Icons.edit_note,
    Color(0xFF483D8B),
    Color(0xFF6A5ACD),
  ),
  SectionData(
    'Магазин',
    Icons.shopping_cart,
    Color(0xFF8B4513),
    Color(0xFFD2691E),
  ),
];

class SectionCard extends StatefulWidget {
  final SectionData section;
  const SectionCard({required this.section, Key? key}) : super(key: key);

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          if (widget.section.title == 'Настройки') {
            context.router.push(ProfileRoute());
          } else if (widget.section.title == 'Персонажи') {
            context.router.push(HeroListRoute());
          } else if (widget.section.title == 'Карта') {
            context.router.push(GalarionMapRoute());
          } else if (widget.section.title == 'Чаты') {
            context.router.push(ChatListRoute());
          } else if (widget.section.title == 'Магазин') {
            context.router.push(ShopRoute());
          }
          // TODO: Навигация в другие разделы
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    widget.section.icon,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.section.title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
