import 'hero_model.dart';

class SkillData {
  final String name;
  final String ability;
  final HeroModel hero;
  final bool isClassSkill;
  final bool requiresStudy;
  final bool isSelected;
  final int points;
  final int bonus;
  final String skillValue;
  final bool isAvailable; // Доступен ли навык для изучения

  SkillData({
    required this.name,
    required this.ability,
    required this.hero,
    this.isClassSkill = false,
    this.requiresStudy = false,
    this.isSelected = false,
    this.points = 0,
    this.bonus = 0,
    this.skillValue = '',
    this.isAvailable = true,
  });

  SkillData copyWith({
    String? name,
    String? ability,
    HeroModel? hero,
    bool? isClassSkill,
    bool? requiresStudy,
    bool? isSelected,
    int? points,
    int? bonus,
    String? skillValue,
    bool? isAvailable,
  }) {
    return SkillData(
      name: name ?? this.name,
      ability: ability ?? this.ability,
      hero: hero ?? this.hero,
      isClassSkill: isClassSkill ?? this.isClassSkill,
      requiresStudy: requiresStudy ?? this.requiresStudy,
      isSelected: isSelected ?? this.isSelected,
      points: points ?? this.points,
      bonus: bonus ?? this.bonus,
      skillValue: skillValue ?? this.skillValue,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  int _calculateModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  int get modifier {
    switch (ability) {
      case 'СИЛ':
        return _calculateModifier(hero.strength);
      case 'ЛВК':
        return _calculateModifier(hero.dexterity);
      case 'ВЫН':
        return _calculateModifier(hero.constitution);
      case 'ИНТ':
        return _calculateModifier(hero.intelligence);
      case 'МДР':
        return _calculateModifier(hero.wisdom);
      case 'ХАР':
        return _calculateModifier(hero.charisma);
      default:
        return 0;
    }
  }

  int get total {
    int total = modifier + points + bonus;

    // Если навык классовый и в нем есть хотя бы 1 пункт, добавляем +3
    if (isClassSkill && points > 0) {
      total += 3;
    }

    return total;
  }
}
