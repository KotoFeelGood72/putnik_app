import 'package:flutter/foundation.dart';

class HeroModel {
  String name;
  String race;
  String characterClass;
  String alignment;
  String deity;
  String homeland;
  String gender;
  String age;
  String height;
  String weight;
  String hair;
  String eyes;
  String level;
  String size;

  // Характеристики
  int strength;
  int dexterity;
  int constitution;
  int intelligence;
  int wisdom;
  int charisma;
  int endurance;

  // Временные характеристики (может быть null)
  int? tempStrength;
  int? tempDexterity;
  int? tempConstitution;
  int? tempIntelligence;
  int? tempWisdom;
  int? tempCharisma;

  // Модификаторы испытаний
  int? tempFortitude;
  int? tempReflex;
  int? tempWill;
  int? miscFortitude;
  int? miscReflex;
  int? miscWill;
  int? magicFortitude;
  int? magicReflex;
  int? magicWill;

  // Скорость движения
  int? baseSpeed;
  int? armorSpeed;
  int? flySpeed;
  int? swimSpeed;
  int? climbSpeed;
  int? burrowSpeed;

  // Защита
  int? armorBonus;
  int? shieldBonus;
  int? naturalArmor;
  int? deflectionBonus;
  int? miscACBonus;
  int? sizeModifier;

  // Устойчивость к магии
  int? spellResistance;

  // Атака
  int? baseAttackBonus;
  int? combatManeuverBonus;
  int? combatManeuverDefense;

  // Оружие
  List<Map<String, dynamic>> weapons;

  // Инициатива
  int? miscInitiativeBonus;

  // Навыки (ключ - название, значение - уровень/модификатор)
  Map<String, int> skills;

  // Детальная информация о навыках
  List<SkillModel> skillDetails;

  // Языки
  List<String> languages;

