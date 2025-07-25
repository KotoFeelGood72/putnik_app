import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import '../../../../models/skill_data.dart';

class SkillsTab extends StatelessWidget {
  final List<SkillData> skills;
  final String heroClass; // Добавляем класс героя
  final Function(SkillData, int) onShowSkillEditModal;
  final VoidCallback onShowAddCustomSkillModal;
  final Function(int) onToggleClassSkill;

  const SkillsTab({
    super.key,
    required this.skills,
    required this.heroClass,
    required this.onShowSkillEditModal,
    required this.onShowAddCustomSkillModal,
    required this.onToggleClassSkill,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Заголовок секции
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 100,
              children: [
                const Text(
                  'Навыки',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Btn(
                    text: 'Добавить',
                    onPressed: onShowAddCustomSkillModal,
                    buttonSize: 50,
                    textSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Список навыков
          ...skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            return _buildSkillRow(skill, index);
          }),
        ],
      ),
    );
  }

  Widget _buildSkillRow(SkillData skill, int index) {
    final bool isDisabled = !skill.isAvailable;

    return GestureDetector(
      onTap: isDisabled ? null : () => onShowSkillEditModal(skill, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFF1A1A1A) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border:
              isDisabled
                  ? Border.all(color: Colors.grey[600]!, width: 1)
                  : null,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.name,
                    style: TextStyle(
                      color: isDisabled ? Colors.grey[600] : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${skill.ability} ${skill.modifier >= 0 ? '+' : ''}${skill.modifier}',
                    style: TextStyle(
                      color: isDisabled ? Colors.grey[500] : Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  if (isDisabled)
                    Text(
                      'Требует изучения',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else if (skill.isClassSkill)
                    Text(
                      'Классовый навык',
                      style: TextStyle(
                        color: const Color(0xFF5B2333),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                isDisabled
                    ? '-'
                    : '${skill.total >= 0 ? '+' : ''}${skill.total}',
                style: TextStyle(
                  color: isDisabled ? Colors.grey[600] : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (skill.requiresStudy && skill.isAvailable)
              GestureDetector(
                onTap: () => onToggleClassSkill(index),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                        skill.isClassSkill
                            ? const Color(0xFF5B2333)
                            : Colors.transparent,
                    border: Border.all(
                      color:
                          skill.isClassSkill
                              ? const Color(0xFF5B2333)
                              : Colors.grey[600]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                      skill.isClassSkill
                          ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                          : null,
                ),
              ),
            const SizedBox(width: 8),
            if (skill.isAvailable)
              GestureDetector(
                onTap: () => onShowSkillEditModal(skill, index),
                child: const Icon(Icons.edit, color: Colors.grey, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
