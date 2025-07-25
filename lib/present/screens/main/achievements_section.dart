import 'package:flutter/material.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Достижения',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _AchievementCard(
                  title: 'Первый герой',
                  description: 'Создайте первого персонажа',
                  icon: Icons.person_add,
                  color: Color(0xFF8B4513),
                  unlocked: true,
                ),
                SizedBox(width: 12),
                _AchievementCard(
                  title: 'Квестовед',
                  description: 'Завершите 10 квестов',
                  icon: Icons.assignment,
                  color: Color(0xFF2E8B57),
                  unlocked: false,
                ),
                SizedBox(width: 12),
                _AchievementCard(
                  title: 'Мастер слова',
                  description: 'Напишите 50 заметок',
                  icon: Icons.edit_note,
                  color: Color(0xFF483D8B),
                  unlocked: false,
                ),
                SizedBox(width: 12),
                _AchievementCard(
                  title: 'Исследователь',
                  description: 'Посетите все локации карты',
                  icon: Icons.map,
                  color: Color(0xFF006400),
                  unlocked: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool unlocked;

  const _AchievementCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 120,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: unlocked ? color.withOpacity(0.2) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked ? color : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        boxShadow:
            unlocked
                ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: unlocked ? 1.0 : 0.8,
            duration: const Duration(milliseconds: 200),
            child: Icon(icon, color: unlocked ? color : Colors.grey, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: unlocked ? Colors.white : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color:
                  unlocked
                      ? Colors.white.withOpacity(0.7)
                      : Colors.grey.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
