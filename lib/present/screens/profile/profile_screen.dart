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
      appBar: NewAppBar(
        title: 'Профиль',
        onBack: () => Navigator.of(context).maybePop(),
        actions: null,
      ),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 32),
                            // Fantasy profile card
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Fantasy avatar frame
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.4,
                                          ),
                                          blurRadius: 16,
                                          spreadRadius: 2,
                                        ),
                                      ],
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
                                              ? Icon(
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
                            // Fantasy section cards
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  _ProfileSectionCard(
                                    icon:
                                        Icons.auto_stories, // Книга приключений
                                    title: 'История приключений',
                                    onTap: () {},
                                  ),
                                  const SizedBox(height: 12),
                                  _ProfileSectionCard(
                                    icon: Icons.casino, // Кубик
                                    title: 'Кампании',
                                    onTap: () {},
                                  ),
                                  const SizedBox(height: 12),
                                  _ProfileSectionCard(
                                    icon: Icons.emoji_events, // Кубок
                                    title: 'Рейтинг героев',
                                    onTap: () {},
                                  ),
                                  const SizedBox(height: 12),
                                  _ProfileSectionCard(
                                    icon: Icons.groups, // Группа
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
                                    icon: Icons.note_add, // Заметки
                                    title: 'Заметки',
                                    onTap: () {
                                      context.router.push(
                                        const NotesListRoute(),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  _ProfileSectionCard(
                                    icon: Icons.stars, // Звезда
                                    title: 'Достижения',
                                    onTap: () {},
                                  ),
                                  const SizedBox(height: 12),
                                  _ProfileSectionCard(
                                    icon: Icons.bug_report, // Отладка
                                    title: 'Статус функций',
                                    onTap: () {
                                      context.router.push(
                                        const FeaturesStatusRoute(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 36),
                            // Fantasy buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      onPressed: () async {
                                        await ref
                                            .read(authServiceProvider)
                                            .logout();
                                        if (context.mounted) {
                                          context.router.replace(
                                            const AuthRoute(),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Покинуть таверну',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.error,
                                        side: BorderSide(
                                          color: AppColors.error,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      onPressed: () async {
                                        final confirmed = await showDialog<
                                          bool
                                        >(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                backgroundColor:
                                                    AppColors.surface,
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
                                                    color: AppColors.white
                                                        .withOpacity(0.8),
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
                                  ),
                                ],
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
