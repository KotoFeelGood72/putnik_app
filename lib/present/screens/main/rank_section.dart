import 'package:flutter/material.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/models/user_model.dart';

class RankSection extends StatelessWidget {
  final UserModel user;
  const RankSection({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rank = user.currentRankLevel;
    final nextRank = user.nextRankLevel;
    final progress = user.rankProgress;
    final progressPercent = ((progress * 100).clamp(0, 100)).toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surface,
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
              Text(
                'Уровень ${rank.level}: ${rank.name}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nextRank != null
                    ? 'До следующего: ${nextRank.name} (${nextRank.requiredXp} XP)'
                    : 'Максимальный уровень',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 14,
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
              widthFactor: progress,
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
    );
  }
}