  HeroModel({
    required this.name,
    required this.race,
    required this.characterClass,
    required this.alignment,
    required this.deity,
    required this.homeland,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.hair,
    required this.eyes,
    required this.level,
    required this.size,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.endurance,
    this.tempStrength,
    this.tempDexterity,
    this.tempConstitution,
    this.tempIntelligence,
    this.tempWisdom,
    this.tempCharisma,
    this.tempFortitude,
    this.tempReflex,
    this.tempWill,
    this.miscFortitude,
    this.miscReflex,
    this.miscWill,
    this.magicFortitude,
    this.magicReflex,
    this.magicWill,
    this.baseSpeed,
    this.armorSpeed,
    this.flySpeed,
    this.swimSpeed,
    this.climbSpeed,
    this.burrowSpeed,
    this.armorBonus,
    this.shieldBonus,
    this.naturalArmor,
    this.deflectionBonus,
    this.miscACBonus,
    this.sizeModifier,
    this.spellResistance,
    this.miscInitiativeBonus,
    required this.skills,
    required this.weapons,
    required this.languages,
    required this.skillDetails,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'race': race,
    'characterClass': characterClass,
    'alignment': alignment,
    'deity': deity,
    'homeland': homeland,
    'gender': gender,
    'age': age,
    'height': height,
    'weight': weight,
    'hair': hair,
    'eyes': eyes,
    'level': level,
    'size': size,
    'strength': strength,
    'dexterity': dexterity,
    'constitution': constitution,
    'intelligence': intelligence,
    'wisdom': wisdom,
    'charisma': charisma,
    'endurance': endurance,
    'tempStrength': tempStrength,
    'tempDexterity': tempDexterity,
    'tempConstitution': tempConstitution,
    'tempIntelligence': tempIntelligence,
    'tempWisdom': tempWisdom,
    'tempCharisma': tempCharisma,
    'tempFortitude': tempFortitude,
    'tempReflex': tempReflex,
    'tempWill': tempWill,
    'miscFortitude': miscFortitude,
    'miscReflex': miscReflex,
    'miscWill': miscWill,
    'magicFortitude': magicFortitude,
    'magicReflex': magicReflex,
    'magicWill': magicWill,
    'baseSpeed': baseSpeed,
    'armorSpeed': armorSpeed,
    'flySpeed': flySpeed,
    'swimSpeed': swimSpeed,
    'climbSpeed': climbSpeed,
    'burrowSpeed': burrowSpeed,
    'armorBonus': armorBonus,
    'shieldBonus': shieldBonus,
    'naturalArmor': naturalArmor,
    'deflectionBonus': deflectionBonus,
    'miscACBonus': miscACBonus,
    'sizeModifier': sizeModifier,
    'spellResistance': spellResistance,
    'miscInitiativeBonus': miscInitiativeBonus,
    'skills': skills,
    'weapons': weapons,
    'languages': languages,
    'skillDetails': skillDetails.map((s) => s.toJson()).toList(),
  };

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    // Создаем список навыков по умолчанию, если skillDetails отсутствует
    List<SkillModel> defaultSkillDetails = [
      SkillModel(
        name: 'Акробатика',
        ability: 'ЛВК',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Блеф',
        ability: 'ХАР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Верховая езда',
        ability: 'ЛВК',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Внимание',
        ability: 'МДР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Выживание',
        ability: 'МДР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Дипломатия',
        ability: 'ХАР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Дрессировка',
        ability: 'ХАР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Запугивание',
        ability: 'ХАР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (Высший свет)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (География)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (Инженерное дело)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (История)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (Краеведение)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (Магия)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (Планы)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (Подземелья)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (Природа)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Знание (Религия)',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Изворотливость',
        ability: 'ЛВК',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Исполнение',
        ability: 'ХАР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: true,
      ),
      SkillModel(
        name: 'Использование магических устройств',
        ability: 'ХАР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Колдовство',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Лазание',
        ability: 'СИЛ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Лечение',
        ability: 'МДР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Ловкость рук',
        ability: 'ЛВК',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Маскировка',
        ability: 'ХАР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Механика',
        ability: 'ЛВК',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Оценка',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Плавание',
        ability: 'СИЛ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Полет',
        ability: 'ЛВК',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Проницательность',
        ability: 'МДР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Профессия',
        ability: 'МДР',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: true,
      ),
      SkillModel(
        name: 'Ремесло',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: true,
      ),
      SkillModel(
        name: 'Скрытность',
        ability: 'ЛВК',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: false,
        isCustomizable: false,
      ),
      SkillModel(
        name: 'Языкознание',
        ability: 'ИНТ',
        points: 0,
        miscModifier: 0,
        isClassSkill: false,
        isRequired: true,
        isCustomizable: false,
      ),
    ];

    return HeroModel(
      name: json['name'] ?? '',
      race: json['race'] ?? '',
      characterClass: json['characterClass'] ?? '',
      alignment: json['alignment'] ?? '',
      deity: json['deity'] ?? '',
      homeland: json['homeland'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      hair: json['hair'] ?? '',
      eyes: json['eyes'] ?? '',
      level: json['level'] ?? '',
      size: json['size'] ?? '',
      strength: json['strength'] ?? 0,
      dexterity: json['dexterity'] ?? 0,
      constitution: json['constitution'] ?? 0,
      intelligence: json['intelligence'] ?? 0,
      wisdom: json['wisdom'] ?? 0,
      charisma: json['charisma'] ?? 0,
      endurance: json['endurance'] ?? 0,
      tempStrength: json['tempStrength'],
      tempDexterity: json['tempDexterity'],
      tempConstitution: json['tempConstitution'],
      tempIntelligence: json['tempIntelligence'],
      tempWisdom: json['tempWisdom'],
      tempCharisma: json['tempCharisma'],
      tempFortitude: json['tempFortitude'],
      tempReflex: json['tempReflex'],
      tempWill: json['tempWill'],
      miscFortitude: json['miscFortitude'],
      miscReflex: json['miscReflex'],
      miscWill: json['miscWill'],
      magicFortitude: json['magicFortitude'],
      magicReflex: json['magicReflex'],
      magicWill: json['magicWill'],
      baseSpeed: json['baseSpeed'],
      armorSpeed: json['armorSpeed'],
      flySpeed: json['flySpeed'],
      swimSpeed: json['swimSpeed'],
      climbSpeed: json['climbSpeed'],
      burrowSpeed: json['burrowSpeed'],
      armorBonus: json['armorBonus'],
      shieldBonus: json['shieldBonus'],
      naturalArmor: json['naturalArmor'],
      deflectionBonus: json['deflectionBonus'],
      miscACBonus: json['miscACBonus'],
      sizeModifier: json['sizeModifier'],
      spellResistance: json['spellResistance'],
      miscInitiativeBonus: json['miscInitiativeBonus'],
      skills: Map<String, int>.from(json['skills'] ?? {}),
      weapons: List<Map<String, dynamic>>.from(
        (json['weapons'] ?? []).map((w) => Map<String, dynamic>.from(w)),
      ),
      languages: List<String>.from(json['languages'] ?? []),
      skillDetails: json['skillDetails'] != null
          ? (json['skillDetails'] as List)
              .map((s) => SkillModel.fromJson(s))
              .toList()
          : defaultSkillDetails,
    );
  }
}

class SkillModel {
  String name;
  String ability; // Характеристика (ЛВК, СИЛ, ИНТ, МДР, ХАР)
  int points; // Пункты навыка
  int miscModifier; // Прочие модификаторы
  bool isClassSkill; // Классовый навык
  bool isRequired; // Обязательный навык (со звездочкой)
  bool isCustomizable; // Можно вписывать свое название

  SkillModel({
    required this.name,
    required this.ability,
    required this.points,
    required this.miscModifier,
    required this.isClassSkill,
    required this.isRequired,
    required this.isCustomizable,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'ability': ability,
    'points': points,
    'miscModifier': miscModifier,
    'isClassSkill': isClassSkill,
    'isRequired': isRequired,
    'isCustomizable': isCustomizable,
  };

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
    name: json['name'] ?? '',
    ability: json['ability'] ?? '',
    points: json['points'] ?? 0,
    miscModifier: json['miscModifier'] ?? 0,
    isClassSkill: json['isClassSkill'] ?? false,
    isRequired: json['isRequired'] ?? false,
    isCustomizable: json['isCustomizable'] ?? false,
  );
}
