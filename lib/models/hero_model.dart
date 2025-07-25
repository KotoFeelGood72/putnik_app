import 'package:flutter/foundation.dart';

class HeroModel {
  String? id;
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

  // HP
  int maxHp;
  int currentHp;

  // Архетип
  String? archetype;

  // Фото
  String? photoPath;

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

  // Черты
  List<Map<String, dynamic>> feats;

  HeroModel({
    this.id,
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
    required this.maxHp,
    required this.currentHp,
    this.archetype,
    this.photoPath,
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
    required this.feats,
  });

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
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
    'maxHp': maxHp,
    'currentHp': currentHp,
    'archetype': archetype,
    'photoPath': photoPath,
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
    'feats': feats,
  };

  factory HeroModel.fromJson(Map<String, dynamic> json, {String? id}) {
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
      id: id,
      name: json['name'] as String,
      race: json['race'] as String,
      characterClass: json['characterClass'] as String,
      alignment: json['alignment'] as String,
      deity: json['deity'] as String,
      homeland: json['homeland'] as String,
      gender: json['gender'] as String,
      age: json['age'] as String,
      height: json['height'] as String,
      weight: json['weight'] as String,
      hair: json['hair'] as String,
      eyes: json['eyes'] as String,
      level: json['level'] as String,
      size: json['size'] as String,
      strength: json['strength'] as int,
      dexterity: json['dexterity'] as int,
      constitution: json['constitution'] as int,
      intelligence: json['intelligence'] as int,
      wisdom: json['wisdom'] as int,
      charisma: json['charisma'] as int,
      endurance: json['endurance'] as int,
      maxHp: json['maxHp'] as int? ?? 100,
      currentHp: json['currentHp'] as int? ?? 100,
      archetype: json['archetype'] as String?,
      photoPath: json['photoPath'] as String?,
      tempStrength: json['tempStrength'] as int?,
      tempDexterity: json['tempDexterity'] as int?,
      tempConstitution: json['tempConstitution'] as int?,
      tempIntelligence: json['tempIntelligence'] as int?,
      tempWisdom: json['tempWisdom'] as int?,
      tempCharisma: json['tempCharisma'] as int?,
      tempFortitude: json['tempFortitude'] as int?,
      tempReflex: json['tempReflex'] as int?,
      tempWill: json['tempWill'] as int?,
      miscFortitude: json['miscFortitude'] as int?,
      miscReflex: json['miscReflex'] as int?,
      miscWill: json['miscWill'] as int?,
      magicFortitude: json['magicFortitude'] as int?,
      magicReflex: json['magicReflex'] as int?,
      magicWill: json['magicWill'] as int?,
      baseSpeed: json['baseSpeed'] as int?,
      armorSpeed: json['armorSpeed'] as int?,
      flySpeed: json['flySpeed'] as int?,
      swimSpeed: json['swimSpeed'] as int?,
      climbSpeed: json['climbSpeed'] as int?,
      burrowSpeed: json['burrowSpeed'] as int?,
      armorBonus: json['armorBonus'] as int?,
      shieldBonus: json['shieldBonus'] as int?,
      naturalArmor: json['naturalArmor'] as int?,
      deflectionBonus: json['deflectionBonus'] as int?,
      miscACBonus: json['miscACBonus'] as int?,
      sizeModifier: json['sizeModifier'] as int?,
      spellResistance: json['spellResistance'] as int?,
      miscInitiativeBonus: json['miscInitiativeBonus'] as int?,
      skills: Map<String, int>.from(json['skills'] as Map),
      weapons: List<Map<String, dynamic>>.from(json['weapons'] as List),
      languages: List<String>.from(json['languages'] as List),
      skillDetails:
          (json['skillDetails'] as List<dynamic>?)
              ?.map((s) => SkillModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          defaultSkillDetails,
      feats: List<Map<String, dynamic>>.from(json['feats'] as List? ?? []),
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
