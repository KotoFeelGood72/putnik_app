import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import '../../../models/hero_model.dart';
import '../../theme/app_colors.dart';

// Класс для описания полей редактирования
class EditField {
  final String key;
  final String label;
  final dynamic value;
  final String? displayValue;
  final String hint;
  final bool isEditable;

  EditField({
    required this.key,
    required this.label,
    required this.value,
    this.displayValue,
    required this.hint,
    this.isEditable = true,
  });
}

// Skill data class
class SkillData {
  final String name;
  final String ability;
  final HeroModel hero;
  final bool isClassSkill;
  final bool requiresStudy;
  final bool isSelected;
  final int points;
  final int bonus;
  final String skillValue; // Добавляем поле для значения навыка

  SkillData({
    required this.name,
    required this.ability,
    required this.hero,
    this.isClassSkill = false,
    this.requiresStudy = false,
    this.isSelected = false,
    this.points = 0,
    this.bonus = 0,
    this.skillValue = '', // По умолчанию пустая строка
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
    String? skillValue, // Добавляем в copyWith
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
      skillValue: skillValue ?? this.skillValue, // Добавляем в copyWith
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

  // Abilities to-do list state management
  List<String> _abilities = [];
  final TextEditingController _abilityController = TextEditingController();

  // Traits to-do list state management
  List<String> _traits = [];
  final TextEditingController _traitController = TextEditingController();

  // Inventory state management
  List<Map<String, dynamic>> _equipment = [];
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

  // Currency values
  int _copperCoins = 0;
  int _silverCoins = 0;
  int _goldCoins = 0;
  int _platinumCoins = 0;

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
    _abilityController.dispose();
    _traitController.dispose();
    _equipmentNameController.dispose();
    _equipmentWeightController.dispose();
    super.dispose();
  }

  void _showAddEquipmentModal() {
    String equipmentName = '';
    String equipmentWeight = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Добавить снаряжение',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Название предмета
                      Text(
                        'Название предмета:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          equipmentName = value;
                          setModalState(() {});
                        },
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Введите название предмета...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF2A2A2A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF5B2333),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Вес в фунтах
                      Text(
                        'Вес (в фунтах):',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          equipmentWeight = value;
                          setModalState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF2A2A2A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF5B2333),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Кнопки
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
                                  equipmentName.isNotEmpty
                                      ? () {
                                        setState(() {
                                          _equipment.add({
                                            'name': equipmentName,
                                            'weight':
                                                int.tryParse(equipmentWeight) ??
                                                0,
                                          });
                                        });
                                        Navigator.pop(context);
                                      }
                                      : null,
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
                              child: const Text('ДОБАВИТЬ'),
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

  void _addEquipment() {
    if (_equipmentNameController.text.trim().isNotEmpty) {
      setState(() {
        _equipment.add({
          'name': _equipmentNameController.text.trim(),
          'weight': int.tryParse(_equipmentWeightController.text) ?? 0,
        });
        _equipmentNameController.clear();
        _equipmentWeightController.clear();
      });
    }
  }

  void _removeEquipment(int index) {
    setState(() {
      _equipment.removeAt(index);
    });
  }

  Widget _buildEquipmentRow(Map<String, dynamic> equipment, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              equipment['name'],
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${equipment['weight']} фн',
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _removeEquipment(index),
            icon: const Icon(Icons.delete, color: Colors.red, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadCard(String title, int value, String unit) {
    // Вычисляем общий вес снаряжения
    int totalWeight = 0;
    for (var equipment in _equipment) {
      totalWeight += (equipment['weight'] as int?) ?? 0;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '$value/$totalWeight $unit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, int value, String unit) {
    // Вычисляем общий вес снаряжения
    int totalWeight = 0;
    for (var equipment in _equipment) {
      totalWeight += (equipment['weight'] as int?) ?? 0;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '$value/$totalWeight $unit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getWeightColor(int weight) {
    if (weight == 0) return Colors.grey;
    if (weight <= 10) return Colors.green;
    if (weight <= 25) return Colors.orange;
    if (weight <= 50) return Colors.red;
    return Colors.black;
  }

  Widget _buildCurrencyCard(String code, int value, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: Column(
        children: [
          Text(
            code,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _editCurrency(code),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.edit, color: Colors.grey, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showLoadEditModal() {
    // Вычисляем общий вес снаряжения
    int totalWeight = 0;
    for (var equipment in _equipment) {
      totalWeight += (equipment['weight'] as int?) ?? 0;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.80,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Редактировать лимиты веса',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Общий вес
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF4A4A4A),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'ТЕКУЩИЙ ВЕС СНАРЯЖЕНИЯ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$totalWeight фн',
                              style: const TextStyle(
                                color: Color(0xFF00FF00),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Карточки нагрузки
                      Text(
                        'ЛИМИТЫ НАГРУЗКИ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildEditableLoadCard(
                              'ЛЕГКАЯ',
                              _lightLoad,
                              (value) {
                                _lightLoad = value;
                                setModalState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildEditableLoadCard(
                              'СРЕДНЯЯ',
                              _mediumLoad,
                              (value) {
                                _mediumLoad = value;
                                setModalState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildEditableLoadCard(
                              'ТЯЖЕЛАЯ',
                              _heavyLoad,
                              (value) {
                                _heavyLoad = value;
                                setModalState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Карточки действий
                      Text(
                        'ЛИМИТЫ ДЕЙСТВИЙ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          _buildEditableActionCard(
                            'ПОДНЯТЬ НАД ГОЛОВОЙ',
                            _liftOverHead,
                            (value) {
                              _liftOverHead = value;
                              setModalState(() {});
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildEditableActionCard(
                            'ОТОРВАТЬ ОТ ЗЕМЛИ',
                            _liftOffGround,
                            (value) {
                              _liftOffGround = value;
                              setModalState(() {});
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildEditableActionCard(
                            'ТОЛКАТЬ ИЛИ ВОЛОЧЬ',
                            _pushOrDrag,
                            (value) {
                              _pushOrDrag = value;
                              setModalState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Кнопки
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: () {
                                setState(() {
                                  // Значения уже обновлены через setModalState
                                });
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
                              child: const Text('СОХРАНИТЬ'),
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

  Widget _buildEditableLoadCard(
    String title,
    int value,
    Function(int) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: Column(
        children: [
          Text(
            '$title НАГРУЗКА',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _editLoadValue(title, value, onChanged),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$value фн',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.edit, color: Colors.grey, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableActionCard(
    String title,
    int value,
    Function(int) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _editLoadValue(title, value, onChanged),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$value фн',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.edit, color: Colors.grey, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editLoadValue(String title, int currentValue, Function(int) onChanged) {
    final TextEditingController controller = TextEditingController(
      text: currentValue.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: Text(
              'Редактировать $title',
              style: const TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Введите лимит в фунтах',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: const Color(0xFF3A3A3A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF5B2333)),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'ОТМЕНА',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newValue = int.tryParse(controller.text) ?? 0;
                  onChanged(newValue);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B2333),
                  foregroundColor: Colors.white,
                ),
                child: const Text('СОХРАНИТЬ'),
              ),
            ],
          ),
    );
  }

  void _editCurrency(String code) {
    int currentValue = 0;
    switch (code) {
      case 'ММ':
        currentValue = _copperCoins;
        break;
      case 'СМ':
        currentValue = _silverCoins;
        break;
      case 'ЗМ':
        currentValue = _goldCoins;
        break;
      case 'ПМ':
        currentValue = _platinumCoins;
        break;
    }

    final TextEditingController controller = TextEditingController(
      text: currentValue.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: Text(
              'Редактировать $code',
              style: const TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Введите количество',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: const Color(0xFF3A3A3A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF5B2333)),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'ОТМЕНА',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newValue = int.tryParse(controller.text) ?? 0;
                  setState(() {
                    switch (code) {
                      case 'ММ':
                        _copperCoins = newValue;
                        break;
                      case 'СМ':
                        _silverCoins = newValue;
                        break;
                      case 'ЗМ':
                        _goldCoins = newValue;
                        break;
                      case 'ПМ':
                        _platinumCoins = newValue;
                        break;
                    }
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B2333),
                  foregroundColor: Colors.white,
                ),
                child: const Text('СОХРАНИТЬ'),
              ),
            ],
          ),
    );
  }

  void _addAbility() {
    if (_abilityController.text.trim().isNotEmpty) {
      setState(() {
        _abilities.add(_abilityController.text.trim());
        _abilityController.clear();
      });
    }
  }

  void _removeAbility(int index) {
    setState(() {
      _abilities.removeAt(index);
    });
  }

  Widget _buildAbilityItem(String ability, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ability,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          IconButton(
            onPressed: () => _removeAbility(index),
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  void _addTrait() {
    if (_traitController.text.trim().isNotEmpty) {
      setState(() {
        _traits.add(_traitController.text.trim());
        _traitController.clear();
      });
    }
  }

  void _removeTrait(int index) {
    setState(() {
      _traits.removeAt(index);
    });
  }

  Widget _buildTraitItem(String trait, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              trait,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          IconButton(
            onPressed: () => _removeTrait(index),
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
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

          // Характеристики секциями в сетке 3x2
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.8,
            children: [
              _buildAbilitySection(
                'СИЛ',
                _currentHero.strength,
                _currentHero.tempStrength,
              ),
              _buildAbilitySection(
                'ЛВК',
                _currentHero.dexterity,
                _currentHero.tempDexterity,
              ),
              _buildAbilitySection(
                'ВЫН',
                _currentHero.constitution,
                _currentHero.tempConstitution,
              ),
              _buildAbilitySection(
                'ИНТ',
                _currentHero.intelligence,
                _currentHero.tempIntelligence,
              ),
              _buildAbilitySection(
                'МДР',
                _currentHero.wisdom,
                _currentHero.tempWisdom,
              ),
              _buildAbilitySection(
                'ХАР',
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

          // Испытания в сетке 3x1
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 2.5,
            children: [
              _buildSaveSection(
                'СТОЙ',
                _currentHero.constitution,
                _currentHero.tempConstitution,
                _currentHero.tempFortitude,
                _currentHero.miscFortitude,
                _currentHero.magicFortitude,
              ),
              _buildSaveSection(
                'РЕАК',
                _currentHero.dexterity,
                _currentHero.tempDexterity,
                _currentHero.tempReflex,
                _currentHero.miscReflex,
                _currentHero.magicReflex,
              ),
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

          // Защита в сетке 3x1
          Row(
            children: [
              Expanded(
                child: _buildDefenseSection(
                  'КБ',
                  _currentHero.dexterity,
                  _currentHero.tempDexterity,
                  _currentHero.armorBonus ?? 0,
                  _currentHero.shieldBonus ?? 0,
                  _currentHero.naturalArmor ?? 0,
                  _currentHero.deflectionBonus ?? 0,
                  _currentHero.miscACBonus ?? 0,
                  _currentHero.sizeModifier ?? 0,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDefenseSection(
                  'КАСАНИЕ',
                  _currentHero.dexterity,
                  _currentHero.tempDexterity,
                  0, // без брони
                  0, // без щита
                  _currentHero.naturalArmor ?? 0,
                  _currentHero.deflectionBonus ?? 0,
                  _currentHero.miscACBonus ?? 0,
                  _currentHero.sizeModifier ?? 0,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDefenseSection(
                  'ВРАСПЛОХ',
                  null, // без ловкости
                  null,
                  _currentHero.armorBonus ?? 0,
                  _currentHero.shieldBonus ?? 0,
                  _currentHero.naturalArmor ?? 0,
                  _currentHero.deflectionBonus ?? 0,
                  _currentHero.miscACBonus ?? 0,
                  _currentHero.sizeModifier ?? 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSpellResistanceSection(_currentHero.spellResistance),
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

          GestureDetector(
            onTap: () => _showInitiativeEditModal(context),
            child: _buildInitiativeSection(
              _currentHero.dexterity,
              _currentHero.tempDexterity,
              _currentHero.miscInitiativeBonus,
            ),
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
          ...List.generate(_skills.length, (index) {
            return _buildSkillRow(_skills[index], index);
          }),
          const SizedBox(height: 20),
          // Кнопка добавления своего навыка
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showAddCustomSkillModal(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B2333),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'ДОБАВИТЬ СВОЙ НАВЫК',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
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

      // Навыки исполнения (только 2)
      SkillData(
        name: 'ИСПОЛНЕНИЕ (ПЕНИЕ)',
        ability: 'ХАР',
        hero: _currentHero,
        skillValue: 'Пение',
      ),
      SkillData(
        name: 'ИСПОЛНЕНИЕ (ТАНЕЦ)',
        ability: 'ХАР',
        hero: _currentHero,
        skillValue: 'Танец',
      ),

      // Профессия (только 2)
      SkillData(
        name: 'ПРОФЕССИЯ (ПОВАР)',
        ability: 'МДР',
        hero: _currentHero,
        skillValue: 'Повар',
      ),
      SkillData(
        name: 'ПРОФЕССИЯ (ПИСАРЬ)',
        ability: 'МДР',
        hero: _currentHero,
        skillValue: 'Писарь',
      ),

      // Ремесло (только 3)
      SkillData(
        name: 'РЕМЕСЛО (КУЗНЕЧНОЕ ДЕЛО)',
        ability: 'ИНТ',
        hero: _currentHero,
        skillValue: 'Кузнечное дело',
      ),
      SkillData(
        name: 'РЕМЕСЛО (СТОЛЯРНОЕ ДЕЛО)',
        ability: 'ИНТ',
        hero: _currentHero,
        skillValue: 'Столярное дело',
      ),
      SkillData(
        name: 'РЕМЕСЛО (АЛХИМИЯ)',
        ability: 'ИНТ',
        hero: _currentHero,
        skillValue: 'Алхимия',
      ),
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
    return GestureDetector(
      onTap: () => _showSkillEditModal(skill, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              skill.isClassSkill
                  ? const Color(0xFF3A2A2A)
                  : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
        ),
        child: Row(
          children: [
            // Чекбокс
            GestureDetector(
              onTap: () {
                setState(() {
                  _skills[index] = skill.copyWith(
                    isClassSkill: !skill.isClassSkill,
                  );
                });
              },
              child: Container(
                width: 16,
                height: 16,
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
                  borderRadius: BorderRadius.circular(3),
                ),
                child:
                    skill.isClassSkill
                        ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        )
                        : null,
              ),
            ),
            const SizedBox(width: 8),
            // Название и звездочка
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      skill.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (skill.requiresStudy)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.star, color: Colors.red, size: 14),
                    ),
                ],
              ),
            ),
            // Итоговое значение
            Container(
              width: 40,
              alignment: Alignment.centerRight,
              child: Text(
                '${skill.total >= 0 ? '+' : ''}${skill.total}',
                style: const TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSkillEditModal(SkillData skill, int index) {
    int points = skill.points;
    int bonus = skill.bonus;
    String skillValue = skill.skillValue;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              final modifier = skill.modifier;
              final total = modifier + points + bonus;
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Редактирование: ${skill.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Поле для значения навыка (только для Исполнение, Профессия, Ремесло)
                      if (skill.name.startsWith('ИСПОЛНЕНИЕ') ||
                          skill.name.startsWith('ПРОФЕССИЯ') ||
                          skill.name.startsWith('РЕМЕСЛО'))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Значение:',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: TextEditingController(
                                text: skillValue,
                              ),
                              onChanged: (value) {
                                skillValue = value;
                                setModalState(() {});
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Введите значение...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF5B2333),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildEditableValueCard(
                              'Очки',
                              points.toString(),
                              (newValue) {
                                points = newValue;
                                setModalState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildEditableValueCard(
                              'Бонус',
                              bonus.toString(),
                              (newValue) {
                                bonus = newValue;
                                setModalState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Формула
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '=',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              skill.ability,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${modifier >= 0 ? '+' : ''}$modifier',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('+', style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 4),
                            Text(
                              '$points',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('+', style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 4),
                            Text(
                              '$bonus',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '=',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${total >= 0 ? '+' : ''}$total',
                              style: const TextStyle(
                                color: Color(0xFF00FF00),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: () {
                                setState(() {
                                  _skills[index] = skill.copyWith(
                                    points: points,
                                    bonus: bonus,
                                    skillValue: skillValue,
                                  );
                                });
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
                              child: const Text('СОХРАНИТЬ'),
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

  int _getAbilityValue(String ability) {
    switch (ability) {
      case 'СИЛ':
        return _currentHero.strength;
      case 'ЛВК':
        return _currentHero.dexterity;
      case 'ТЕЛ':
        return _currentHero.constitution;
      case 'ИНТ':
        return _currentHero.intelligence;
      case 'МДР':
        return _currentHero.wisdom;
      case 'ХАР':
        return _currentHero.charisma;
      default:
        return 10;
    }
  }

  void _showAddCustomSkillModal() {
    String skillName = '';
    String ability = 'СИЛ';
    String skillValue = '';
    int points = 0;
    int bonus = 0;
    bool isClassSkill = false;
    bool requiresStudy = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              final modifier = _calculateModifier(_getAbilityValue(ability));
              final total = modifier + points + bonus;

              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Добавить свой навык',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Название навыка
                      Text(
                        'Название навыка:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          skillName = value;
                          setModalState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Введите название навыка...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF2A2A2A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF5B2333),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Характеристика
                      Text(
                        'Характеристика:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: ability,
                          onChanged: (newValue) {
                            ability = newValue!;
                            setModalState(() {});
                          },
                          dropdownColor: const Color(0xFF2A2A2A),
                          style: const TextStyle(color: Colors.white),
                          underline: Container(),
                          items:
                              ['СИЛ', 'ЛВК', 'ТЕЛ', 'ИНТ', 'МДР', 'ХАР'].map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Значение навыка (опционально)
                      Text(
                        'Значение (опционально):',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          skillValue = value;
                          setModalState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Например: Пение, Кузнечное дело...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF2A2A2A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF5B2333),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Очки и бонус
                      Row(
                        children: [
                          Expanded(
                            child: _buildEditableValueCard(
                              'Очки',
                              points.toString(),
                              (newValue) {
                                points = newValue;
                                setModalState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildEditableValueCard(
                              'Бонус',
                              bonus.toString(),
                              (newValue) {
                                bonus = newValue;
                                setModalState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Чекбоксы
                      Row(
                        children: [
                          Expanded(
                            child: Row(
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
                                  'Классовый навык',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: requiresStudy,
                                  onChanged: (value) {
                                    requiresStudy = value ?? false;
                                    setModalState(() {});
                                  },
                                  activeColor: const Color(0xFF5B2333),
                                ),
                                const Text(
                                  'Требует изучения',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Формула
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '=',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ability,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${modifier >= 0 ? '+' : ''}$modifier',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('+', style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 4),
                            Text(
                              '$points',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('+', style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 4),
                            Text(
                              '$bonus',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '=',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${total >= 0 ? '+' : ''}$total',
                              style: const TextStyle(
                                color: Color(0xFF00FF00),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Кнопки
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
                                  skillName.isNotEmpty
                                      ? () {
                                        setState(() {
                                          _skills.add(
                                            SkillData(
                                              name: skillName.toUpperCase(),
                                              ability: ability,
                                              points: points,
                                              bonus: bonus,
                                              skillValue: skillValue,
                                              isClassSkill: isClassSkill,
                                              requiresStudy: requiresStudy,
                                              hero: _currentHero,
                                            ),
                                          );
                                        });
                                        Navigator.pop(context);
                                      }
                                      : null,
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
                              child: const Text('ДОБАВИТЬ'),
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

  Widget _buildInventoryTab() {
    // Вычисляем общий вес снаряжения
    int totalWeight = 0;
    for (var equipment in _equipment) {
      totalWeight += (equipment['weight'] as int?) ?? 0;
    }

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

          // Секция СНАРЯЖЕНИЕ
          Container(
            width: double.infinity,
            child: const Text(
              'СНАРЯЖЕНИЕ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 12),

          // Таблица снаряжения
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
            ),
            child: Column(
              children: [
                // Строки снаряжения
                ...List.generate(_equipment.length, (index) {
                  return _buildEquipmentRow(_equipment[index], index);
                }),
                // Кнопка добавления (всегда отображается)
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _showAddEquipmentModal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B2333),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 16),
                          SizedBox(width: 8),
                          Text('ДОБАВИТЬ'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Секция ОБЩИЙ ВЕС
          Container(
            width: double.infinity,
            child: const Text(
              'ОБЩИЙ ВЕС',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 12),

          // Карточка общего веса (кликабельная)
          GestureDetector(
            onTap: _showLoadEditModal,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF4A4A4A), width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    'ОБЩИЙ ВЕС',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$totalWeight фн',
                    style: TextStyle(
                      color: _getWeightColor(totalWeight),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.grey.withOpacity(0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Нажмите для редактирования',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Секция ДЕНЬГИ
          Container(
            width: double.infinity,
            child: const Text(
              'ДЕНЬГИ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 12),

          // Карточки валют
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildCurrencyCard(
                      'ММ',
                      _copperCoins,
                      'Медные монеты',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCurrencyCard(
                      'СМ',
                      _silverCoins,
                      'Серебряные монеты',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildCurrencyCard(
                      'ЗМ',
                      _goldCoins,
                      'Золотые монеты',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCurrencyCard(
                      'ПМ',
                      _platinumCoins,
                      'Платиновые монеты',
                    ),
                  ),
                ],
              ),
            ],
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

          // To-do лист для способностей
          Column(
            children: [
              // Поле для добавления новой способности
              Column(
                children: [
                  TextField(
                    controller: _abilityController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Добавить новую способность...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF3A3A3A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5B2333)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _addAbility,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B2333),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 20),
                            SizedBox(width: 8),
                            Text('ДОБАВИТЬ'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Список способностей
              ...List.generate(_abilities.length, (index) {
                return _buildAbilityItem(_abilities[index], index);
              }),
              const SizedBox(height: 24),

              // Заголовок секции черт
              Container(
                width: double.infinity,
                child: const Text(
                  'ЧЕРТЫ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 16),

              // Поле для добавления новой черты
              Column(
                children: [
                  TextField(
                    controller: _traitController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Добавить новую черту...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF3A3A3A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5B2333)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _addTrait,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B2333),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 20),
                            SizedBox(width: 8),
                            Text('ДОБАВИТЬ'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Список черт
              ...List.generate(_traits.length, (index) {
                return _buildTraitItem(_traits[index], index);
              }),
            ],
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

  Widget _buildFormulaCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
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

  int _calculateModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  Widget _buildAbilitySection(String name, int baseValue, int? tempValue) {
    final baseModifier = _calculateModifier(baseValue);
    final tempModifier =
        tempValue != null ? _calculateModifier(tempValue) : baseModifier;

    // Определяем какие данные использовать для отображения
    final displayValue = tempValue ?? baseValue;
    final displayModifier = tempModifier;

    // Иконки для каждой характеристики
    IconData getAbilityIcon(String abilityName) {
      switch (abilityName) {
        case 'СИЛ':
          return Icons.fitness_center;
        case 'ЛВК':
          return Icons.directions_run;
        case 'ВЫН':
          return Icons.favorite;
        case 'ИНТ':
          return Icons.psychology;
        case 'МДР':
          return Icons.lightbulb;
        case 'ХАР':
          return Icons.face;
        default:
          return Icons.star;
      }
    }

    return GestureDetector(
      onTap: () => _showAbilityEditModal(name, baseValue, tempValue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
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
            // Левая часть: иконка и название
            Row(
              children: [
                Icon(
                  getAbilityIcon(name),
                  color:
                      tempValue != null
                          ? const Color(0xFFFFD700)
                          : Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Правая часть: модификатор
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${displayModifier >= 0 ? '+' : ''}$displayModifier',
                  style: TextStyle(
                    color:
                        tempValue != null
                            ? const Color(0xFFFFD700)
                            : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (tempValue != null)
                  Text(
                    '($displayValue)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ],
        ),
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
        tempAbility != null ? _calculateModifier(tempAbility!) : baseModifier;

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

    return GestureDetector(
      onTap:
          () => _showSaveEditModal(
            name,
            baseAbility,
            tempAbility,
            tempSave,
            miscSave,
            magicSave,
          ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
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
            // Левая часть: название и иконка
            Row(
              children: [
                Icon(
                  _getSaveIcon(name),
                  color: Colors.white.withOpacity(0.8),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Правая часть: итоговый бонус
            Text(
              '${totalBonus >= 0 ? '+' : ''}$totalBonus',
              style: const TextStyle(
                color: Color(0xFF00FF00),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSaveIcon(String saveName) {
    switch (saveName) {
      case 'СТОЙ':
        return Icons.favorite;
      case 'РЕАК':
        return Icons.flash_on;
      case 'ВОЛЯ':
        return Icons.psychology;
      default:
        return Icons.shield;
    }
  }

  Widget _buildSpeedCard(String name, int? speed, String unit) {
    final speedValue = speed ?? 0;
    final cells = (speedValue / 5).floor(); // 1 клетка = 5 футов

    return GestureDetector(
      onTap: () => _showSpeedEditModal(name, speedValue, unit),
      child: Container(
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

    // Только КБ можно редактировать
    if (name == 'КБ') {
      return GestureDetector(
        onTap:
            () => _showDefenseEditModal(
              name,
              armorBonus ?? 0,
              shieldBonus ?? 0,
              naturalArmor ?? 0,
              deflectionBonus ?? 0,
              miscACBonus ?? 0,
              sizeModifier ?? 0,
            ),
        child: Container(
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
        ),
      );
    } else {
      // КАСАНИЕ и ВРАСПЛОХ - только для отображения
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
      );
    }
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
                  'ЛВК',
                  tempModifier != null
                      ? '${tempModifier >= 0 ? '+' : ''}$tempModifier'
                      : '${dexterityModifier >= 0 ? '+' : ''}$dexterityModifier',
                  tempModifier != null ? const Color(0xFFFFD700) : Colors.white,
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
        GestureDetector(
          onTap: () => _showBMAEditModal(context),
          child: Container(
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
        ),
        const SizedBox(height: 8),
        // МБМ карточка
        GestureDetector(
          onTap:
              () => _showMBMFormulaModal(
                context,
                baseAttackBonus,
                tempStrengthModifier,
                sizeModifier,
              ),
          child: Container(
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
          ),
        ),
        const SizedBox(height: 8),
        // ЗБМ карточка
        GestureDetector(
          onTap:
              () => _showZBMFormulaModal(
                context,
                baseAttackBonus,
                tempStrengthModifier,
                tempDexterityModifier,
                sizeModifier,
              ),
          child: Container(
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

  void _showAbilityEditModal(
    String abilityName,
    int baseValue,
    int? tempValue,
  ) {
    // Создаем переменные состояния вне StatefulBuilder
    int currentBaseValue = baseValue;
    int? currentTempValue = tempValue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              // Вычисляем модификаторы
              final baseModifier = _calculateModifier(currentBaseValue);
              final tempModifier =
                  currentTempValue != null
                      ? _calculateModifier(currentTempValue!)
                      : null;

              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Редактирование: $abilityName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Интерактивные карточки
                      Container(
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
                                      currentTempValue =
                                          newValue == -1 ? null : newValue;
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
                      ),
                      const SizedBox(height: 20),

                      // Кнопки
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: () {
                                // Обновляем героя
                                _updateHeroAbility(
                                  abilityName,
                                  currentBaseValue,
                                  currentTempValue,
                                );
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
                              child: const Text('СОХРАНИТЬ'),
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

  void _showSaveEditModal(
    String saveName,
    int baseAbility,
    int? tempAbility,
    int? tempSave,
    int? miscSave,
    int? magicSave,
  ) {
    // Создаем переменные состояния вне StatefulBuilder
    int currentTempSave = tempSave ?? 0;
    int currentMiscSave = miscSave ?? 0;
    int currentMagicSave = magicSave ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              // Вычисляем модификаторы
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
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Редактирование: $saveName',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Текущие значения
                        Container(
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
                                    child: _buildValueDisplay(
                                      'Базовый бонус',
                                      '$baseBonus',
                                    ),
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
                                    child: _buildEditableValueCard(
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
                                    child: _buildEditableValueCard(
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
                                    child: _buildEditableValueCard(
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
                        ),
                        const SizedBox(height: 20),

                        const SizedBox(height: 20),

                        // Кнопки
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
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
                                onPressed: () {
                                  // Обновляем героя
                                  _updateHeroSave(
                                    saveName,
                                    currentTempSave,
                                    currentMiscSave,
                                    currentMagicSave,
                                  );
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
                                child: const Text('СОХРАНИТЬ'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
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

  void _showSpeedEditModal(String speedName, int currentSpeed, String unit) {
    int speedValue = currentSpeed;
    int cellsValue = (speedValue / 5).floor();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Редактирование: $speedName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Текущие значения
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Значения (нажмите для редактирования)',
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
                                    'Футы',
                                    '$speedValue $unit',
                                    (newValue) {
                                      speedValue = newValue;
                                      cellsValue = (speedValue / 5).floor();
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildEditableValueCard(
                                    'Клетки',
                                    '$cellsValue',
                                    (newValue) {
                                      cellsValue = newValue;
                                      speedValue = cellsValue * 5;
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Кнопки
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: () {
                                _updateHeroSpeed(speedName, speedValue);
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
                              child: const Text('СОХРАНИТЬ'),
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

  void _updateHeroSpeed(String speedName, int newSpeed) {
    setState(() {
      switch (speedName) {
        case 'БЕЗ БРОНИ':
          _currentHero.baseSpeed = newSpeed;
          break;
        case 'В БРОНЕ':
          _currentHero.armorSpeed = newSpeed;
          break;
        case 'ПОЛЕТ':
          _currentHero.flySpeed = newSpeed;
          break;
        case 'ПЛАВАНИЕ':
          _currentHero.swimSpeed = newSpeed;
          break;
        case 'ЛАЗАНИЕ':
          _currentHero.climbSpeed = newSpeed;
          break;
        case 'РЫТЬЕ':
          _currentHero.burrowSpeed = newSpeed;
          break;
      }
    });
  }

  void _showDefenseEditModal(
    String defenseName,
    int currentArmorBonus,
    int currentShieldBonus,
    int currentNaturalArmor,
    int currentDeflectionBonus,
    int currentMiscACBonus,
    int currentSizeModifier,
  ) {
    int armorBonus = currentArmorBonus;
    int shieldBonus = currentShieldBonus;
    int naturalArmor = currentNaturalArmor;
    int deflectionBonus = currentDeflectionBonus;
    int miscACBonus = currentMiscACBonus;
    int sizeModifier = currentSizeModifier;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Редактирование: $defenseName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Текущие значения
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Значения (нажмите для редактирования)',
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
                                    'Броня',
                                    '$armorBonus',
                                    (newValue) {
                                      armorBonus = newValue;
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildEditableValueCard(
                                    'Щит',
                                    '$shieldBonus',
                                    (newValue) {
                                      shieldBonus = newValue;
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
                                  child: _buildEditableValueCard(
                                    'Естественная',
                                    '$naturalArmor',
                                    (newValue) {
                                      naturalArmor = newValue;
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildEditableValueCard(
                                    'Отражение',
                                    '$deflectionBonus',
                                    (newValue) {
                                      deflectionBonus = newValue;
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
                                  child: _buildEditableValueCard(
                                    'Прочий',
                                    '$miscACBonus',
                                    (newValue) {
                                      miscACBonus = newValue;
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildEditableValueCard(
                                    'Размер',
                                    '$sizeModifier',
                                    (newValue) {
                                      sizeModifier = newValue;
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Базовые значения и формула
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Формула расчета КБ',
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
                                  child: _buildFormulaCard(
                                    'Базовая КБ + ЛВК',
                                    '10 + ${_calculateModifier(_currentHero.dexterity)}',
                                    Colors.blue,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ИТОГО КБ:',
                                    style: const TextStyle(
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
                      const SizedBox(height: 20),

                      // Кнопки
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: () {
                                _updateHeroDefense(
                                  defenseName,
                                  armorBonus,
                                  shieldBonus,
                                  naturalArmor,
                                  deflectionBonus,
                                  miscACBonus,
                                  sizeModifier,
                                );
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
                              child: const Text('СОХРАНИТЬ'),
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

  void _updateHeroDefense(
    String defenseName,
    int armorBonus,
    int shieldBonus,
    int naturalArmor,
    int deflectionBonus,
    int miscACBonus,
    int sizeModifier,
  ) {
    setState(() {
      // Для всех типов защиты используем одни и те же поля
      // так как в модели нет отдельных полей для touch и flat-footed
      _currentHero.armorBonus = armorBonus;
      _currentHero.shieldBonus = shieldBonus;
      _currentHero.naturalArmor = naturalArmor;
      _currentHero.deflectionBonus = deflectionBonus;
      _currentHero.miscACBonus = miscACBonus;
      _currentHero.sizeModifier = sizeModifier;
    });
  }

  void _showEditModal({
    required String title,
    required List<EditField> fields,
    required Function(Map<String, dynamic>) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              // Создаем контроллеры для каждого поля
              final controllers = <String, TextEditingController>{};
              final values = <String, dynamic>{};

              for (final field in fields) {
                controllers[field.key] = TextEditingController(
                  text: field.value?.toString() ?? '',
                );
                values[field.key] = field.value;
              }

              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Текущие значения
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Значения (нажмите для редактирования)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...fields.map(
                              (field) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildValueDisplay(
                                  field.label,
                                  field.displayValue ??
                                      field.value?.toString() ??
                                      '-',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Поля для редактирования
                      if (fields.any((field) => field.isEditable)) ...[
                        Text(
                          'Редактирование',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Поля ввода
                        ...fields
                            .where((field) => field.isEditable)
                            .map(
                              (field) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildEditField(
                                  field.label,
                                  controllers[field.key]!,
                                  field.hint,
                                ),
                              ),
                            ),
                      ],

                      const SizedBox(height: 20),

                      // Кнопки
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: () {
                                // Собираем значения из контроллеров
                                final result = <String, dynamic>{};
                                for (final field in fields) {
                                  if (field.isEditable) {
                                    final value = int.tryParse(
                                      controllers[field.key]!.text,
                                    );
                                    result[field.key] = value ?? field.value;
                                  } else {
                                    result[field.key] = field.value;
                                  }
                                }
                                onSave(result);
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
                              child: const Text('СОХРАНИТЬ'),
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

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
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
              color: Colors.white.withOpacity(0.7),
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
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Введите значение',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.edit,
                  size: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInitiativeEditModal(BuildContext context) {
    int miscInitiativeBonus = _currentHero.miscInitiativeBonus ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Редактирование: Инициатива',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

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
                                  child: _buildFormulaCard(
                                    'ЛВК + Прочий',
                                    '${_calculateModifier(_currentHero.dexterity)} + $miscInitiativeBonus',
                                    Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
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
                                  '${_calculateModifier(_currentHero.dexterity) + miscInitiativeBonus >= 0 ? '+' : ''}${_calculateModifier(_currentHero.dexterity) + miscInitiativeBonus}',
                                  style: const TextStyle(
                                    color: Color(0xFF00FF00),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Поля для редактирования
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
                            Row(
                              children: [
                                Expanded(
                                  child: _buildEditableValueCard(
                                    'Прочий бонус',
                                    '$miscInitiativeBonus',
                                    (newValue) {
                                      miscInitiativeBonus = newValue;
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Кнопки
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A2A2A),
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
                              onPressed: () {
                                // Обновляем героя
                                setState(() {
                                  _currentHero.miscInitiativeBonus =
                                      miscInitiativeBonus;
                                });
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
                              child: const Text('СОХРАНИТЬ'),
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

  void _showBMAEditModal(BuildContext context) {
    int baseAttackBonus = _currentHero.baseAttackBonus ?? 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Редактирование: БМА',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildEditableValueCard('БМА', '$baseAttackBonus', (
                        newValue,
                      ) {
                        baseAttackBonus = newValue;
                        setModalState(() {});
                      }),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A2A2A),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('ОТМЕНА'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentHero.baseAttackBonus =
                                      baseAttackBonus;
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B2333),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('СОХРАНИТЬ'),
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

  void _showMBMFormulaModal(
    BuildContext context,
    int? baseAttackBonus,
    int tempStrengthModifier,
    int? sizeModifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Формула расчета МБМ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          'МБМ = БМА + СИЛ + РАЗМ',
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
                              child: _buildFormulaCard(
                                'БМА',
                                '${baseAttackBonus ?? 0}',
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildFormulaCard(
                                'СИЛ',
                                '${tempStrengthModifier >= 0 ? '+' : ''}$tempStrengthModifier',
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildFormulaCard(
                                'РАЗМ',
                                '${sizeModifier ?? 0}',
                                Colors.cyan,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Итоговое значение:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${(baseAttackBonus ?? 0) + tempStrengthModifier + (sizeModifier ?? 0) >= 0 ? '+' : ''}${(baseAttackBonus ?? 0) + tempStrengthModifier + (sizeModifier ?? 0)}',
                              style: const TextStyle(
                                color: Color(0xFF00FF00),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showZBMFormulaModal(
    BuildContext context,
    int? baseAttackBonus,
    int tempStrengthModifier,
    int tempDexterityModifier,
    int? sizeModifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Формула расчета ЗБМ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          'ЗБМ = БМА + СИЛ + ЛВК + РАЗМ + 10',
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
                              child: _buildFormulaCard(
                                'БМА',
                                '${baseAttackBonus ?? 0}',
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildFormulaCard(
                                'СИЛ',
                                '${tempStrengthModifier >= 0 ? '+' : ''}$tempStrengthModifier',
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildFormulaCard(
                                'ЛВК',
                                '${tempDexterityModifier >= 0 ? '+' : ''}$tempDexterityModifier',
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildFormulaCard(
                                'РАЗМ',
                                '${sizeModifier ?? 0}',
                                Colors.cyan,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildFormulaCard(
                                '+10',
                                '10',
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Итоговое значение:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${(baseAttackBonus ?? 0) + tempStrengthModifier + (sizeModifier ?? 0) >= 0 ? '+' : ''}${(baseAttackBonus ?? 0) + tempStrengthModifier + (sizeModifier ?? 0)}',
                              style: const TextStyle(
                                color: Color(0xFF00FF00),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
