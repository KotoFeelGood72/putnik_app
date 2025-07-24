import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../models/hero_model.dart';
import '../../theme/app_colors.dart';
import '../../screens/hero/hero_detail_screen.dart';

class HeroCard extends StatefulWidget {
  final HeroModel hero;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HeroCard({
    Key? key,
    required this.hero,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (widget.onEdit != null)
            SlidableAction(
              onPressed: (_) => widget.onEdit!(),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Изменить',
            ),
          if (widget.onDelete != null)
            SlidableAction(
              onPressed: (_) => widget.onDelete!(),
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Удалить',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
        ],
      ),
      child: Builder(
        builder: (context) {
          final animation = Slidable.of(context)?.animation;
          return (animation != null)
              ? AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final isOpen = animation.value > 0.01;
                  return _buildCardContent(isOpen);
                },
              )
              : _buildCardContent(false);
        },
      ),
    );
  }

  Widget _buildCardContent(bool isOpen) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            bottomLeft: const Radius.circular(16),
            topRight: Radius.circular(isOpen ? 0 : 16),
            bottomRight: Radius.circular(isOpen ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child:
                          widget.hero.photoPath != null &&
                                  widget.hero.photoPath!.isNotEmpty
                              ? (widget.hero.photoPath!.startsWith('http')
                                  ? Image.network(
                                    widget.hero.photoPath!,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                          child: Text(
                                            widget.hero.name.isNotEmpty
                                                ? widget.hero.name[0]
                                                    .toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                  )
                                  : Image.file(
                                    File(widget.hero.photoPath!),
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                          child: Text(
                                            widget.hero.name.isNotEmpty
                                                ? widget.hero.name[0]
                                                    .toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                  ))
                              : Center(
                                child: Text(
                                  widget.hero.name.isNotEmpty
                                      ? widget.hero.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hero.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.hero.race,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                widget.hero.characterClass,
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                'Ур. ${widget.hero.level}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatItem('Сил', widget.hero.strength)),
                  Expanded(child: _buildStatItem('Лов', widget.hero.dexterity)),
                  Expanded(
                    child: _buildStatItem('Вын', widget.hero.constitution),
                  ),
                  Expanded(
                    child: _buildStatItem('Инт', widget.hero.intelligence),
                  ),
                  Expanded(child: _buildStatItem('Мдр', widget.hero.wisdom)),
                  Expanded(child: _buildStatItem('Хар', widget.hero.charisma)),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
