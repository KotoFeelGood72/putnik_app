import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/services/user/user_repository.dart';
import 'package:putnik_app/models/user_model.dart';
import 'package:putnik_app/present/screens/profile/profile_screen.dart';

import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/components/stories/stories_slider.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

@RoutePage()
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = [
      _SectionData(
        'Персонажи',
        Icons.shield,
        const Color(0xFF8B4513),
        const Color(0xFFD2691E),
      ),
      _SectionData(
        'Друзья',
        Icons.auto_awesome,
        const Color(0xFF2E8B57),
        const Color(0xFF3CB371),
      ),
      _SectionData(
        'Чаты',
        Icons.chat,
        const Color(0xFF5B2333),
        const Color(0xFF7A2F42),
      ),
      _SectionData(
        'Комнаты',
        Icons.castle,
        const Color(0xFF4B0082),
        const Color(0xFF8A2BE2),
      ),
      _SectionData(
        'Настройки',
        Icons.menu_book,
        const Color(0xFFB8860B),
        const Color(0xFFDAA520),
      ),
      _SectionData(
        'Глоссарий',
        Icons.menu_book,
        const Color(0xFF8B0000),
        const Color(0xFFDC143C),
      ),
      _SectionData(
        'Карта',
        Icons.map,
        const Color(0xFF006400),
        const Color(0xFF228B22),
      ),
      _SectionData(
        'Заметки',
        Icons.edit_note,
        const Color(0xFF483D8B),
        const Color(0xFF6A5ACD),
      ),
    ];

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: NewAppBar(title: 'Главная', actions: null, showBackButton: false),
      body:
          uid == null
              ? const Center(
                child: Text(
                  'Пользователь не найден',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : FutureBuilder<UserModel?>(
                future: UserRepository().getUser(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  final userModel = snapshot.data;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- КНОПКА СОЗДАТЬ КОМНАТУ ---
                          if (userModel?.role == 'master')
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 4,
                                ),
                                icon: const Icon(
                                  Icons.castle,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Создать комнату',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  context.router.push(const ChatListRoute());
                                },
                              ),
                            ),
                          // Сторис слайдер
                          const StoriesSlider(),
                          // Секция ранга и прогресса
                          _buildRankSection(),
                          const SizedBox(height: 16),
                          // Секция быстрых действий
                          _buildQuickActions(context),
                          const SizedBox(height: 16),
                          // Секция друзей онлайн
                          _buildOnlineFriends(context),
                          const SizedBox(height: 16),
                          // Карточки разделов
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: sections.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    childAspectRatio: 1.2,
                                  ),
                              itemBuilder: (context, index) {
                                final section = sections[index];
                                return _SectionCard(section: section);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Секция последних активностей
                          _buildRecentActivities(),
                          const SizedBox(height: 16),
                          // Секция достижений
                          _buildAchievements(),
                          const SizedBox(height: 16),
                          // Секция уведомлений
                          _buildNotifications(context),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildRankSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF2A2A2A), const Color(0xFF3A3A3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8860B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Ранг: Новичок',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Прогресс-бар ранга
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Прогресс до следующего ранга',
                      style: TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                    Text(
                      '62%',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1247 / 2000, // 62.35%
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB8860B), Color(0xFFDAA520)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Быстрые действия',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Создать героя',
                  Icons.person_add,
                  const Color(0xFF8B4513),
                  () {
                    context.router.push(CreateHeroRoute());
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Новый квест',
                  Icons.assignment_add,
                  const Color(0xFF2E8B57),
                  () {
                    // TODO: Навигация к созданию квеста
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Функция создания квестов в разработке'),
                        backgroundColor: Color(0xFF2E8B57),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Последние активности',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildActivityItem(
                  'Создан новый герой "Арагорн"',
                  '2 часа назад',
                  Icons.person_add,
                  const Color(0xFF8B4513),
                ),
                _buildActivityItem(
                  'Завершен квест "Охота на тролля"',
                  '5 часов назад',
                  Icons.assignment_turned_in,
                  const Color(0xFF2E8B57),
                ),
                _buildActivityItem(
                  'Получен опыт: +150 XP',
                  '1 день назад',
                  Icons.star,
                  const Color(0xFFB8860B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              children: [
                _buildAchievementCard(
                  'Первый герой',
                  'Создайте первого персонажа',
                  Icons.person_add,
                  const Color(0xFF8B4513),
                  true,
                ),
                const SizedBox(width: 12),
                _buildAchievementCard(
                  'Квестовед',
                  'Завершите 10 квестов',
                  Icons.assignment,
                  const Color(0xFF2E8B57),
                  false,
                ),
                const SizedBox(width: 12),
                _buildAchievementCard(
                  'Мастер слова',
                  'Напишите 50 заметок',
                  Icons.edit_note,
                  const Color(0xFF483D8B),
                  false,
                ),
                const SizedBox(width: 12),
                _buildAchievementCard(
                  'Исследователь',
                  'Посетите все локации карты',
                  Icons.map,
                  const Color(0xFF006400),
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    String title,
    String description,
    IconData icon,
    Color color,
    bool unlocked,
  ) {
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

  Widget _buildNotifications(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Уведомления',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B2333),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildNotificationItem(
                  'Новый квест доступен',
                  'Квест "Тайны древнего храма" теперь доступен для прохождения',
                  Icons.assignment,
                  const Color(0xFF2E8B57),
                  true,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Переход к квесту "Тайны древнего храма"',
                        ),
                        backgroundColor: Color(0xFF2E8B57),
                      ),
                    );
                  },
                ),
                _buildNotificationItem(
                  'Друг онлайн',
                  'Гэндальф присоединился к игре',
                  Icons.person,
                  const Color(0xFF8B4513),
                  false,
                  () {
                    context.router.push(ChatListRoute());
                  },
                ),
                _buildNotificationItem(
                  'Обновление системы',
                  'Добавлены новые заклинания и способности',
                  Icons.system_update,
                  const Color(0xFF483D8B),
                  false,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Обновление системы загружено'),
                        backgroundColor: Color(0xFF483D8B),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    IconData icon,
    Color color,
    bool isUnread,
    VoidCallback? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color:
                                isUnread
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineFriends(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Друзья онлайн',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildOnlineFriendItem(
                  'Гэндальф',
                  Icons.person,
                  const Color(0xFF8B4513),
                  () => context.router.push(ChatListRoute()),
                ),
                _buildOnlineFriendItem(
                  'Леголас',
                  Icons.person,
                  const Color(0xFF2E8B57),
                  () => context.router.push(ChatListRoute()),
                ),
                _buildOnlineFriendItem(
                  'Фродо',
                  Icons.person,
                  const Color(0xFF5B2333),
                  () => context.router.push(ChatListRoute()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineFriendItem(
    String name,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionData {
  final String title;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;
  const _SectionData(
    this.title,
    this.icon,
    this.primaryColor,
    this.accentColor,
  );
}

class _SectionCard extends StatefulWidget {
  final _SectionData section;
  const _SectionCard({required this.section});

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
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
