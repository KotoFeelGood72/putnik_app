import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';

import '../../../models/hero_model.dart';
import '../../../models/skill_data.dart';
import '../../../models/feat_model.dart';
import '../../../models/weapon_model.dart';
import '../../../services/feats_service.dart';
import '../../../services/weapons_service.dart';
import 'package:putnik_app/present/components/cards/card_value.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../components/modals/add_equipment_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:putnik_app/present/components/button/custom_tags.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/components/head/section_head_info.dart';
import 'package:putnik_app/present/screens/hero/input_field.dart';
import '../../../utils/modal_utils.dart';
import '../../../services/pathfinder_repository.dart';
import 'tabs/main_tab.dart';
import 'tabs/combat_tab.dart';
import 'tabs/skills_tab.dart';
import 'tabs/inventory_tab.dart';

import 'tabs/feats_tab.dart';

@RoutePage()
class HeroDetailScreen extends StatefulWidget {
  final HeroModel hero;

  const HeroDetailScreen({super.key, required this.hero});

  @override
  State<HeroDetailScreen> createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen>
    with SingleTickerProviderStateMixin {
  late HeroModel _currentHero;
  int _selectedTabIndex = 0;

  List<SkillData> _skills = [];
  List<FeatModel> _allFeats = [];

  late PathfinderRepository _pathfinderRepository;

  // Abilities to-do list state management

  // Traits to-do list state management

  // Inventory state management
  final TextEditingController _equipmentNameController =
      TextEditingController();
  final TextEditingController _equipmentWeightController =
      TextEditingController();

  // Load values
  int _lightLoad = 0;
  int _mediumLoad = 0;
  int _heavyLoad = 0;
  int _liftOverHead = 0;
  int _liftOffGround = 0;
  int _pushOrDrag = 0;

  @override
  void initState() {
    super.initState();
    _currentHero = widget.hero;
    _pathfinderRepository = PathfinderRepository();
    _initializeSkills(); // Вызываем асинхронно
    _initializeFeats(); // Загружаем черты
  }

  Future<void> _initializeSkills() async {
    _skills = await _getAllSkills();
    setState(() {});
  }

  Future<void> _initializeFeats() async {
    try {
      _allFeats = await FeatsService.getAllFeats();
      setState(() {});
    } catch (e) {
      print('Ошибка загрузки черт: $e');
    }
  }

  @override
  void dispose() {
    _equipmentNameController.dispose();
    _equipmentWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body: Center(
          child: Text(
            'Пользователь не найден',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: NewAppBar(title: 'Лист персонажа'),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('heroes')
                .doc(_currentHero.id)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            // Обновляем данные героя из Firebase
            final heroData = snapshot.data!.data() as Map<String, dynamic>;
            _currentHero = HeroModel.fromJson(heroData, id: _currentHero.id);
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Кастомные табы
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTabButton('Основное', 0),
                      _buildTabButton('Бой', 1),
                      _buildTabButton('Навыки', 2),
                      _buildTabButton('Инвентарь', 3),
                      _buildTabButton('Черты', 4),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Контент таба
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      MainTab(
                        hero: _currentHero,
                        onShowHpEditModal: _showHpEditModal,
                        onShowEditHeroModal: _showEditHeroModal,
                        onShowAbilityEditModal: _showAbilityEditModal,
                        onShowSaveEditModal: _showSaveEditModal,
                        onShowSpeedEditModal: _showSpeedEditModal,
                      ),
                      CombatTab(
                        hero: _currentHero,
                        onShowDefenseEditModal: _showDefenseEditModal,
                        onShowInitiativeEditModal: _showInitiativeEditModal,
                        onShowBMAEditModal: _showBMAEditModal,
                        onShowMBMFormulaModal: _showMBMFormulaModal,
                        onShowZBMFormulaModal: _showZBMFormulaModal,
                      ),
                      SkillsTab(
                        skills: _skills,
                        heroClass: _currentHero.characterClass,
                        onShowSkillEditModal: _showSkillEditModal,
                        onShowAddCustomSkillModal: _showAddCustomSkillModal,
                        onToggleClassSkill: (index) {
                          setState(() {
                            _skills[index] = _skills[index].copyWith(
                              isClassSkill: !_skills[index].isClassSkill,
                            );
                          });
                        },
                      ),
                      InventoryTab(
                        equipment: _currentHero.equipment,
                        weapons: _currentHero.weapons,
                        armors: _currentHero.armors ?? [],
                        goods: _currentHero.goods ?? [],

                        copperCoins: _currentHero.copperCoins,
                        silverCoins: _currentHero.silverCoins,
                        goldCoins: _currentHero.goldCoins,
                        platinumCoins: _currentHero.platinumCoins,
                        onShowAddEquipmentModal: _showAddEquipmentModal,
                        onShowLoadEditModal: _showLoadEditModal,
                        onRemoveEquipment: _removeEquipment,
                        onEditCurrency: _editCurrency,
                        onEquipmentChanged: (equipment) {
                          print('=== onEquipmentChanged вызван ===');
                          print('Новый список снаряжения: ${equipment.length}');
                          setState(() {
                            _currentHero.equipment = equipment;
                          });
                          print('Обновляем Firebase...');
                          updateHeroInFirebase(_currentHero);
                        },
                        onWeaponsChanged: (weapons) {
                          print('=== onWeaponsChanged вызван ===');
                          print('Новый список оружия: ${weapons.length}');
                          setState(() {
                            _currentHero.weapons = weapons;
                          });
                          print('Обновляем Firebase...');
                          updateHeroInFirebase(_currentHero);
                        },
                        onArmorsChanged: (armors) {
                          print('=== onArmorsChanged вызван ===');
                          print('Новый список доспехов: ${armors.length}');
                          setState(() {
                            _currentHero.armors = armors;
                          });
                          print('Обновляем Firebase...');
                          updateHeroInFirebase(_currentHero);
                        },
                        onGoodsChanged: (goods) {
                          print('=== onGoodsChanged вызван ===');
                          print('Новый список товаров: ${goods.length}');
                          setState(() {
                            _currentHero.goods = goods;
                          });
                          print('Обновляем Firebase...');
                          updateHeroInFirebase(_currentHero);
                        },
                      ),
                      FeatsTab(
                        feats: _currentHero.feats,
                        onFeatsChanged: (feats) {
                          setState(() {
                            _currentHero.feats = feats;
                          });
                          updateHeroInFirebase(_currentHero);
                        },
                        allFeats: _allFeats,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFF5B2333) : Colors.transparent,
          foregroundColor: isSelected ? Colors.white : Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        onPressed: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            letterSpacing: isSelected ? 0.5 : 0.3,
          ),
        ),
      ),
    );
  }

  // Combined skills list
  Future<List<SkillData>> _getAllSkills() async {
    try {
      final skillsWithClasses =
          await _pathfinderRepository.getSkillsWithClasses();
      final List<SkillData> skills = [];

      for (final skillData in skillsWithClasses) {
        final skillName = skillData['name'] as String;
        final ability = _pathfinderRepository.getAbilityForSkill(skillName);
        final requiresStudy = await _pathfinderRepository.requiresStudy(
          skillName,
        );
        final isClassSkill = await _pathfinderRepository.isClassSkill(
          skillName,
          _currentHero.characterClass,
        );

        // Проверяем доступность навыка
        bool isAvailable = true;
        if (requiresStudy && !isClassSkill) {
          // Если навык требует изучения и не является классовым, он недоступен
          isAvailable = false;
        }

        // Вычисляем модификатор способности
        int abilityModifier = 0;
        switch (ability) {
          case 'СИЛ':
            abilityModifier = ((_currentHero.strength - 10) / 2).floor();
            break;
          case 'ЛВК':
            abilityModifier = ((_currentHero.dexterity - 10) / 2).floor();
            break;
          case 'ВЫН':
            abilityModifier = ((_currentHero.constitution - 10) / 2).floor();
            break;
          case 'ИНТ':
            abilityModifier = ((_currentHero.intelligence - 10) / 2).floor();
            break;
          case 'МДР':
            abilityModifier = ((_currentHero.wisdom - 10) / 2).floor();
            break;
          case 'ХАР':
            abilityModifier = ((_currentHero.charisma - 10) / 2).floor();
            break;
        }

        // Для навыков, которые не требуют изучения, модификатор добавляется как базовое значение
        int baseBonus = 0;
        if (!requiresStudy) {
          baseBonus = abilityModifier;
        }

        skills.add(
          SkillData(
            name: skillName,
            ability: ability,
            hero: _currentHero,
            isClassSkill: isClassSkill,
            requiresStudy: requiresStudy,
            isAvailable: isAvailable,
            bonus: baseBonus,
          ),
        );
      }

      return skills;
    } catch (e) {
      print('Ошибка загрузки навыков: $e');
      // Возвращаем базовый список навыков в случае ошибки
      return [
        SkillData(
          name: 'АКРОБАТИКА',
          ability: 'ЛВК',
          hero: _currentHero,
          bonus: ((_currentHero.dexterity - 10) / 2).floor(),
        ),
        SkillData(
          name: 'БЛЕФ',
          ability: 'ХАР',
          hero: _currentHero,
          bonus: ((_currentHero.charisma - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ВЕРХОВАЯ ЕЗДА',
          ability: 'ЛВК',
          hero: _currentHero,
          bonus: ((_currentHero.dexterity - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ВНИМАНИЕ',
          ability: 'МДР',
          hero: _currentHero,
          bonus: ((_currentHero.wisdom - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ВЫЖИВАНИЕ',
          ability: 'МДР',
          hero: _currentHero,
          bonus: ((_currentHero.wisdom - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ДИПЛОМАТИЯ',
          ability: 'ХАР',
          hero: _currentHero,
          bonus: ((_currentHero.charisma - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ЗАПУГИВАНИЕ',
          ability: 'ХАР',
          hero: _currentHero,
          bonus: ((_currentHero.charisma - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ИЗВОРОТЛИВОСТЬ',
          ability: 'ЛВК',
          hero: _currentHero,
          bonus: ((_currentHero.dexterity - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ЛАЗАНИЕ',
          ability: 'СИЛ',
          hero: _currentHero,
          bonus: ((_currentHero.strength - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ЛЕЧЕНИЕ',
          ability: 'МДР',
          hero: _currentHero,
          bonus: ((_currentHero.wisdom - 10) / 2).floor(),
        ),
        SkillData(
          name: 'МАСКИРОВКА',
          ability: 'ХАР',
          hero: _currentHero,
          bonus: ((_currentHero.charisma - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ОЦЕНКА',
          ability: 'ИНТ',
          hero: _currentHero,
          bonus: ((_currentHero.intelligence - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ПЛАВАНИЕ',
          ability: 'СИЛ',
          hero: _currentHero,
          bonus: ((_currentHero.strength - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ПОЛЕТ',
          ability: 'ЛВК',
          hero: _currentHero,
          bonus: ((_currentHero.dexterity - 10) / 2).floor(),
        ),
        SkillData(
          name: 'ПРОНИЦАТЕЛЬНОСТЬ',
          ability: 'МДР',
          hero: _currentHero,
          bonus: ((_currentHero.wisdom - 10) / 2).floor(),
        ),
        SkillData(
          name: 'СКРЫТНОСТЬ',
          ability: 'ЛВК',
          hero: _currentHero,
          bonus: ((_currentHero.dexterity - 10) / 2).floor(),
        ),
      ];
    }
  }

  // Методы для работы с инвентарем
  void _showAddEquipmentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AddEquipmentModal(
            onAddEquipment: (name, weight) {
              setState(() {
                _currentHero.equipment.add({'name': name, 'weight': weight});
              });
              updateHeroInFirebase(_currentHero);
            },
          ),
    );
  }

  void _removeEquipment(int index) {
    setState(() {
      _currentHero.equipment.removeAt(index);
    });
    updateHeroInFirebase(_currentHero);
  }

  // Методы для работы с модальными окнами
  void _showHpEditModal() {
    int maxHp = _currentHero.maxHp ?? 100;
    int currentHp = _currentHero.currentHp ?? 12;
    final maxHpController = TextEditingController(text: maxHp.toString());
    final currentHpController = TextEditingController(
      text: currentHp.toString(),
    );

    // Контент для редактирования HP
    Widget hpContent = StatefulBuilder(
      builder: (context, setModalState) {
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: maxHpController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Максимум',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  maxHp = int.tryParse(value) ?? maxHp;
                  setModalState(() {});
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: currentHpController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Текущее',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  currentHp = int.tryParse(value) ?? currentHp;
                  setModalState(() {});
                },
              ),
            ),
          ],
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showCustomModal(
      context: context,
      title: 'Редактировать HP',
      content: hpContent,
      maxHeightRatio: 0.4,
      onSave: () async {
        setState(() {
          _currentHero.maxHp = int.tryParse(maxHpController.text) ?? maxHp;
          _currentHero.currentHp =
              int.tryParse(currentHpController.text) ?? currentHp;
        });
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  void _showEditHeroModal() {
    File? tempPhotoFile =
        _currentHero.photoPath != null && _currentHero.photoPath!.isNotEmpty
            ? File(_currentHero.photoPath!)
            : null;
    String tempName = _currentHero.name;
    String tempAge = _currentHero.age;
    String tempGender = _currentHero.gender;
    String tempAlignment = _currentHero.alignment;
    String tempClass = _currentHero.characterClass;
    String tempRace = _currentHero.race;
    String tempArchetype = _currentHero.archetype ?? '';

    // Создаём контроллеры один раз
    final nameController = TextEditingController(text: tempName);
    final ageController = TextEditingController(text: tempAge);
    final alignmentController = TextEditingController(text: tempAlignment);
    final classController = TextEditingController(text: tempClass);
    final raceController = TextEditingController(text: tempRace);
    final archetypeController = TextEditingController(text: tempArchetype);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              bool isSaving = false;
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF232323),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Редактировать героя',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Фото
                      Row(
                        children: [
                          ClipOval(
                            child:
                                tempPhotoFile != null
                                    ? Image.file(
                                      tempPhotoFile!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                    : Container(
                                      width: 60,
                                      height: 60,
                                      color: const Color(0xFF3A2A2A),
                                      child: Icon(
                                        Icons.person,
                                        size: 36,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      final picked = await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (picked != null) {
                                        tempPhotoFile = File(picked.path);
                                        setModalState(() {});
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5B2333),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Галерея'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      final picked = await picker.pickImage(
                                        source: ImageSource.camera,
                                      );
                                      if (picked != null) {
                                        tempPhotoFile = File(picked.path);
                                        setModalState(() {});
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5B2333),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Камера'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Основная информация
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Имя',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color(0xFF2A2A2A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ageController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Возраст',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: alignmentController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Мировоззрение',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: classController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Класс',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: raceController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Раса',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: archetypeController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Архетип',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color(0xFF2A2A2A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  isSaving
                                      ? null
                                      : () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A4A4A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('ОТМЕНА'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  isSaving
                                      ? null
                                      : () async {
                                        setModalState(() => isSaving = true);
                                        setState(() {
                                          _currentHero.name =
                                              nameController.text;
                                          _currentHero.age = ageController.text;
                                          _currentHero.alignment =
                                              alignmentController.text;
                                          _currentHero.characterClass =
                                              classController.text;
                                          _currentHero.race =
                                              raceController.text;
                                          _currentHero.archetype =
                                              archetypeController.text;
                                          if (tempPhotoFile != null) {
                                            _currentHero.photoPath =
                                                tempPhotoFile!.path;
                                          }
                                        });
                                        await updateHeroInFirebase(
                                          _currentHero,
                                        );
                                        setModalState(() => isSaving = false);
                                        Navigator.pop(context);
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B2333),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child:
                                  isSaving
                                      ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Text('СОХРАНИТЬ'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  void _showAbilityEditModal(
    String abilityName,
    int baseValue,
    int? tempValue,
  ) {
    int currentBaseValue = baseValue;
    int? currentTempValue = tempValue;

    // Контент для редактирования характеристик
    Widget abilityContent = StatefulBuilder(
      builder: (context, setModalState) {
        // Вычисляем модификаторы
        final baseModifier = _calculateModifier(currentBaseValue);
        final tempModifier =
            currentTempValue != null
                ? _calculateModifier(currentTempValue!)
                : null;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Редактирование значений',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildEditableValueCard(
                      'Базовое значение',
                      currentBaseValue.toString(),
                      (newValue) {
                        currentBaseValue = newValue;
                        setModalState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEditableValueCard(
                      'Временное значение',
                      currentTempValue?.toString() ?? '-',
                      (newValue) {
                        currentTempValue = newValue == -1 ? null : newValue;
                        setModalState(() {});
                      },
                      isOptional: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildValueDisplay(
                      'Модификатор',
                      '${baseModifier >= 0 ? '+' : ''}$baseModifier',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildValueDisplay(
                      'Временный модификатор',
                      tempModifier != null
                          ? '${tempModifier >= 0 ? '+' : ''}$tempModifier'
                          : '-',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showAbilityEditModal(
      context: context,
      abilityName: abilityName,
      abilityContent: abilityContent,
      onSave: () async {
        _updateHeroAbility(abilityName, currentBaseValue, currentTempValue);
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  void _showSaveEditModal(
    String saveName,
    int baseAbility,
    int? tempAbility,
    int? tempSave,
    int? miscSave,
    int? magicSave,
  ) {
    int currentTempSave = tempSave ?? 0;
    int currentMiscSave = miscSave ?? 0;
    int currentMagicSave = magicSave ?? 0;

    // Контент для редактирования испытаний
    Widget saveContent = StatefulBuilder(
      builder: (context, setModalState) {
        final baseModifier = _calculateModifier(baseAbility);
        final tempModifier =
            tempAbility != null
                ? _calculateModifier(tempAbility!)
                : baseModifier;
        final level = int.tryParse(_currentHero.level) ?? 1;
        final baseBonus = (level / 2).floor();
        final totalBonus =
            tempModifier +
            baseBonus +
            currentTempSave +
            currentMiscSave +
            currentMagicSave;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Текущие значения',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildValueDisplay('Базовый бонус', '$baseBonus'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildValueDisplay(
                      'Модификатор',
                      '${tempModifier >= 0 ? '+' : ''}$tempModifier',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildEditableValueCardWithInputField(
                      'Временный бонус',
                      '${currentTempSave >= 0 ? '+' : ''}$currentTempSave',
                      (newValue) {
                        currentTempSave = newValue;
                        setModalState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEditableValueCardWithInputField(
                      'Прочий бонус',
                      '${currentMiscSave >= 0 ? '+' : ''}$currentMiscSave',
                      (newValue) {
                        currentMiscSave = newValue;
                        setModalState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildEditableValueCardWithInputField(
                      'Магический бонус',
                      '${currentMagicSave >= 0 ? '+' : ''}$currentMagicSave',
                      (newValue) {
                        currentMagicSave = newValue;
                        setModalState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildValueDisplay(
                      'ИТОГО',
                      '${totalBonus >= 0 ? '+' : ''}$totalBonus',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showSaveEditModal(
      context: context,
      saveName: saveName,
      saveContent: saveContent,
      onSave: () async {
        _updateHeroSave(
          saveName,
          currentTempSave,
          currentMiscSave,
          currentMagicSave,
        );
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  void _showSpeedEditModal() {
    int baseSpeed = _currentHero.baseSpeed ?? 30;
    int armorSpeed = _currentHero.armorSpeed ?? 20;
    int flySpeed = _currentHero.flySpeed ?? 0;
    int swimSpeed = _currentHero.swimSpeed ?? 0;
    int climbSpeed = _currentHero.climbSpeed ?? 0;
    int burrowSpeed = _currentHero.burrowSpeed ?? 0;

    // Контент для редактирования скоростей
    Widget speedContent = StatefulBuilder(
      builder: (context, setModalState) {
        return Column(
          children: [
            // Первый ряд: БЕЗ БРОНИ и В БРОНЕ
            Row(
              children: [
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'БЕЗ БРОНИ (фт)',
                    baseSpeed.toString(),
                    (v) {
                      baseSpeed = v;
                      setModalState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'В БРОНЕ (фт)',
                    armorSpeed.toString(),
                    (v) {
                      armorSpeed = v;
                      setModalState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Второй ряд: ПОЛЕТ и ПЛАВАНИЕ
            Row(
              children: [
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'ПОЛЕТ (фт)',
                    flySpeed.toString(),
                    (v) {
                      flySpeed = v;
                      setModalState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'ПЛАВАНИЕ (фт)',
                    swimSpeed.toString(),
                    (v) {
                      swimSpeed = v;
                      setModalState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Третий ряд: ЛАЗАНИЕ и РЫТЬЕ
            Row(
              children: [
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'ЛАЗАНИЕ (фт)',
                    climbSpeed.toString(),
                    (v) {
                      climbSpeed = v;
                      setModalState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'РЫТЬЕ (фт)',
                    burrowSpeed.toString(),
                    (v) {
                      burrowSpeed = v;
                      setModalState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showSpeedEditModal(
      context: context,
      speedContent: speedContent,
      onSave: () async {
        setState(() {
          _currentHero.baseSpeed = baseSpeed;
          _currentHero.armorSpeed = armorSpeed;
          _currentHero.flySpeed = flySpeed;
          _currentHero.swimSpeed = swimSpeed;
          _currentHero.climbSpeed = climbSpeed;
          _currentHero.burrowSpeed = burrowSpeed;
        });
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  void _showDefenseEditModal(BuildContext context) {
    // Инициализируем значения из текущего героя
    int armorBonus = _currentHero.armorBonus ?? 0;
    int shieldBonus = _currentHero.shieldBonus ?? 0;
    int naturalArmor = _currentHero.naturalArmor ?? 0;
    int deflectionBonus = _currentHero.deflectionBonus ?? 0;
    int miscACBonus = _currentHero.miscACBonus ?? 0;
    int sizeModifier = _currentHero.sizeModifier ?? 0;
    // Контент для редактирования защиты
    Widget defenseContent = StatefulBuilder(
      builder: (context, setModalState) {
        return Column(
          children: [
            // Первый ряд: Броня и Щит
            Row(
              children: [
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'Броня',
                    armorBonus.toString(),
                    (v) {
                      armorBonus = v;
                      setModalState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'Щит',
                    shieldBonus.toString(),
                    (v) {
                      shieldBonus = v;
                      setModalState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Второй ряд: Естественная и Отражение
            Row(
              children: [
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'Естественная',
                    naturalArmor.toString(),
                    (v) {
                      naturalArmor = v;
                      setModalState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'Отражение',
                    deflectionBonus.toString(),
                    (v) {
                      deflectionBonus = v;
                      setModalState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Третий ряд: Прочий и Размер
            Row(
              children: [
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'Прочий',
                    miscACBonus.toString(),
                    (v) {
                      miscACBonus = v;
                      setModalState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEditableValueCardWithInputField(
                    'Размер',
                    sizeModifier.toString(),
                    (v) {
                      sizeModifier = v;
                      setModalState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Формула расчета КБ
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Формула расчета КБ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildValueDisplay(
                          'Базовая КБ + ЛВК',
                          '10 + ${_calculateModifier(_currentHero.dexterity)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ИТОГО КБ:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${10 + _calculateModifier(_currentHero.dexterity) + armorBonus + shieldBonus + naturalArmor + deflectionBonus + sizeModifier + miscACBonus}',
                          style: const TextStyle(
                            color: Color(0xFF00FF00),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showDefenseEditModal(
      context: context,
      defenseName: 'Защита',
      defenseContent: defenseContent,
      onSave: () async {
        _updateHeroDefense(
          armorBonus,
          shieldBonus,
          naturalArmor,
          deflectionBonus,
          miscACBonus,
          sizeModifier,
        );
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  void _showInitiativeEditModal(BuildContext context) {
    int miscInitiativeBonus = _currentHero.miscInitiativeBonus ?? 0;
    final dexterityModifier = _calculateModifier(_currentHero.dexterity);

    // Контент для редактирования инициативы
    Widget initiativeContent = StatefulBuilder(
      builder: (context, setModalState) {
        final totalModifier = dexterityModifier + miscInitiativeBonus;

        return Column(
          children: [
            // Формула расчета инициативы
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Формула расчета инициативы',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildValueDisplay(
                          'ЛВК + Прочий',
                          '$dexterityModifier + $miscInitiativeBonus',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Итоговая инициатива:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Поле для редактирования
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Значения (нажмите для редактирования)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildEditableValueCardWithInputField(
                    'Прочий бонус',
                    miscInitiativeBonus.toString(),
                    (v) {
                      miscInitiativeBonus = v;
                      setModalState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showInitiativeEditModal(
      context: context,
      initiativeContent: initiativeContent,
      onSave: () async {
        setState(() {
          _currentHero.miscInitiativeBonus = miscInitiativeBonus;
        });
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  void _showBMAEditModal(BuildContext context) {
    int baseAttackBonus = _currentHero.baseAttackBonus ?? 0;

    // Контент для редактирования БМА
    Widget attackContent = StatefulBuilder(
      builder: (context, setModalState) {
        return _buildEditableValueCardWithInputField(
          'БМА',
          baseAttackBonus.toString(),
          (v) {
            baseAttackBonus = v;
            setModalState(() {});
          },
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showAttackEditModal(
      context: context,
      attackContent: attackContent,
      onSave: () async {
        setState(() {
          _currentHero.baseAttackBonus = baseAttackBonus;
        });
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  void _showMBMFormulaModal(
    BuildContext context,
    int? baseAttackBonus,
    int strengthModifier,
    int? sizeModifier,
  ) {
    // TODO: Реализовать модальное окно формулы МБМ
  }

  void _showZBMFormulaModal(
    BuildContext context,
    int? baseAttackBonus,
    int strengthModifier,
    int dexterityModifier,
    int? sizeModifier,
  ) {
    // TODO: Реализовать модальное окно формулы ЗБМ
  }

  void _showSkillEditModal(SkillData skill, int index) {
    int points = skill.points;
    int bonus = skill.bonus;
    bool isClassSkill = skill.isClassSkill;

    final pointsController = TextEditingController(text: points.toString());
    final bonusController = TextEditingController(text: bonus.toString());

    // Вычисляем итоговое значение
    int total = skill.modifier + points + bonus;
    if (isClassSkill && points > 0) {
      total += 3;
    }

    // Контент с информацией о навыке
    Widget skillInfoContent = Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoCard('Способность', skill.ability)),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Модификатор',
                '${skill.modifier >= 0 ? '+' : ''}${skill.modifier}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Итоговое значение',
                '${total >= 0 ? '+' : ''}$total',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Требует изучения',
                skill.requiresStudy ? 'Да' : 'Нет',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard('Класс героя', _currentHero.characterClass),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Классовый навык',
                skill.isClassSkill ? 'Да' : 'Нет',
              ),
            ),
          ],
        ),
      ],
    );

    // Поля для редактирования
    Widget editingFields = StatefulBuilder(
      builder: (context, setModalState) {
        return Column(
          children: [
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Очки навыка',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                points = int.tryParse(value) ?? 0;
                setModalState(() {});
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bonusController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Прочий модификатор',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                bonus = int.tryParse(value) ?? 0;
                setModalState(() {});
              },
            ),
            const SizedBox(height: 12),

            // Чекбокс для классового навыка
            if (skill.requiresStudy)
              Row(
                children: [
                  Checkbox(
                    value: isClassSkill,
                    onChanged: (value) {
                      isClassSkill = value ?? false;
                      setModalState(() {});
                    },
                    activeColor: const Color(0xFF5B2333),
                  ),
                  const Text(
                    'Классовый навык (+3 бонус)',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
          ],
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showSkillEditModal(
      context: context,
      skillName: skill.name,
      skillInfoContent: skillInfoContent,
      editingFields: editingFields,
      onSave: () async {
        setState(() {
          _skills[index] = _skills[index].copyWith(
            points: points,
            bonus: bonus,
            isClassSkill: isClassSkill,
          );
        });
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomSkillModal() {
    // TODO: Реализовать модальное окно добавления кастомного навыка
  }

  void _showLoadEditModal() {
    // TODO: Реализовать модальное окно редактирования нагрузки
  }

  void _editCurrency(String code) {
    int currentValue = 0;
    switch (code) {
      case 'ММ':
        currentValue = _currentHero.copperCoins;
        break;
      case 'СМ':
        currentValue = _currentHero.silverCoins;
        break;
      case 'ЗМ':
        currentValue = _currentHero.goldCoins;
        break;
      case 'ПМ':
        currentValue = _currentHero.platinumCoins;
        break;
    }

    // Контент для редактирования валюты
    Widget currencyContent = StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Текущее количество: $currentValue',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                placeholder: 'Введите новое количество',
                initialValue: currentValue.toString(),
                onChanged: (value) {
                  currentValue = int.tryParse(value) ?? 0;
                  setModalState(() {});
                },
                isNumber: true,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        );
      },
    );

    // Показываем модальное окно
    ModalUtils.showCustomModal(
      context: context,
      title: 'Редактировать $code',
      content: currencyContent,
      maxHeightRatio: 0.4,
      onSave: () async {
        setState(() {
          switch (code) {
            case 'ММ':
              _currentHero.copperCoins = currentValue;
              break;
            case 'СМ':
              _currentHero.silverCoins = currentValue;
              break;
            case 'ЗМ':
              _currentHero.goldCoins = currentValue;
              break;
            case 'ПМ':
              _currentHero.platinumCoins = currentValue;
              break;
          }
        });
        await updateHeroInFirebase(_currentHero);
      },
    );
  }

  void _spendMoney({required int cost, required String currency}) {
    setState(() {
      switch (currency) {
        case 'ЗМ':
          if (_currentHero.goldCoins >= cost) {
            _currentHero.goldCoins -= cost;
          }
          break;
        case 'СМ':
          if (_currentHero.silverCoins >= cost) {
            _currentHero.silverCoins -= cost;
          }
          break;
        case 'ММ':
          if (_currentHero.copperCoins >= cost) {
            _currentHero.copperCoins -= cost;
          }
          break;
        case 'ПМ':
          if (_currentHero.platinumCoins >= cost) {
            _currentHero.platinumCoins -= cost;
          }
          break;
      }
    });
    updateHeroInFirebase(_currentHero);
  }

  bool _canAfford({required int cost, required String currency}) {
    switch (currency) {
      case 'ЗМ':
        return _currentHero.goldCoins >= cost;
      case 'СМ':
        return _currentHero.silverCoins >= cost;
      case 'ММ':
        return _currentHero.copperCoins >= cost;
      case 'ПМ':
        return _currentHero.platinumCoins >= cost;
      default:
        return false;
    }
  }

  void _showNotEnoughMoneyDialog() {
    ModalUtils.showCustomModal(
      context: context,
      title: 'Недостаточно монет',
      content: const Text(
        'У вас недостаточно монет для покупки этого предмета.',
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
      cancelButtonText: 'ПОНЯТНО',
      saveButtonText: '',
      onSave: () {},
    );
  }

  void _addEquipmentFromShop(Map<String, dynamic> item) {
    // Определяем тип предмета и добавляем в соответствующий список
    setState(() {
      if (item.containsKey('proficientCategory')) {
        // Это оружие
        _currentHero.weapons.add(item);
      } else if (item.containsKey('armorType')) {
        // Это доспех
        if (_currentHero.armors == null) {
          _currentHero.armors = [];
        }
        _currentHero.armors!.add(item);
      } else if (item.containsKey('type')) {
        // Это товар
        if (_currentHero.goods == null) {
          _currentHero.goods = [];
        }
        _currentHero.goods!.add(item);
      } else {
        // По умолчанию добавляем в equipment
        _currentHero.equipment.add(item);
      }
    });
    updateHeroInFirebase(_currentHero);
  }

  void _tryBuyItem({
    required int cost,
    required String currency,
    required Map<String, dynamic> item,
  }) {
    if (_canAfford(cost: cost, currency: currency)) {
      _spendMoney(cost: cost, currency: currency);
      // Добавляем предмет в соответствующий список после успешной траты денег
      _addEquipmentFromShop(item);
    } else {
      _showNotEnoughMoneyDialog();
    }
  }

  // Метод для обновления героя в Firebase
  Future<void> updateHeroInFirebase(HeroModel hero) async {
    try {
      print('=== updateHeroInFirebase ===');
      print('ID героя: ${hero.id}');
      print('Оружие: ${hero.weapons.length}');
      print('Доспехи: ${hero.armors?.length ?? 0}');
      print('Товары: ${hero.goods?.length ?? 0}');
      print('Снаряжение: ${hero.equipment.length}');

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Пользователь найден: ${user.uid}');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('heroes')
            .doc(hero.id)
            .update(hero.toJson());
        print('Firebase обновлен успешно');
      } else {
        print('Пользователь не найден!');
      }
    } catch (e) {
      print('Ошибка при обновлении героя: $e');
    }
  }

  // Вспомогательные методы для модальных окон
  int _calculateModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  void _updateHeroAbility(
    String abilityName,
    int newBaseValue,
    int? newTempValue,
  ) {
    setState(() {
      switch (abilityName) {
        case 'СИЛ':
          _currentHero.strength = newBaseValue;
          _currentHero.tempStrength = newTempValue;
          break;
        case 'ЛВК':
          _currentHero.dexterity = newBaseValue;
          _currentHero.tempDexterity = newTempValue;
          break;
        case 'ВЫН':
          _currentHero.constitution = newBaseValue;
          _currentHero.tempConstitution = newTempValue;
          break;
        case 'ИНТ':
          _currentHero.intelligence = newBaseValue;
          _currentHero.tempIntelligence = newTempValue;
          break;
        case 'МДР':
          _currentHero.wisdom = newBaseValue;
          _currentHero.tempWisdom = newTempValue;
          break;
        case 'ХАР':
          _currentHero.charisma = newBaseValue;
          _currentHero.tempCharisma = newTempValue;
          break;
      }
    });
  }

  void _updateHeroSave(
    String saveName,
    int tempSave,
    int miscSave,
    int magicSave,
  ) {
    setState(() {
      switch (saveName) {
        case 'СТОЙ':
          _currentHero.tempFortitude = tempSave;
          _currentHero.miscFortitude = miscSave;
          _currentHero.magicFortitude = magicSave;
          break;
        case 'РЕАК':
          _currentHero.tempReflex = tempSave;
          _currentHero.miscReflex = miscSave;
          _currentHero.magicReflex = magicSave;
          break;
        case 'ВОЛЯ':
          _currentHero.tempWill = tempSave;
          _currentHero.miscWill = miscSave;
          _currentHero.magicWill = magicSave;
          break;
      }
    });
  }

  void _updateHeroDefense(
    int armorBonus,
    int shieldBonus,
    int naturalArmor,
    int deflectionBonus,
    int miscACBonus,
    int sizeModifier,
  ) {
    setState(() {
      _currentHero.armorBonus = armorBonus;
      _currentHero.shieldBonus = shieldBonus;
      _currentHero.naturalArmor = naturalArmor;
      _currentHero.deflectionBonus = deflectionBonus;
      _currentHero.miscACBonus = miscACBonus;
      _currentHero.sizeModifier = sizeModifier;
    });
  }

  Widget _buildValueDisplay(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableValueCard(
    String label,
    String value,
    Function(int) onChanged, {
    bool isOptional = false,
  }) {
    // Убираем знак "+" из значения для отображения в поле ввода
    final cleanValue = value.startsWith('+') ? value.substring(1) : value;
    final controller = TextEditingController(
      text: cleanValue == '-' ? '' : cleanValue,
    );

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: const Color(0xFF2A2A2A),
                title: Text(
                  'Редактировать $label',
                  style: const TextStyle(color: Colors.white),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputField(
                      placeholder: 'Введите значение',
                      initialValue: cleanValue == '-' ? '' : cleanValue,
                      onChanged: (text) {
                        controller.text = text;
                      },
                      isNumber: true,
                      height: 48,
                    ),
                    if (isOptional && value != '-')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextButton(
                          onPressed: () {
                            controller.clear();
                          },
                          child: const Text(
                            'Очистить значение',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'ОТМЕНА',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.text.isEmpty && isOptional) {
                        onChanged(-1);
                      } else {
                        final newValue = int.tryParse(controller.text);
                        if (newValue != null) {
                          onChanged(newValue);
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'СОХРАНИТЬ',
                      style: TextStyle(color: Color(0xFF5B2333)),
                    ),
                  ),
                ],
              ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableValueCardWithInputField(
    String label,
    String value,
    Function(int) onChanged, {
    bool isOptional = false,
  }) {
    // Убираем знак "+" из значения для отображения в поле ввода
    final cleanValue = value.startsWith('+') ? value.substring(1) : value;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          InputField(
            placeholder: 'Введите значение',
            initialValue: cleanValue == '-' ? '' : cleanValue,
            onChanged: (text) {
              if (text.isEmpty && isOptional) {
                onChanged(-1);
              } else {
                final newValue = int.tryParse(text);
                if (newValue != null) {
                  onChanged(newValue);
                }
              }
            },
            isNumber: true,
            height: 32,
            textSize: 14,
          ),
        ],
      ),
    );
  }
}
