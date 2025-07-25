import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/services/user/user_repository.dart';
import 'package:putnik_app/models/user_model.dart';
import 'package:putnik_app/present/components/stories/stories_slider.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/present/screens/main/sections.dart';
import 'package:putnik_app/present/screens/main/rank_section.dart';
import 'package:putnik_app/present/screens/main/quick_actions_section.dart';
import 'package:putnik_app/present/screens/main/recent_activities_section.dart';
import 'package:putnik_app/present/screens/main/achievements_section.dart';
import 'package:putnik_app/present/screens/main/notifications_section.dart';
import 'package:putnik_app/present/screens/main/online_friends_section.dart';

@RoutePage()
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    return Scaffold(
      body:
          uid == null
              ? const Center(
                child: Text(
                  'Пользователь не найден',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : StreamBuilder<UserModel?>(
                stream: UserRepository().watchUser(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const StoriesSlider(),
                            if (snapshot.data != null)
                              RankSection(user: snapshot.data!),
                            const SizedBox(height: 16),
                            QuickActionsSection(role: snapshot.data?.role),
                            const SizedBox(height: 16),
                            OnlineFriendsSection(uid: uid!),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 12,
                              ),
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
                                  return SectionCard(section: section);
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Секция последних активностей
                            RecentActivitiesSection(),
                            const SizedBox(height: 16),
                            // Секция достижений
                            AchievementsSection(),
                            const SizedBox(height: 16),
                            // Секция уведомлений
                            NotificationsSection(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
