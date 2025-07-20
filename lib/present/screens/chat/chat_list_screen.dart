import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

@RoutePage()
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<ChatPreview> _chats = [
    ChatPreview(
      id: "1",
      name: "Гэндальф",
      lastMessage: "Отлично! Тогда встретимся у таверны 'Золотой дракон'",
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      unreadCount: 2,
      avatar: "Г",
    ),
    ChatPreview(
      id: "2",
      name: "Арагорн",
      lastMessage: "Клинок готов к бою!",
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
      avatar: "А",
    ),
    ChatPreview(
      id: "3",
      name: "Леголас",
      lastMessage: "Стрелы не подведут",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 1,
      avatar: "Л",
    ),
    ChatPreview(
      id: "4",
      name: "Гимли",
      lastMessage: "Топор и борода - мои лучшие друзья!",
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      avatar: "Г",
    ),
    ChatPreview(
      id: "5",
      name: "Фродо",
      lastMessage: "Кольцо в безопасности",
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
      avatar: "Ф",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NewAppBar(title: "Чаты"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface.withOpacity(0.8), AppColors.background],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _chats.length,
          itemBuilder: (context, index) {
            final chat = _chats[index];
            return _buildChatCard(chat, context);
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.accentLight],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Добавить создание нового чата
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: AppColors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildChatCard(ChatPreview chat, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.surface.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.router.push(ChatRoute(chatId: chat.id));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Аватар
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accentLight, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      chat.avatar,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Информация о чате
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.name,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(chat.timestamp),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.accentLight,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                chat.unreadCount.toString(),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return "сейчас";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}м";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}ч";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}д";
    } else {
      return "${time.day}.${time.month}";
    }
  }
}

class ChatPreview {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final String avatar;

  ChatPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.avatar,
  });
}
