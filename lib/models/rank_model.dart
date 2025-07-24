class RankLevel {
  final int level;
  final String name;
  final int requiredXp; // XP для перехода на этот уровень
  final int totalXp; // Общий XP для достижения этого уровня

  const RankLevel({
    required this.level,
    required this.name,
    required this.requiredXp,
    required this.totalXp,
  });
}

const List<RankLevel> rankLevels = [
  RankLevel(level: 1, name: 'Новобранец', requiredXp: 0, totalXp: 0),
  RankLevel(level: 2, name: 'Ученик Пути', requiredXp: 2000, totalXp: 2000),
  RankLevel(level: 3, name: 'Путник', requiredXp: 3000, totalXp: 5000),
  RankLevel(level: 4, name: 'Скаут', requiredXp: 4000, totalXp: 9000),
  RankLevel(
    level: 5,
    name: 'Боевой искатель',
    requiredXp: 6000,
    totalXp: 15000,
  ),
  RankLevel(
    level: 6,
    name: 'Хранитель тропы',
    requiredXp: 9000,
    totalXp: 24000,
  ),
  RankLevel(
    level: 7,
    name: 'Охотник за древностями',
    requiredXp: 13000,
    totalXp: 37000,
  ),
  RankLevel(level: 8, name: 'Призванный', requiredXp: 19000, totalXp: 56000),
  RankLevel(level: 9, name: 'Герой легенды', requiredXp: 27000, totalXp: 83000),
  RankLevel(level: 10, name: 'Мастер Пути', requiredXp: 38000, totalXp: 121000),
  RankLevel(
    level: 11,
    name: 'Закалённый в битвах',
    requiredXp: 51000,
    totalXp: 172000,
  ),
  RankLevel(level: 12, name: 'Архипутник', requiredXp: 66000, totalXp: 238000),
  RankLevel(
    level: 13,
    name: 'Зовущий за грань',
    requiredXp: 83000,
    totalXp: 321000,
  ),
  RankLevel(
    level: 14,
    name: 'Хранитель реликвий',
    requiredXp: 102000,
    totalXp: 423000,
  ),
  RankLevel(
    level: 15,
    name: 'Призрак троп',
    requiredXp: 123000,
    totalXp: 546000,
  ),
  RankLevel(
    level: 16,
    name: 'Хронист эпох',
    requiredXp: 147000,
    totalXp: 693000,
  ),
  RankLevel(
    level: 17,
    name: 'Вестник Силы',
    requiredXp: 173000,
    totalXp: 866000,
  ),
  RankLevel(
    level: 18,
    name: 'Проводник миров',
    requiredXp: 201000,
    totalXp: 1067000,
  ),
  RankLevel(
    level: 19,
    name: 'Архимаг / Верховный рыцарь',
    requiredXp: 231000,
    totalXp: 1298000,
  ),
  RankLevel(
    level: 20,
    name: 'Легенда Пути',
    requiredXp: 263000,
    totalXp: 1561000,
  ),
];
