import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import '../../../models/hero_model.dart';
import '../../theme/app_colors.dart';

// Skill data class
class SkillData {
  String name;
  String ability;
  bool isClassSkill;
  bool requiresStudy;
  bool isSelected;
  int points;
  int bonus;
  final HeroModel hero;

  SkillData({
    required this.name,
    required this.ability,
    required this.hero,
    this.isClassSkill = false,
    this.requiresStudy = false,
    this.isSelected = false,
    this.points = 0,
    this.bonus = 0,
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

@RoutePage()
class HeroDetailScreen extends StatefulWidget {
  final HeroModel hero;

  const HeroDetailScreen({super.key, required this.hero});

  @override
  State<HeroDetailScreen> createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late HeroModel _currentHero;
  final ScrollController _scrollController = ScrollController();

  // Skills state management
  List<SkillData> _skills = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _currentHero = widget.hero;
    _initializeSkills();
  }

  void _initializeSkills() {
    if (_currentHero == null) {
      return;
    }
    _skills = _getAllSkills();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Лист персонажа',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              _navigateToEditScreen();
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Character Profile Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF5B2333),
                        const Color(0xFF4B3869),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                // Character Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentHero.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_currentHero.characterClass} ${_currentHero.level} уровня',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_currentHero.race}, ${_currentHero.alignment}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_currentHero.age} лет, ${_currentHero.gender}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            padding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: const Color(0xFF5B2333),
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
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
          const SizedBox(height: 12),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMainTab(),
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
    );
  }

