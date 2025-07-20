import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../models/hero_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

@RoutePage()
class CreateHeroScreen extends StatefulWidget {
  final HeroModel? hero; // Optional hero for editing

  const CreateHeroScreen({super.key, this.hero});

  @override
  State<CreateHeroScreen> createState() => _CreateHeroScreenState();
}

class _CreateHeroScreenState extends State<CreateHeroScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // === БАЗОВАЯ ИНФОРМАЦИЯ ===
  String name = '';
  String race = '';
  String characterClass = '';
  String alignment = '';
  String deity = '';
  String homeland = '';
  String gender = '';
  int age = 18;
  int level = 1;
  String size = '';
  String height = '';
  String weight = '';
  String hair = '';
  String eyes = '';
  int experience = 0;

  // === ХАРАКТЕРИСТИКИ ===
  int strength = 10;
  int dexterity = 10;
  int constitution = 10;
  int intelligence = 10;
  int wisdom = 10;
  int charisma = 10;

  // === ИНИЦИАТИВА И ПЕРЕДВИЖЕНИЕ ===
  int initiative = 0;
  int initiativeDex = 0;
  int initiativeOther = 0;
  int speed = 30;
  int speedConditional = 30;

  // === ЗАЩИТА И ЗДОРОВЬЕ ===
  int armorClass = 10;
  int armorClassBase = 10;
  int armorClassDex = 0;
  int armorClassArmor = 0;
  int armorClassShield = 0;
  int armorClassSize = 0;
  int armorClassNatural = 0;
  int armorClassDodge = 0;
  int armorClassOther = 0;

  int fortitude = 0;
  int reflex = 0;
  int will = 0;
  int fortitudeBonus = 0;
  int reflexBonus = 0;
  int willBonus = 0;
  int fortitudeSpells = 0;
  int reflexSpells = 0;
  int willSpells = 0;
  int fortitudeItems = 0;
  int reflexItems = 0;
  int willItems = 0;
  int fortitudeOther = 0;
  int reflexOther = 0;
  int willOther = 0;

  int maxHitPoints = 0;
  int currentHitPoints = 0;
  int damage = 0;
  bool isUnconscious = false;
  int constitutionBonus = 0;

  // === АТАКИ ===
  int baseAttackBonus = 0;
  int meleeAttackBonus = 0;
  int rangedAttackBonus = 0;
  List<Map<String, dynamic>> weapons = [];
  List<Map<String, dynamic>> armor = [];

  // === НАВЫКИ ===
  Map<String, int> skills = {};
  List<String> languages = [];

  // === СНАРЯЖЕНИЕ ===
  int gold = 0;
  int silver = 0;
  int copper = 0;
  List<Map<String, dynamic>> inventory = [];
  int totalWeight = 0;
  int maxWeight = 0;

  // === СПОСОБНОСТИ И ЗАКЛИНАНИЯ ===
  List<String> specialAbilities = [];
  List<Map<String, dynamic>> spells = [];
  String classAbilities = '';
  String racialAbilities = '';
  String additionalAbilities = '';

  // === ЗАМЕТКИ ===
  String characterHistory = '';
  String notes = '';
  String contacts = '';
  String quests = '';

  // --- Pathfinder lists ---
  final List<String> races = [
    'Человек',
    'Эльф',
    'Дварф',
    'Гном',
    'Полурослик',
    'Полуорк',
    'Полуэльф',
    'Тифлинг',
    'Аасимар',
  ];
  final List<String> classes = [
    'Воин',
    'Маг',
    'Плут',
    'Клирик',
    'Паладин',
    'Варвар',
    'Следопыт',
    'Бард',
    'Друид',
    'Монах',
    'Колдун',
    'Ведьма',
    'Инквизитор',
    'Алхимик',
    'Оракул',
    'Самурай',
    'Ниндзя',
    'Пистолетчик',
  ];
  final List<String> alignments = [
    'Законопослушный добрый',
    'Нейтральный добрый',
    'Хаотичный добрый',
    'Законопослушный нейтральный',
    'Истинно нейтральный',
    'Хаотичный нейтральный',
    'Законопослушный злой',
    'Нейтральный злой',
    'Хаотичный злой',
  ];
  final List<String> deities = [
    'Абадар',
    'Асмодей',
    'Калистрия',
    'Кейден Кайлен',
    'Десна',
    'Эрастил',
    'Гозрех',
    'Горуум',
    'Иомедэ',
    'Ирори',
    'Ламашту',
    'Нэтис',
    'Норгорбер',
    'Фаразма',
    'Ровагуг',
    'Саренрей',
    'Шелин',
    'Тораг',
    'Ургатой',
    'Зон-Кутон',
  ];
  final List<String> genders = ['Мужской', 'Женский', 'Другое'];
  final List<String> sizes = [
    'Крошечный',
    'Малый',
    'Средний',
    'Крупный',
    'Огромный',
    'Гигантский',
  ];

  // --- Pathfinder skills ---
  final List<String> skillsList = [
    'Акробатика',
    'Блеф',
    'Верховая езда',
    'Внимание',
    'Выживание',
    'Дипломатия',
    'Дрессировка',
    'Запугивание',
    'Исполнение',
    'Использование магических устройств',
    'Колдовство',
    'Лазание',
    'Лечение',
    'Ловкость рук',
    'Маскировка',
    'Механика',
    'Оценка',
    'Плавание',
    'Полет',
    'Проницательность',
    'Профессия',
    'Ремесло',
    'Скрытность',
    'Языкознание',
    'Знание (высший свет)',
    'Знание (география)',
    'Знание (инженерное дело)',
    'Знание (история)',
    'Знание (локальный)',
    'Знание (магия)',
    'Знание (планы)',
    'Знание (подземелья)',
    'Знание (природа)',
    'Знание (религии)',
    'Выносливость',
  ];

  final List<String> tabTitles = [
    'Основное',
    'Защита',
    'Атака',
    'Навыки',
    'Инвентарь',
    'Умения',
    'Прочее',
  ];

  // Инициализация значений навыков
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
    for (final skill in skillsList) {
      skills[skill] = 0;
    }

    // Если передан герой для редактирования, заполняем форму его данными
    if (widget.hero != null) {
      _populateFormWithHero(widget.hero!);
    }
  }

  void _populateFormWithHero(HeroModel hero) {
    setState(() {
      name = hero.name;
      race = races.contains(hero.race) ? hero.race : races.first;
      characterClass =
          classes.contains(hero.characterClass)
              ? hero.characterClass
              : classes.first;
      // Проверяем, есть ли значение в списке, если нет - используем первое
      alignment =
          alignments.contains(hero.alignment)
              ? hero.alignment
              : alignments.first;
      deity = deities.contains(hero.deity) ? hero.deity : deities.first;
      homeland = hero.homeland;
      gender = genders.contains(hero.gender) ? hero.gender : genders.first;
      age = int.tryParse(hero.age) ?? 18;
      level = int.tryParse(hero.level) ?? 1;
      size = sizes.contains(hero.size) ? hero.size : sizes.first;
      height = hero.height;
      weight = hero.weight;
      hair = hero.hair;
      eyes = hero.eyes;

      // Характеристики
      strength = hero.strength;
      dexterity = hero.dexterity;
      constitution = hero.constitution;
      intelligence = hero.intelligence;
      wisdom = hero.wisdom;
      charisma = hero.charisma;

      // Навыки - фильтруем только те, которые есть в списке
      skills = Map.fromEntries(
        hero.skills.entries.where((entry) => skillsList.contains(entry.key)),
      );

      // Оружие
      weapons = hero.weapons.cast<Map<String, dynamic>>();

      // Языки
      languages = List<String>.from(hero.languages);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveHero() async {
    final hero = HeroModel(
      name: name,
      race: race,
      characterClass: characterClass,
      alignment: alignment,
      deity: deity,
      homeland: homeland,
      gender: gender,
      age: age.toString(),
      height: height,
      weight: weight,
      hair: hair,
      eyes: eyes,
      level: level.toString(),
      size: size,
      strength: strength,
      dexterity: dexterity,
      constitution: constitution,
      intelligence: intelligence,
      wisdom: wisdom,
      charisma: charisma,
      endurance: constitution, // для совместимости
      skills: skills,
      weapons: weapons.cast<Map<String, String>>(),
      languages: languages,
      skillDetails: _getDefaultSkills(),
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (widget.hero != null) {
      // Обновляем существующего героя
      // Находим документ по данным героя
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('heroes')
              .where('name', isEqualTo: widget.hero!.name)
              .where('race', isEqualTo: widget.hero!.race)
              .where('characterClass', isEqualTo: widget.hero!.characterClass)
              .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update(hero.toJson());
      }
    } else {
      // Создаем нового героя
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('heroes')
          .add(hero.toJson());
    }

    if (mounted) {
      // Возвращаем обновленного героя
      Navigator.pop(context, hero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          widget.hero != null
              ? 'Редактирование персонажа'
              : 'Создание персонажа',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _saveHero();
              }
            },
            child: const Text(
              'Сохранить',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                indicator: BoxDecoration(
                  color: const Color(0xFF5B2333),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,

                tabs: const [
                  Tab(text: 'Основное'),
                  Tab(text: 'Защита'),
                  Tab(text: 'Атака'),
                  Tab(text: 'Навыки'),
                  Tab(text: 'Инвентарь'),
                  Tab(text: 'Способности'),
                  Tab(text: 'Заметки'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(),
                  _buildDefenseTab(),
                  _buildAttackTab(),
                  _buildSkillsTab(),
                  _buildInventoryTab(),
                  _buildAbilitiesTab(),
                  _buildNotesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === ОСНОВНАЯ ИНФОРМАЦИЯ ===
  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Идентификация
          _buildEditableInfoCard(
            'Имя персонажа',
            name,
            (v) => setState(() => name = v),
          ),
          const SizedBox(height: 12),

          // Класс и уровень
          Row(
            children: [
              Expanded(
                child: _buildDropdownCard(
                  'Класс',
                  characterClass,
                  classes,
                  (v) => setState(() => characterClass = v ?? ''),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberCard(
                  'Уровень',
                  level,
                  (v) => setState(() => level = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Раса и размер
          Row(
            children: [
              Expanded(
                child: _buildDropdownCard(
                  'Раса',
                  race,
                  races,
                  (v) => setState(() => race = v ?? ''),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownCard(
                  'Размер',
                  size,
                  sizes,
                  (v) => setState(() => size = v ?? ''),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Мировоззрение и божество
          _buildDropdownCard(
            'Мировоззрение',
            alignment,
            alignments,
            (v) => setState(() => alignment = v ?? ''),
          ),
          const SizedBox(height: 12),
          _buildDropdownCard(
            'Божество',
            deity,
            deities,
            (v) => setState(() => deity = v ?? ''),
          ),
          const SizedBox(height: 16),

          // Опыт
          _buildNumberCard(
            'Опыт',
            experience,
            (v) => setState(() => experience = v),
          ),
          const SizedBox(height: 20),

          // Характеристики
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'СИЛА',
                  strength.toString(),
                  (v) => setState(() => strength = int.tryParse(v) ?? 10),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'ЛОВКОСТЬ',
                  dexterity.toString(),
                  (v) => setState(() => dexterity = int.tryParse(v) ?? 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'ТЕЛОСЛОЖЕНИЕ',
                  constitution.toString(),
                  (v) => setState(() => constitution = int.tryParse(v) ?? 10),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'ИНТЕЛЛЕКТ',
                  intelligence.toString(),
                  (v) => setState(() => intelligence = int.tryParse(v) ?? 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'МУДРОСТЬ',
                  wisdom.toString(),
                  (v) => setState(() => wisdom = int.tryParse(v) ?? 10),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'ХАРИЗМА',
                  charisma.toString(),
                  (v) => setState(() => charisma = int.tryParse(v) ?? 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Инициатива и скорость
          _buildNumberCard(
            'Инициатива',
            initiative,
            (v) => setState(() => initiative = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard('Скорость', speed, (v) => setState(() => speed = v)),
        ],
      ),
    );
  }

  // === ЗАЩИТА И ЗДОРОВЬЕ ===
  Widget _buildDefenseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Класс брони и здоровье
          _buildNumberCard(
            'Класс брони',
            armorClassBase,
            (v) => setState(() => armorClassBase = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Макс. очки жизни',
            maxHitPoints,
            (v) => setState(() => maxHitPoints = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Текущие очки жизни',
            currentHitPoints,
            (v) => setState(() => currentHitPoints = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Стойкость',
            fortitude,
            (v) => setState(() => fortitude = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Рефлекс',
            reflex,
            (v) => setState(() => reflex = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard('Воля', will, (v) => setState(() => will = v)),
        ],
      ),
    );
  }

  // === АТАКИ ===
  Widget _buildAttackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Базовая атака
          _buildNumberCard(
            'Базовый бонус атаки',
            baseAttackBonus,
            (v) => setState(() => baseAttackBonus = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Бонус ближней атаки',
            meleeAttackBonus,
            (v) => setState(() => meleeAttackBonus = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Бонус дальней атаки',
            rangedAttackBonus,
            (v) => setState(() => rangedAttackBonus = v),
          ),
          const SizedBox(height: 20),

          // Оружие
          if (weapons.isNotEmpty)
            ...weapons.map(
              (weapon) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  weapon['name'] ?? 'Оружие',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // === НАВЫКИ ===
  Widget _buildSkillsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkillItem('АКРОБАТИКА', dexterity),
          _buildSkillItem('БЛЕФ', charisma),
          _buildSkillItem('ВЕРХОВАЯ ЕЗДА', dexterity),
          _buildSkillItem('ВНИМАНИЕ', wisdom),
          _buildSkillItem('ВЫЖИВАНИЕ', wisdom),
          _buildSkillItem('ДИПЛОМАТИЯ', charisma),
          _buildSkillItem('ДРЕССИРОВКА', charisma),
          _buildSkillItem('ЗАПУГИВАНИЕ', charisma),
          _buildSkillItem('ЗНАНИЕ (ВЫСШИЙ СВЕТ)', intelligence),
          _buildSkillItem('ЗНАНИЕ (ГЕОГРАФИЯ)', intelligence),
          _buildSkillItem('ЗНАНИЕ (ИНЖЕНЕРНОЕ ДЕЛО)', intelligence),
          _buildSkillItem('ЗНАНИЕ (ИСТОРИЯ)', intelligence),
          _buildSkillItem('ЗНАНИЕ (КРАЕВЕДЕНИЕ)', intelligence),
          _buildSkillItem('ЗНАНИЕ (МАГИЯ)', intelligence),
          _buildSkillItem('ЗНАНИЕ (ПЛАНЫ)', intelligence),
          _buildSkillItem('ЗНАНИЕ (ПОДЗЕМЕЛЬЯ)', intelligence),
          _buildSkillItem('ЗНАНИЕ (ПРИРОДА)', intelligence),
          _buildSkillItem('ЗНАНИЕ (РЕЛИГИЯ)', intelligence),
          _buildSkillItem('ИЗВОРОТЛИВОСТЬ', dexterity),
          _buildSkillItem('ИСПОЛНЕНИЕ', charisma),
          _buildSkillItem('ИСПОЛЬЗОВАНИЕ МАГИЧЕСКИХ УСТРОЙСТВ', charisma),
          _buildSkillItem('КОЛДОВСТВО', intelligence),
          _buildSkillItem('ЛАЗАНИЕ', strength),
          _buildSkillItem('ЛЕЧЕНИЕ', wisdom),
          _buildSkillItem('ЛОВКОСТЬ РУК', dexterity),
          _buildSkillItem('МАСКИРОВКА', charisma),
          _buildSkillItem('МЕХАНИКА', dexterity),
          _buildSkillItem('ОЦЕНКА', intelligence),
          _buildSkillItem('ПЛАВАНИЕ', strength),
          _buildSkillItem('ПОЛЕТ', dexterity),
          _buildSkillItem('ПРОНИЦАТЕЛЬНОСТЬ', wisdom),
          _buildSkillItem('ПРОФЕССИЯ', wisdom),
          _buildSkillItem('РЕМЕСЛО', intelligence),
          _buildSkillItem('СКРЫТНОСТЬ', dexterity),
          _buildSkillItem('ЯЗЫКОЗНАНИЕ', intelligence),
        ],
      ),
    );
  }

  // === СНАРЯЖЕНИЕ ===
  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNumberCard('Золото', gold, (v) => setState(() => gold = v)),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Серебро',
            silver,
            (v) => setState(() => silver = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard('Медь', copper, (v) => setState(() => copper = v)),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Общий вес',
            totalWeight,
            (v) => setState(() => totalWeight = v),
          ),
          const SizedBox(height: 12),
          _buildNumberCard(
            'Макс. вес',
            maxWeight,
            (v) => setState(() => maxWeight = v),
          ),
        ],
      ),
    );
  }

  // === СПОСОБНОСТИ И ЗАКЛИНАНИЯ ===
  Widget _buildAbilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableInfoCard(
            'Классовые способности',
            classAbilities,
            (v) => setState(() => classAbilities = v),
          ),
          const SizedBox(height: 12),
          _buildEditableInfoCard(
            'Расовые способности',
            racialAbilities,
            (v) => setState(() => racialAbilities = v),
          ),
          const SizedBox(height: 12),
          _buildEditableInfoCard(
            'Особые способности',
            specialAbilities.join(', '),
            (v) => setState(
              () =>
                  specialAbilities =
                      v.split(', ').where((e) => e.isNotEmpty).toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildEditableInfoCard('Заклинания', '', (v) => setState(() {})),
          const SizedBox(height: 12),
          _buildEditableInfoCard(
            'Дополнительные умения',
            additionalAbilities,
            (v) => setState(() => additionalAbilities = v),
          ),
        ],
      ),
    );
  }

  // === ЗАМЕТКИ ===
  Widget _buildNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableInfoCard(
            'История персонажа',
            characterHistory,
            (v) => setState(() => characterHistory = v),
          ),
          const SizedBox(height: 12),
          _buildEditableInfoCard(
            'Личные заметки',
            notes,
            (v) => setState(() => notes = v),
          ),
          const SizedBox(height: 12),
          _buildEditableInfoCard(
            'Важные контакты',
            contacts,
            (v) => setState(() => contacts = v),
          ),
          const SizedBox(height: 12),
          _buildEditableInfoCard(
            'Активные квесты',
            quests,
            (v) => setState(() => quests = v),
          ),
          const SizedBox(height: 12),
          _buildEditableInfoCard('Достижения', '', (v) => setState(() {})),
        ],
      ),
    );
  }

  // === ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ===
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNumberField(String label, int value, Function(int) onChanged) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      initialValue: value.toString(),
      onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
    );
  }

  Widget _buildStatField(String label, int value, Function(int) onChanged) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      initialValue: value.toString(),
      onChanged: (v) => onChanged(int.tryParse(v) ?? 10),
    );
  }

  // === НОВЫЕ МЕТОДЫ ДЛЯ ДИЗАЙНА ===

  int _calculateModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  int _calculateMaxHP() {
    int heroLevel = this.level;
    int conMod = _calculateModifier(constitution);
    return heroLevel * 6 + conMod * heroLevel;
  }

  int _calculateSaveBonus(int abilityScore) {
    int heroLevel = this.level;
    int abilityMod = _calculateModifier(abilityScore);
    return (heroLevel / 2).floor() + abilityMod;
  }

  Widget _buildInfoCard(
    String label,
    String value, {
    bool isTextField = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isTextField)
            Expanded(
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Введите имя',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSaved: (v) => name = v ?? '',
                validator: (v) => v == null || v.isEmpty ? 'Введите имя' : null,
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditableInfoCard(
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            initialValue: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            initialValue: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value.isNotEmpty ? value : null,
            items:
                items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white),
            dropdownColor: const Color(0xFF2A2A2A),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberCard(String label, int value, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            initialValue: value.toString(),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(int.tryParse(v) ?? value),
          ),
        ],
      ),
    );
  }

  List<SkillModel> _getDefaultSkills() {
    return [
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
  }

  Widget _buildSkillItem(String skillName, int abilityScore) {
    final modifier = _calculateModifier(abilityScore);
    final currentValue = skills[skillName] ?? modifier;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              skillName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                onPressed: () {
                  setState(() {
                    skills[skillName] = (skills[skillName] ?? modifier) - 1;
                  });
                },
              ),
              SizedBox(
                width: 50,
                child: Text(
                  '${skills[skillName] ?? modifier}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                onPressed: () {
                  setState(() {
                    skills[skillName] = (skills[skillName] ?? modifier) + 1;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// === ДИАЛОГИ ===
class _WeaponDialog extends StatefulWidget {
  @override
  State<_WeaponDialog> createState() => _WeaponDialogState();
}

class _WeaponDialogState extends State<_WeaponDialog> {
  final _nameController = TextEditingController();
  final _attackController = TextEditingController();
  final _damageController = TextEditingController();
  final _criticalController = TextEditingController();
  final _rangeController = TextEditingController();
  String _damageType = 'Рубящий';

  final List<String> damageTypes = [
    'Рубящий',
    'Колющий',
    'Дробящий',
    'Огненный',
    'Ледяной',
    'Электрический',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить оружие'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: _attackController,
            decoration: const InputDecoration(labelText: 'Бонус атаки'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _damageController,
            decoration: const InputDecoration(labelText: 'Урон'),
          ),
          TextField(
            controller: _criticalController,
            decoration: const InputDecoration(labelText: 'Крит'),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Тип урона'),
            value: _damageType,
            items:
                damageTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
            onChanged: (v) => setState(() => _damageType = v ?? 'Рубящий'),
          ),
          TextField(
            controller: _rangeController,
            decoration: const InputDecoration(labelText: 'Дальность'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'name': _nameController.text,
              'attack': _attackController.text,
              'damage': _damageController.text,
              'critical': _criticalController.text,
              'damageType': _damageType,
              'range': _rangeController.text,
            });
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}

class _ArmorDialog extends StatefulWidget {
  @override
  State<_ArmorDialog> createState() => _ArmorDialogState();
}

class _ArmorDialogState extends State<_ArmorDialog> {
  final _nameController = TextEditingController();
  final _acController = TextEditingController();
  final _maxDexController = TextEditingController();
  final _checkPenaltyController = TextEditingController();
  final _speedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить доспехи'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: _acController,
            decoration: const InputDecoration(labelText: 'Класс брони'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _maxDexController,
            decoration: const InputDecoration(labelText: 'Макс ловкость'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _checkPenaltyController,
            decoration: const InputDecoration(labelText: 'Штраф к проверкам'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _speedController,
            decoration: const InputDecoration(labelText: 'Скорость'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'name': _nameController.text,
              'ac': _acController.text,
              'maxDex': _maxDexController.text,
              'checkPenalty': _checkPenaltyController.text,
              'speed': _speedController.text,
            });
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}

class _ItemDialog extends StatefulWidget {
  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить предмет'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: _weightController,
            decoration: const InputDecoration(labelText: 'Вес (кг)'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Описание'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'name': _nameController.text,
              'weight': _weightController.text,
              'description': _descriptionController.text,
            });
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}

class _SpellDialog extends StatefulWidget {
  @override
  State<_SpellDialog> createState() => _SpellDialogState();
}

class _SpellDialogState extends State<_SpellDialog> {
  final _nameController = TextEditingController();
  final _levelController = TextEditingController();
  final _schoolController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить заклинание'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: _levelController,
            decoration: const InputDecoration(labelText: 'Уровень'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _schoolController,
            decoration: const InputDecoration(labelText: 'Школа'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Описание'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'name': _nameController.text,
              'level': _levelController.text,
              'school': _schoolController.text,
              'description': _descriptionController.text,
            });
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
