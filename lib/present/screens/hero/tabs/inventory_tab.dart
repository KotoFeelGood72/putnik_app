import 'package:flutter/material.dart';
import '../../../components/cards/card_value.dart';
import '../../../components/head/section_head_info.dart';
import '../../../components/inputs/custom_bottom_sheet_select.dart';
import '../../../../models/weapon_model.dart';
import '../../../../models/armor_model.dart';
import '../../../../models/equipment_model.dart';

class InventoryTab extends StatefulWidget {
  final List<Map<String, dynamic>> equipment;
  final List<Map<String, dynamic>> weapons;
  final List<Map<String, dynamic>> armors;
  final List<Map<String, dynamic>> goods;
  final List<WeaponModel> allWeapons;
  final List<ArmorModel> allArmors;
  final int copperCoins;
  final int silverCoins;
  final int goldCoins;
  final int platinumCoins;
  final VoidCallback onShowAddEquipmentModal;
  final VoidCallback onShowLoadEditModal;
  final Function(int) onRemoveEquipment;
  final Function(String) onEditCurrency;
  final Function(List<Map<String, dynamic>>)? onEquipmentChanged;
  final Function(List<Map<String, dynamic>>)? onWeaponsChanged;
  final Function(List<Map<String, dynamic>>)? onArmorsChanged;
  final Function(List<Map<String, dynamic>>)? onGoodsChanged;