  Widget _buildMainTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Характеристики
          Container(
            width: double.infinity,
            child: const Text(
              'Характеристики',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          // Характеристики секциями в сетке 2x2
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1.2,
            children: [
              _buildAbilitySection(
                'СИЛА',
                _currentHero.strength,
                _currentHero.tempStrength,
              ),
              _buildAbilitySection(
                'ЛОВКОСТЬ',
                _currentHero.dexterity,
                _currentHero.tempDexterity,
              ),
              _buildAbilitySection(
                'ВЫНОСЛИВОСТЬ',
                _currentHero.constitution,
                _currentHero.tempConstitution,
              ),
              _buildAbilitySection(
                'ИНТЕЛЛЕКТ',
                _currentHero.intelligence,
                _currentHero.tempIntelligence,
              ),
              _buildAbilitySection(
                'МУДРОСТЬ',
                _currentHero.wisdom,
                _currentHero.tempWisdom,
              ),
              _buildAbilitySection(
                'ХАРИЗМА',
                _currentHero.charisma,
                _currentHero.tempCharisma,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Испытания
          Container(
            width: double.infinity,
            child: const Text(
              'Испытания',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 12),

          // Испытания в сетке 1x3
          Column(
            children: [
              _buildSaveSection(
                'СТОЙКОСТЬ',
                _currentHero.constitution,
                _currentHero.tempConstitution,
                _currentHero.tempFortitude,
                _currentHero.miscFortitude,
                _currentHero.magicFortitude,
              ),
              const SizedBox(height: 6),
              _buildSaveSection(
                'РЕАКЦИЯ',
                _currentHero.dexterity,
                _currentHero.tempDexterity,
                _currentHero.tempReflex,
                _currentHero.miscReflex,
                _currentHero.magicReflex,
              ),
              const SizedBox(height: 6),
              _buildSaveSection(
                'ВОЛЯ',
                _currentHero.wisdom,
                _currentHero.tempWisdom,
                _currentHero.tempWill,
                _currentHero.miscWill,
                _currentHero.magicWill,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Скорость
          Container(
            width: double.infinity,
            child: const Text(
              'Скорость',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 12),

          // Скорость в сетке 2x3
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 2.2,
            children: [
              _buildSpeedCard('БЕЗ БРОНИ', _currentHero.baseSpeed ?? 30, 'фт'),
              _buildSpeedCard('В БРОНЕ', _currentHero.armorSpeed ?? 20, 'фт'),
              _buildSpeedCard('ПОЛЕТ', _currentHero.flySpeed, 'фт'),
              _buildSpeedCard('ПЛАВАНИЕ', _currentHero.swimSpeed, 'фт'),
              _buildSpeedCard('ЛАЗАНИЕ', _currentHero.climbSpeed, 'фт'),
              _buildSpeedCard('РЫТЬЕ', _currentHero.burrowSpeed, 'фт'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefenseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Защита
          Container(
            width: double.infinity,
            child: const Text(
              'Защита',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          // Защита в сетке 1x3
          Column(
            children: [
              _buildDefenseSection(
                'КЛАСС БРОНИ',
                _currentHero.dexterity,
                _currentHero.tempDexterity,
                _currentHero.armorBonus,
                _currentHero.shieldBonus,
                _currentHero.naturalArmor,
                _currentHero.deflectionBonus,
                _currentHero.miscACBonus,
                _currentHero.sizeModifier,
              ),
              const SizedBox(height: 8),
              _buildDefenseSection(
                'КАСАНИЕ',
                _currentHero.dexterity,
                _currentHero.tempDexterity,
                null, // без брони
                _currentHero.shieldBonus,
                _currentHero.naturalArmor,
                _currentHero.deflectionBonus,
                _currentHero.miscACBonus,
                _currentHero.sizeModifier,
              ),
              const SizedBox(height: 8),
              _buildDefenseSection(
                'ВРАСПЛОХ',
                null, // без ловкости
                null,
                _currentHero.armorBonus,
                _currentHero.shieldBonus,
                _currentHero.naturalArmor,
                _currentHero.deflectionBonus,
                _currentHero.miscACBonus,
                _currentHero.sizeModifier,
              ),
              const SizedBox(height: 8),
              _buildSpellResistanceSection(_currentHero.spellResistance),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Инициатива
          Container(
            width: double.infinity,
            child: const Text(
              'Инициатива',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          _buildInitiativeSection(
            _currentHero.dexterity,
            _currentHero.tempDexterity,
            _currentHero.miscInitiativeBonus,
          ),
          const SizedBox(height: 24),

          // Атака
          Container(
            width: double.infinity,
            child: const Text(
              'Атака',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          _buildAttackSection(
            _currentHero.baseAttackBonus,
            _currentHero.strength,
            _currentHero.tempStrength,
            _currentHero.dexterity,
            _currentHero.tempDexterity,
            _currentHero.sizeModifier,
          ),
          const SizedBox(height: 24),

          // Оружие
          Container(
            width: double.infinity,
            child: const Text(
              'Оружие',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          _buildWeaponsSection(_currentHero.weapons),
        ],
      ),
    );
  }

  Widget _buildSkillsTab() {
    // Fallback if skills list is empty
    if (_skills.isEmpty) {
      _skills = [
        SkillData(name: 'ТЕСТ НАВЫК', ability: 'СИЛ', hero: _currentHero),
        SkillData(name: 'ДРУГОЙ НАВЫК', ability: 'ЛВК', hero: _currentHero),
      ];
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          _buildSkillsHeader(),
          const SizedBox(height: 12),
          ...List.generate(_skills.length, (index) {
            return _buildSkillRow(_skills[index], index);
          }),
        ],
      ),
    );
  }

  // Combined skills list
  List<SkillData> _getAllSkills() {
    return [
      // Общие навыки
      SkillData(name: 'АКРОБАТИКА', ability: 'ЛВК', hero: _currentHero),
      SkillData(name: 'БЛЕФ', ability: 'ХАР', hero: _currentHero),
      SkillData(name: 'ВЕРХОВАЯ ЕЗДА', ability: 'ЛВК', hero: _currentHero),
      SkillData(name: 'ВНИМАНИЕ', ability: 'МДР', hero: _currentHero),
      SkillData(name: 'ВЫЖИВАНИЕ', ability: 'МДР', hero: _currentHero),
      SkillData(name: 'ДИПЛОМАТИЯ', ability: 'ХАР', hero: _currentHero),
      SkillData(name: 'ЗАПУГИВАНИЕ', ability: 'ХАР', hero: _currentHero),
      SkillData(name: 'ИЗВОРОТЛИВОСТЬ', ability: 'ЛВК', hero: _currentHero),
      SkillData(name: 'ЛАЗАНИЕ', ability: 'СИЛ', hero: _currentHero),
      SkillData(name: 'ЛЕЧЕНИЕ', ability: 'МДР', hero: _currentHero),
      SkillData(name: 'МАСКИРОВКА', ability: 'ХАР', hero: _currentHero),
      SkillData(name: 'ОЦЕНКА', ability: 'ИНТ', hero: _currentHero),
      SkillData(name: 'ПЛАВАНИЕ', ability: 'СИЛ', hero: _currentHero),
      SkillData(name: 'ПОЛЕТ', ability: 'ЛВК', hero: _currentHero),
      SkillData(name: 'ПРОНИЦАТЕЛЬНОСТЬ', ability: 'МДР', hero: _currentHero),
      SkillData(name: 'СКРЫТНОСТЬ', ability: 'ЛВК', hero: _currentHero),

      // Навыки знаний
      SkillData(
        name: 'ЗНАНИЕ (ВЫСШИЙ СВЕТ)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (ГЕОГРАФИЯ)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (ИНЖЕНЕРНОЕ ДЕЛО)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (ИСТОРИЯ)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (КРАЕВЕДЕНИЕ)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (МАГИЯ)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (ПЛАНЫ)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (ПОДЗЕМЕЛЬЯ)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (ПРИРОДА)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЗНАНИЕ (РЕЛИГИЯ)',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),
      SkillData(
        name: 'ЯЗЫКОЗНАНИЕ',
        ability: 'ИНТ',
        requiresStudy: true,
        hero: _currentHero,
      ),

      // Навыки исполнения
      SkillData(name: 'ИСПОЛНЕНИЕ (ПЕНИЕ)', ability: 'ХАР', hero: _currentHero),
      SkillData(name: 'ИСПОЛНЕНИЕ (ТАНЕЦ)', ability: 'ХАР', hero: _currentHero),
      SkillData(
        name: 'ИСПОЛНЕНИЕ (ИГРА НА ИНСТРУМЕНТЕ)',
        ability: 'ХАР',
        hero: _currentHero,
      ),
      SkillData(
        name: 'ИСПОЛНЕНИЕ (ОРАТОРСКОЕ ИСКУССТВО)',
        ability: 'ХАР',
        hero: _currentHero,
      ),
      SkillData(
        name: 'ИСПОЛНЕНИЕ (ПОЭЗИЯ)',
        ability: 'ХАР',
        hero: _currentHero,
      ),

      // Профессия и ремесло
      SkillData(name: 'ПРОФЕССИЯ (ПОВАР)', ability: 'МДР', hero: _currentHero),
      SkillData(
        name: 'ПРОФЕССИЯ (САДОВНИК)',
        ability: 'МДР',
        hero: _currentHero,
      ),
      SkillData(name: 'ПРОФЕССИЯ (ПИСАРЬ)', ability: 'МДР', hero: _currentHero),
      SkillData(
        name: 'РЕМЕСЛО (КУЗНЕЧНОЕ ДЕЛО)',
        ability: 'ИНТ',
        hero: _currentHero,
      ),
      SkillData(
        name: 'РЕМЕСЛО (СТОЛЯРНОЕ ДЕЛО)',
        ability: 'ИНТ',
        hero: _currentHero,
      ),
      SkillData(
        name: 'РЕМЕСЛО (ПОРТНОЕ ДЕЛО)',
        ability: 'ИНТ',
        hero: _currentHero,
      ),
      SkillData(name: 'РЕМЕСЛО (АЛХИМИЯ)', ability: 'ИНТ', hero: _currentHero),
      SkillData(name: 'РЕМЕСЛО (КАМЕНЩИК)', ability: 'ИНТ', hero: _currentHero),
    ];
  }

  Widget _buildSkillsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: Column(
        children: [
          // First row: Checkbox, Skill name, Total
          Row(
            children: [
              // Custom checkbox column for class skills
              SizedBox(
                width: 8,
                child: Text(
                  'К',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),

              // Skill name column
              Expanded(
                child: Text(
                  'НАВЫК',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Total column
              SizedBox(
                width: 40,
                child: Text(
                  'ИТОГО',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          // Second row: Ability, Points, Bonus
          Row(
            children: [
              const SizedBox(width: 16), // Align with checkbox
              // Spacer to push controls to the right
              const Expanded(child: SizedBox()),

              // Points column
              SizedBox(
                width: 48,
                child: Text(
                  'ОЧКИ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(width: 8),

              // Bonus column
              SizedBox(
                width: 48,
                child: Text(
                  'БОНУС',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRow(SkillData skill, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            skill.isClassSkill
                ? const Color(0xFF3A2A2A)
                : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            _skills[index] = skill.copyWith(isClassSkill: !skill.isClassSkill);
          });
        },
        child: Column(
          children: [
            // First row: Checkbox and Skill name
            Row(
              children: [
                // Custom checkbox for class skill
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _skills[index] = skill.copyWith(
                        isClassSkill: !skill.isClassSkill,
                      );
                    });
                  },
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          skill.isClassSkill
                              ? const Color(0xFF5B2333)
                              : Colors.transparent,
                      border: Border.all(
                        color:
                            skill.isClassSkill
                                ? const Color(0xFF5B2333)
                                : Colors.grey.withOpacity(0.5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    child:
                        skill.isClassSkill
                            ? const Center(
                              child: Icon(
                                Icons.check,
                                size: 6,
                                color: Colors.white,
                              ),
                            )
                            : null,
                  ),
                ),
                const SizedBox(width: 8),

                // Skill name
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          skill.name,
                          style: TextStyle(
                            color:
                                skill.isClassSkill
                                    ? const Color(0xFFFFD700)
                                    : Colors.white,
                            fontSize: 12,
                            fontWeight:
                                skill.isClassSkill
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (skill.requiresStudy)
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),

                // Total
                Container(
                  width: 32,
                  child: Text(
                    '${skill.total >= 0 ? '+' : ''}${skill.total}',
                    style: const TextStyle(
                      color: Color(0xFF00FF00),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            // Second row: Ability, Points, Bonus
            Row(
              children: [
                const SizedBox(width: 16), // Align with checkbox
                // Ability with value
                Container(
                  width: 32,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            skill.ability,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${skill.modifier >= 0 ? '+' : ''}${skill.modifier}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Spacer to push controls to the right
                const Expanded(child: SizedBox()),

                // Points with +/- buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (skill.points > 0) {
                          setState(() {
                            _skills[index] = skill.copyWith(
                              points: skill.points - 1,
                            );
                          });
                        }
                      },
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B2333),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Center(
                          child: Text(
                            '-',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          skill.points.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _skills[index] = skill.copyWith(
                            points: skill.points + 1,
                          );
                        });
                      },
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B2333),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                // Bonus with +/- buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _skills[index] = skill.copyWith(
                            bonus: skill.bonus - 1,
                          );
                        });
                      },
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B2333),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Center(
                          child: Text(
                            '-',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          skill.bonus.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _skills[index] = skill.copyWith(
                            bonus: skill.bonus + 1,
                          );
                        });
                      },
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B2333),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: const Text(
              'Инвентарь',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          // Заглушка для инвентаря
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Раздел инвентаря в разработке',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: const Text(
              'Способности',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          // Заглушка для способностей
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Раздел способностей в разработке',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: const Text(
              'Заметки',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          // Заглушка для заметок
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Раздел заметок в разработке',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
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
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
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

  int _calculateModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  Widget _buildAbilitySection(String name, int baseValue, int? tempValue) {
    final baseModifier = _calculateModifier(baseValue);
    final tempModifier =
        tempValue != null ? _calculateModifier(tempValue) : null;

    return Container(
      padding: const EdgeInsets.all(8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Сетка 2x2 для значений
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1.5,
              children: [
                // Значение
                _buildValueCard('ЗНАЧ', '$baseValue', Colors.white),
                // Модификатор
                _buildValueCard(
                  'МДФ',
                  '${baseModifier >= 0 ? '+' : ''}$baseModifier',
                  Colors.white,
                ),
                // Временное значение
                _buildValueCard(
                  'ВРЕМ',
                  tempValue != null ? '$tempValue' : '-',
                  tempValue != null
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
                // Временный модификатор
                _buildValueCard(
                  'ВР.МДФ',
                  tempModifier != null
                      ? '${tempModifier >= 0 ? '+' : ''}$tempModifier'
                      : '-',
                  tempModifier != null
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveSection(
    String name,
    int baseAbility,
    int? tempAbility,
    int? tempSave,
    int? miscSave,
    int? magicSave,
  ) {
    final baseModifier = _calculateModifier(baseAbility);
    final tempModifier =
        tempAbility != null ? _calculateModifier(tempAbility) : baseModifier;

    // Базовый бонус (уровень / 2)
    final level = int.tryParse(_currentHero.level) ?? 1;
    final baseBonus = (level / 2).floor();

    // Итоговый бонус испытания
    final totalBonus =
        tempModifier +
        baseBonus +
        (tempSave ?? 0) +
        (miscSave ?? 0) +
        (magicSave ?? 0);

    return Container(
      padding: const EdgeInsets.all(8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSaveValueCard('БАЗ', '$baseBonus', Colors.white),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildSaveValueCard(
                  'МОДИФ',
                  '${tempModifier >= 0 ? '+' : ''}$tempModifier',
                  Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildSaveValueCard(
                  'ВРЕМ',
                  '${tempSave ?? 0}',
                  tempSave != null && tempSave != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildSaveValueCard(
                  'ПРОЧ',
                  '${miscSave ?? 0}',
                  miscSave != null && miscSave != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildSaveValueCard(
                  'МАГ',
                  '${magicSave ?? 0}',
                  magicSave != null && magicSave != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildSaveValueCard(
                  'ИТОГО',
                  '${totalBonus >= 0 ? '+' : ''}$totalBonus',
                  const Color(0xFF00FF00),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveValueCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedCard(String name, int? speed, String unit) {
    final speedValue = speed ?? 0;
    final cells = (speedValue / 5).floor(); // 1 клетка = 5 футов

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ФУТЫ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$speedValue $unit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'КЛЕТКИ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$cells',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefenseSection(
    String name,
    int? baseDexterity,
    int? tempDexterity,
    int? armorBonus,
    int? shieldBonus,
    int? naturalArmor,
    int? deflectionBonus,
    int? miscACBonus,
    int? sizeModifier,
  ) {
    final dexterityModifier =
        baseDexterity != null ? _calculateModifier(baseDexterity) : 0;
    final tempDexterityModifier =
        tempDexterity != null
            ? _calculateModifier(tempDexterity)
            : dexterityModifier;

    // Базовый КБ = 10
    final baseAC = 10;

    // Итоговый КБ
    final totalAC =
        baseAC +
        (armorBonus ?? 0) +
        (shieldBonus ?? 0) +
        tempDexterityModifier +
        (sizeModifier ?? 0) +
        (naturalArmor ?? 0) +
        (deflectionBonus ?? 0) +
        (miscACBonus ?? 0);

    return Container(
      padding: const EdgeInsets.all(8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalAC',
                style: const TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDefenseValueCard('БАЗ', '$baseAC', Colors.white),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildDefenseValueCard(
                  'БРОНЯ',
                  '${armorBonus ?? 0}',
                  armorBonus != null && armorBonus != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildDefenseValueCard(
                  'ЩИТ',
                  '${shieldBonus ?? 0}',
                  shieldBonus != null && shieldBonus != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildDefenseValueCard(
                  'ЛВК',
                  '${tempDexterityModifier >= 0 ? '+' : ''}$tempDexterityModifier',
                  Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildDefenseValueCard(
                  'РАЗМ',
                  '${sizeModifier ?? 0}',
                  sizeModifier != null && sizeModifier != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildDefenseValueCard(
                  'ЕСТ',
                  '${naturalArmor ?? 0}',
                  naturalArmor != null && naturalArmor != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildDefenseValueCard(
                  'ОТР',
                  '${deflectionBonus ?? 0}',
                  deflectionBonus != null && deflectionBonus != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: _buildDefenseValueCard(
              'ПРОЧ',
              '${miscACBonus ?? 0}',
              miscACBonus != null && miscACBonus != 0
                  ? const Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefenseValueCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _calculateMaxHP() {
    int level = int.tryParse(_currentHero.level) ?? 1;
    int conMod = _calculateModifier(_currentHero.constitution);
    return level * 6 + conMod * level;
  }

  int _calculateSaveBonus(int abilityScore) {
    int level = int.tryParse(_currentHero.level) ?? 1;
    int abilityMod = _calculateModifier(abilityScore);
    return (level / 2).floor() + abilityMod;
  }

  String _getSaveBonus(int? save) {
    if (save == null) return '0';
    return save.toString();
  }

  void _navigateToEditScreen() async {
    // Navigate to edit screen with current hero data
    final result = await context.router.push(
      CreateHeroRoute(hero: _currentHero),
    );

    // If we get back a result (updated hero), update the current hero
    if (result != null && result is HeroModel) {
      setState(() {
        _currentHero = result;
      });
    }
  }

  Widget _buildSpellResistanceSection(int? spellResistance) {
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'УСТОЙЧИВОСТЬ К МАГИИ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${spellResistance ?? 0}',
            style: TextStyle(
              color:
                  spellResistance != null && spellResistance != 0
                      ? const Color(0xFF00FF00)
                      : Colors.white.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitiativeSection(
    int baseDexterity,
    int? tempDexterity,
    int? miscInitiativeBonus,
  ) {
    final dexterityModifier = _calculateModifier(baseDexterity);
    final tempModifier =
        tempDexterity != null ? _calculateModifier(tempDexterity) : null;
    final totalModifier =
        (tempModifier ?? dexterityModifier) + (miscInitiativeBonus ?? 0);

    return Container(
      padding: const EdgeInsets.all(8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Инициатива',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${totalModifier >= 0 ? '+' : ''}$totalModifier',
                style: const TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInitiativeValueCard(
                  'БАЗ',
                  '$dexterityModifier',
                  Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildInitiativeValueCard(
                  'ЛВК',
                  tempModifier != null
                      ? '${tempModifier >= 0 ? '+' : ''}$tempModifier'
                      : '-',
                  tempModifier != null
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildInitiativeValueCard(
                  'ПРОЧ',
                  '${miscInitiativeBonus ?? 0}',
                  miscInitiativeBonus != null && miscInitiativeBonus != 0
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitiativeValueCard(
    String label,
    String value,
    Color valueColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttackSection(
    int? baseAttackBonus,
    int strength,
    int? tempStrength,
    int dexterity,
    int? tempDexterity,
    int? sizeModifier,
  ) {
    final strengthModifier = _calculateModifier(strength);
    final tempStrengthModifier =
        tempStrength != null
            ? _calculateModifier(tempStrength)
            : strengthModifier;
    final dexterityModifier = _calculateModifier(dexterity);
    final tempDexterityModifier =
        tempDexterity != null
            ? _calculateModifier(tempDexterity)
            : dexterityModifier;

    // МБМ - Боевой маневр
    final totalCombatManeuverBonus =
        (baseAttackBonus ?? 0) + tempStrengthModifier + (sizeModifier ?? 0);

    // ЗБМ - Защита от боевого маневра
    final totalCombatManeuverDefense =
        (baseAttackBonus ?? 0) +
        tempStrengthModifier +
        tempDexterityModifier +
        (sizeModifier ?? 0) +
        10;

    return Column(
      children: [
        // БМА карточка
        Container(
          padding: const EdgeInsets.all(8),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'БМА',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${baseAttackBonus ?? 0}',
                style: const TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // МБМ карточка
        Container(
          padding: const EdgeInsets.all(8),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'МБМ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${totalCombatManeuverBonus >= 0 ? '+' : ''}$totalCombatManeuverBonus',
                    style: const TextStyle(
                      color: Color(0xFF00FF00),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildAttackValueCard(
                      'БМА',
                      '${baseAttackBonus ?? 0}',
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildAttackValueCard(
                      'СИЛ',
                      '${tempStrengthModifier >= 0 ? '+' : ''}$tempStrengthModifier',
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildAttackValueCard(
                      'РАЗМ',
                      '${sizeModifier ?? 0}',
                      sizeModifier != null && sizeModifier != 0
                          ? const Color(0xFFFFD700)
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // ЗБМ карточка
        Container(
          padding: const EdgeInsets.all(8),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ЗБМ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$totalCombatManeuverDefense',
                    style: const TextStyle(
                      color: Color(0xFF00FF00),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildAttackValueCard(
                      'БМА',
                      '${baseAttackBonus ?? 0}',
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildAttackValueCard(
                      'СИЛ',
                      '${tempStrengthModifier >= 0 ? '+' : ''}$tempStrengthModifier',
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildAttackValueCard(
                      'ЛВК',
                      '${tempDexterityModifier >= 0 ? '+' : ''}$tempDexterityModifier',
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildAttackValueCard(
                      'РАЗМ',
                      '${sizeModifier ?? 0}',
                      sizeModifier != null && sizeModifier != 0
                          ? const Color(0xFFFFD700)
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildAttackValueCard(
                      '+10',
                      '10',
                      const Color(0xFFFFD700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttackValueCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponsSection(List<Map<String, dynamic>> weapons) {
    return Column(
      children: [
        // Карточка с таблицей оружия
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              children: [
                // Название оружия слева
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        weapons.isNotEmpty
                            ? (weapons.first['name'] ?? 'Оружие')
                            : 'Оружие',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Первая строка - миникарточки
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Модификатор Атаки',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              weapons.isNotEmpty
                                  ? '${weapons.first['attackModifier'] ?? 0}'
                                  : '-',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'КРИТ.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              weapons.isNotEmpty
                                  ? (weapons.first['criticalRange'] ?? '-')
                                  : '-',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Вторая строка - миникарточки
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ТИП',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              weapons.isNotEmpty
                                  ? (weapons.first['type'] ?? '-')
                                  : '-',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ДС',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              weapons.isNotEmpty
                                  ? (weapons.first['range'] ?? '-')
                                  : '-',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'БС',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              weapons.isNotEmpty
                                  ? (weapons.first['ammunition'] ?? '-')
                                  : '-',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'УРОН',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              weapons.isNotEmpty
                                  ? (weapons.first['damage'] ?? '-')
                                  : '-',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Кнопка добавления оружия вне карточки
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Добавить логику добавления оружия
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2A2A),
              foregroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'ДОБАВИТЬ ОРУЖИЕ',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeaponValueCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
