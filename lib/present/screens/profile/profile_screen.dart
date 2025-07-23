import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/services/user/user_repository.dart';
import 'package:putnik_app/models/user_model.dart';
import 'package:putnik_app/services/providers/auth_provider.dart';
import 'package:auto_route/auto_route.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NewAppBar(title: 'Профиль', actions: null),
      body: SafeArea(
        child:
            uid == null
                ? const Center(
                  child: Text(
                    'Пользователь не найден',
                    style: TextStyle(color: AppColors.white),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Профильная карточка
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary.withOpacity(
                                        0.15,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 44,
                                      backgroundColor: AppColors.primary
                                          .withOpacity(0.2),
                                      backgroundImage:
                                          (userModel != null &&
                                                  userModel.avatar != null &&
                                                  userModel.avatar!.isNotEmpty)
                                              ? NetworkImage(userModel.avatar!)
                                              : null,
                                      child:
                                          (userModel == null ||
                                                  userModel.avatar == null ||
                                                  userModel.avatar!.isEmpty)
                                              ? const Icon(
                                                Icons.shield,
                                                size: 44,
                                                color: AppColors.white,
                                              )
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    userModel?.name ?? 'Без имени',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: AppColors.white,
                                      letterSpacing: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  // --- SWITCHER ---
                                  if (userModel != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: _RoleSwitcher(
                                        uid: userModel.uid,
                                        currentRole: userModel.role,
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  Text(
                                    userModel?.email ?? '',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white.withOpacity(0.7),
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Секции профиля
                            Column(
                              children: [
                                if (userModel?.role == 'master') ...[
                                  _ProfileSectionCard(
                                    icon: Icons.castle,
                                    title: 'Создать комнату',
                                    accent: true,
                                    onTap: () {
                                      context.router.push(
                                        const ChatListRoute(),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                _ProfileSectionCard(
                                  icon: Icons.auto_stories,
                                  title: 'История приключений',
                                  onTap: () {},
                                ),
                                const SizedBox(height: 12),
                                _ProfileSectionCard(
                                  icon: Icons.casino,
                                  title: 'Кампании',
                                  onTap: () {},
                                ),
                                const SizedBox(height: 12),
                                _ProfileSectionCard(
                                  icon: Icons.emoji_events,
                                  title: 'Рейтинг героев',
                                  onTap: () {},
                                ),
                                const SizedBox(height: 12),
                                _ProfileSectionCard(
                                  icon: Icons.groups,
                                  title: 'Товарищи',
                                  onTap: () {},
                                ),
                                const SizedBox(height: 12),
                                _ProfileSectionCard(
                                  icon: Icons.edit,
                                  title: 'Редактировать героя',
                                  accent: true,
                                  onTap: () async {
                                    final result = await context.router.push(
                                      ProfileEditRoute(),
                                    );
                                    if (result == true) {
                                      (context as Element).markNeedsBuild();
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),
                                _ProfileSectionCard(
                                  icon: Icons.note_add,
                                  title: 'Заметки',
                                  onTap: () {
                                    context.router.push(const NotesListRoute());
                                  },
                                ),
                                const SizedBox(height: 12),
                                _ProfileSectionCard(
                                  icon: Icons.stars,
                                  title: 'Достижения',
                                  onTap: () {},
                                ),
                                const SizedBox(height: 12),
                                _ProfileSectionCard(
                                  icon: Icons.bug_report,
                                  title: 'Статус функций',
                                  onTap: () {
                                    context.router.push(
                                      const FeaturesStatusRoute(),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 36),
                            // Кнопки действий
                            Btn(
                              text: 'Покинуть таверну',
                              onPressed: () async {
                                await ref.read(authServiceProvider).logout();
                                if (context.mounted) {
                                  context.router.replace(const AuthRoute());
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        backgroundColor: AppColors.surface,
                                        title: const Text(
                                          'Удалить героя?',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          'Вы уверены, что хотите удалить героя? Это действие необратимо.',
                                          style: TextStyle(
                                            color: AppColors.white.withOpacity(
                                              0.8,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                            child: const Text(
                                              'Отмена',
                                              style: TextStyle(
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                            child: const Text(
                                              'Удалить',
                                              style: TextStyle(
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                                if (confirmed == true) {
                                  await ref
                                      .read(authServiceProvider)
                                      .deleteAccount();
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                              child: const Text(
                                'Удалить героя',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

// Вспомогательный виджет для карточки раздела профиля
class _ProfileSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool accent;

  const _ProfileSectionCard({
    required this.icon,
    required this.title,
    this.onTap,
    this.accent = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accent ? AppColors.primary.withOpacity(0.2) : AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      elevation: accent ? 0 : 4,
      shadowColor: AppColors.primary.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent ? AppColors.white : AppColors.primary,
                    width: accent ? 3 : 2,
                  ),
                  color:
                      accent
                          ? AppColors.primary.withOpacity(0.3)
                          : Colors.transparent,
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  icon,
                  size: 28,
                  color:
                      accent
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color:
                        accent
                            ? AppColors.white
                            : AppColors.white.withOpacity(0.9),
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: accent ? AppColors.white : AppColors.primary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleSwitcher extends StatefulWidget {
  final String uid;
  final String? currentRole;
  const _RoleSwitcher({required this.uid, required this.currentRole});

  @override
  State<_RoleSwitcher> createState() => _RoleSwitcherState();
}

class _RoleSwitcherState extends State<_RoleSwitcher> {
  late String? _role;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _role = widget.currentRole;
  }

  Future<void> _setRole(String newRole) async {
    if (_role == newRole) return;
    setState(() => _loading = true);
    await UserRepository().saveUser(UserModel(uid: widget.uid, role: newRole));
    setState(() {
      _role = newRole;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SwitcherButton(
          text: 'Мастер игр',
          active: _role == 'master',
          color: AppColors.accent,
          onTap: _loading ? null : () => _setRole('master'),
        ),
        const SizedBox(width: 12),
        _SwitcherButton(
          text: 'Герой',
          active: _role == 'hero',
          color: AppColors.primary,
          onTap: _loading ? null : () => _setRole('hero'),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
}

class _SwitcherButton extends StatelessWidget {
  final String text;
  final bool active;
  final Color color;
  final VoidCallback? onTap;
  const _SwitcherButton({
    required this.text,
    required this.active,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? color : Colors.grey, width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? color : Colors.grey,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