  const InventoryTab({
    super.key,
    required this.equipment,
    required this.weapons,
    required this.armors,
    required this.goods,
    required this.allWeapons,
    required this.allArmors,
    required this.copperCoins,
    required this.silverCoins,
    required this.goldCoins,
    required this.platinumCoins,
    required this.onShowAddEquipmentModal,
    required this.onShowLoadEditModal,
    required this.onRemoveEquipment,
    required this.onEditCurrency,
    this.onEquipmentChanged,
    this.onWeaponsChanged,
    this.onArmorsChanged,
    this.onGoodsChanged,
  });

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  List<EquipmentModel> _selectedEquipment = [];
  String _search = '';
  String _selectedType = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedEquipment();
  }

  @override
  void didUpdateWidget(InventoryTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.equipment != widget.equipment ||
        oldWidget.weapons != widget.weapons ||
        oldWidget.armors != widget.armors ||
        oldWidget.goods != widget.goods) {
      _loadSelectedEquipment();
    }
  }

  void _loadSelectedEquipment() {
    _selectedEquipment = [];
    // Снаряжение
    for (final equipmentData in widget.equipment) {
      try {
        final equipment = EquipmentModel.fromJson(equipmentData);
        // Фильтруем пустые предметы
        if (equipment.name.isNotEmpty) {
          _selectedEquipment.add(equipment);
        }
      } catch (e) {
        final equipment = EquipmentModel(
          id:
              equipmentData['id']?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          name: equipmentData['name']?.toString() ?? '',
          weight:
              (equipmentData['weight'] is int)
                  ? (equipmentData['weight'] as int).toDouble()
                  : (equipmentData['weight'] is double)
                  ? equipmentData['weight'] as double
                  : 0.0,
          description: equipmentData['description']?.toString(),
          type: equipmentData['type']?.toString() ?? 'Снаряжение',
        );
        // Фильтруем пустые предметы
        if (equipment.name.isNotEmpty) {
          _selectedEquipment.add(equipment);
        }
      }
    }
    // Оружие
    for (final weaponData in widget.weapons) {
      final name = weaponData['name']?.toString() ?? '';
      // Фильтруем пустые предметы
      if (name.isNotEmpty) {
        final equipment = EquipmentModel(
          id:
              weaponData['id']?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          weight:
              (weaponData['weight'] is int)
                  ? (weaponData['weight'] as int).toDouble()
                  : (weaponData['weight'] is double)
                  ? weaponData['weight'] as double
                  : 0.0,
          description: weaponData['description']?.toString(),
          type: 'Оружие',
        );
        _selectedEquipment.add(equipment);
      }
    }
    // Доспехи
    for (final armorData in widget.armors) {
      final name = armorData['name']?.toString() ?? '';
      // Фильтруем пустые предметы
      if (name.isNotEmpty) {
        final equipment = EquipmentModel(
          id:
              armorData['id']?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          weight:
              (armorData['weight'] is int)
                  ? (armorData['weight'] as int).toDouble()
                  : (armorData['weight'] is double)
                  ? armorData['weight'] as double
                  : 0.0,
          description: armorData['description']?.toString(),
          type: 'Доспех',
        );
        _selectedEquipment.add(equipment);
      }
    }
    // Товары
    for (final goodData in widget.goods) {
      final name = goodData['name']?.toString() ?? '';
      // Фильтруем пустые предметы
      if (name.isNotEmpty) {
        final equipment = EquipmentModel(
          id:
              goodData['id']?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          weight:
              (goodData['weight'] is int)
                  ? (goodData['weight'] as int).toDouble()
                  : (goodData['weight'] is double)
                  ? goodData['weight'] as double
                  : 0.0,
          description: goodData['description']?.toString(),
          type: 'Товар',
        );
        _selectedEquipment.add(equipment);
      }
    }

    print('=== ЗАГРУЖЕНО ПРЕДМЕТОВ ===');
    print('Всего предметов: ${_selectedEquipment.length}');
    for (var item in _selectedEquipment) {
      print('- ${item.name} (${item.type}) - ${item.weight} фн');
    }
  }

  void _onRemoveEquipment(EquipmentModel equipment) {
    print('=== УДАЛЕНИЕ ПРЕДМЕТА ===');
    print('ID предмета: ${equipment.id}');
    print('Название: "${equipment.name}"');
    print('Тип: ${equipment.type}');
    print('Текущие weapons: ${widget.weapons.length}');
    print('Текущие armors: ${widget.armors.length}');
    print('Текущие goods: ${widget.goods.length}');
    print('Текущие equipment: ${widget.equipment.length}');

    // Удаляем из соответствующего списка героя через колбэки
    if (equipment.type == 'Оружие') {
      print('Удаляем оружие...');
      final newWeapons = List<Map<String, dynamic>>.from(
        widget.weapons,
      )..removeWhere((e) {
        final itemName = e['name']?.toString() ?? '';
        final itemWeight = e['weight'];
        final equipmentName = equipment.name;
        final equipmentWeight = equipment.weight;
        print(
          'Сравниваем оружие: "$itemName" (вес: $itemWeight) == "$equipmentName" (вес: $equipmentWeight)',
        );
        // Для пустых предметов сравниваем только по весу
        if (equipmentName.isEmpty) {
          return itemWeight == equipmentWeight;
        }
        return itemName == equipmentName && itemWeight == equipmentWeight;
      });
      print('Новый список оружия: ${newWeapons.length}');
      if (widget.onWeaponsChanged != null) {
        print('Вызываем onWeaponsChanged');
        widget.onWeaponsChanged!(newWeapons);
      } else {
        print('onWeaponsChanged is null!');
      }
    } else if (equipment.type == 'Доспех') {
      print('Удаляем доспех...');
      final newArmors = List<Map<String, dynamic>>.from(
        widget.armors,
      )..removeWhere((e) {
        final itemName = e['name']?.toString() ?? '';
        final itemWeight = e['weight'];
        final equipmentName = equipment.name;
        final equipmentWeight = equipment.weight;
        print(
          'Сравниваем доспех: "$itemName" (вес: $itemWeight) == "$equipmentName" (вес: $equipmentWeight)',
        );
        // Для пустых предметов сравниваем только по весу
        if (equipmentName.isEmpty) {
          return itemWeight == equipmentWeight;
        }
        return itemName == equipmentName && itemWeight == equipmentWeight;
      });
      print('Новый список доспехов: ${newArmors.length}');
      if (widget.onArmorsChanged != null) {
        print('Вызываем onArmorsChanged');
        widget.onArmorsChanged!(newArmors);
      } else {
        print('onArmorsChanged is null!');
      }
    } else if (equipment.type == 'Товар') {
      print('Удаляем товар...');
      final newGoods = List<Map<String, dynamic>>.from(
        widget.goods,
      )..removeWhere((e) {
        final itemName = e['name']?.toString() ?? '';
        final itemWeight = e['weight'];
        final equipmentName = equipment.name;
        final equipmentWeight = equipment.weight;
        print(
          'Сравниваем товар: "$itemName" (вес: $itemWeight) == "$equipmentName" (вес: $equipmentWeight)',
        );
        // Для пустых предметов сравниваем только по весу
        if (equipmentName.isEmpty) {
          return itemWeight == equipmentWeight;
        }
        return itemName == equipmentName && itemWeight == equipmentWeight;
      });
      print('Новый список товаров: ${newGoods.length}');
      if (widget.onGoodsChanged != null) {
        print('Вызываем onGoodsChanged');
        widget.onGoodsChanged!(newGoods);
      } else {
        print('onGoodsChanged is null!');
      }
    } else {
      print('Удаляем обычное снаряжение...');
      final newEquipment = List<Map<String, dynamic>>.from(widget.equipment)
        ..removeWhere((e) {
          final itemId = e['id']?.toString();
          final equipmentId = equipment.id;
          print('Сравниваем снаряжение: $itemId == $equipmentId');
          return itemId == equipmentId;
        });
      print('Новый список снаряжения: ${newEquipment.length}');
      if (widget.onEquipmentChanged != null) {
        print('Вызываем onEquipmentChanged');
        widget.onEquipmentChanged!(newEquipment);
      } else {
        print('onEquipmentChanged is null!');
      }
    }
    print('=== КОНЕЦ УДАЛЕНИЯ ===');
  }

  void _onAddEquipment(EquipmentModel equipment) {
    // Добавляем в список снаряжения героя через колбэк
    final newEquipment = List<Map<String, dynamic>>.from(widget.equipment)
      ..add(equipment.toJson());
    if (widget.onEquipmentChanged != null) {
      widget.onEquipmentChanged!(newEquipment);
    }
  }

  void _showAddCustomEquipmentModal() {
    final nameController = TextEditingController();
    final weightController = TextEditingController();
    final descriptionController = TextEditingController();
    final typeController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Добавить снаряжение',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: weightController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Вес (фн)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Описание (необязательно)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: typeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Тип (необязательно)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
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
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final weight =
                        double.tryParse(weightController.text) ?? 0.0;
                    final newEquipment = EquipmentModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      weight: weight,
                      description:
                          descriptionController.text.isEmpty
                              ? null
                              : descriptionController.text,
                      type:
                          typeController.text.isEmpty
                              ? null
                              : typeController.text,
                    );
                    _onAddEquipment(newEquipment);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B2333),
                  foregroundColor: Colors.white,
                ),
                child: const Text('ДОБАВИТЬ'),
              ),
            ],
          ),
    );
  }

  List<EquipmentModel> get _filteredEquipment {
    return _selectedEquipment.where((equipment) {
      final matchesType =
          _selectedType.isEmpty ||
          _selectedType == 'Мое снаряжение' ||
          (equipment.type ?? '').toLowerCase() == _selectedType.toLowerCase();
      final matchesSearch =
          _search.isEmpty ||
          equipment.name.toLowerCase().contains(_search.toLowerCase()) ||
          (equipment.description?.toLowerCase().contains(
                _search.toLowerCase(),
              ) ??
              false);
      return matchesType && matchesSearch;
    }).toList();
  }

  List<String> get _allTypes {
    final types =
        _selectedEquipment
            .map((e) => e.type ?? '')
            .where((t) => t.isNotEmpty)
            .toSet()
            .toList();
    types.sort();
    return types;
  }

  Widget _buildEquipmentCard(EquipmentModel equipment) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        equipment.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onPressed: () => _onRemoveEquipment(equipment),
                      tooltip: 'Убрать',
                    ),
                  ],
                ),
                if (equipment.description != null &&
                    equipment.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    equipment.description!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Вес: ${equipment.weight} фн',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                    if (equipment.type != null &&
                        equipment.type!.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Text(
                        equipment.type!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Вычисляем общий вес всех предметов
    double totalWeight = 0;
    for (var item in _selectedEquipment) {
      totalWeight += item.weight;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SingleChildScrollView(
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

            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Поиск снаряжения...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white54,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF232323),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                        ),
                        onChanged: (val) => setState(() => _search = val),
                      ),
                      const SizedBox(height: 8),
                      CustomBottomSheetSelect(
                        label: 'Тип снаряжения',
                        value: _selectedType,
                        items: ['', 'Мое снаряжение', ..._allTypes],
                        onChanged: (val) => setState(() => _selectedType = val),
                      ),
                    ],
                  ),
                ),
                _filteredEquipment.isEmpty
                    ? const Center(
                      child: Text(
                        'Ничего не найдено',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                    : ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children:
                          _filteredEquipment
                              .map(
                                (equipment) => _buildEquipmentCard(equipment),
                              )
                              .toList(),
                    ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _showAddCustomEquipmentModal,
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
                          Text('ДОБАВИТЬ СВОЕ'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

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
              onTap: widget.onShowLoadEditModal,
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
            SectionHeadInfo(title: 'Деньги'),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CardValue(
                        name: 'ММ',
                        params: widget.copperCoins.toString(),
                        onTap: () => widget.onEditCurrency('ММ'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CardValue(
                        name: 'СМ',
                        params: widget.silverCoins.toString(),
                        onTap: () => widget.onEditCurrency('СМ'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CardValue(
                        name: 'ЗМ',
                        params: widget.goldCoins.toString(),
                        onTap: () => widget.onEditCurrency('ЗМ'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CardValue(
                        name: 'ПМ',
                        params: widget.platinumCoins.toString(),
                        onTap: () => widget.onEditCurrency('ПМ'),
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

  String _formatWeight(dynamic weight) {
    if (weight is int) {
      return weight.toString();
    } else if (weight is double) {
      return weight.toStringAsFixed(1);
    }
    return '0';
  }

  Color _getWeightColor(double weight) {
    if (weight == 0) return Colors.grey;
    if (weight <= 10) return Colors.green;
    if (weight <= 25) return Colors.orange;
    if (weight <= 50) return Colors.red;
    return Colors.black;
  }
}
