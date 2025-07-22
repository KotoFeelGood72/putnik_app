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

  int get total => modifier + points + bonus;
}
