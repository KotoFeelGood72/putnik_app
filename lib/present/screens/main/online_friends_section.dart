import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/models/user_model.dart';
import 'package:putnik_app/services/user/user_repository.dart';

class OnlineFriendsSection extends StatelessWidget {
  const OnlineFriendsSection({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Друзья онлайн',
            style: TextStyle(
              fontSize: 20,
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
            child: StreamBuilder<List<UserModel>>(
              stream: UserRepository().watchOnlineFriends(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final friends = snapshot.data ?? [];
                if (friends.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Нет друзей онлайн',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  );
                }
                return Column(
                  children:
                      friends
                          .map(
                            (friend) => _OnlineFriendItem(
                              name: friend.name ?? 'Без имени',
                              icon: Icons.person,
                              color: const Color(0xFF8B4513),
                              onTap: () => context.router.push(ChatListRoute()),
                            ),
                          )
                          .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OnlineFriendItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _OnlineFriendItem({
    required this.name,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
