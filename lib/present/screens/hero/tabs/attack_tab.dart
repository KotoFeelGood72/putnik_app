import 'package:flutter/material.dart';
import '../../../../models/hero_model.dart';
import '../../../components/cards/card_value.dart';
import '../../../components/head/section_head_info.dart';

class AttackTab extends StatelessWidget {
  final HeroModel hero;
  final Function(BuildContext) onShowInitiativeEditModal;
  final Function(BuildContext) onShowBMAEditModal;
  final Function(BuildContext, int?, int, int?) onShowMBMFormulaModal;
  final Function(BuildContext, int?, int, int, int?) onShowZBMFormulaModal;

  const AttackTab({
    super.key,
    required this.hero,
    required this.onShowInitiativeEditModal,
    required this.onShowBMAEditModal,
    required this.onShowMBMFormulaModal,
    required this.onShowZBMFormulaModal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Инициатива
          SectionHeadInfo(title: 'Инициатива'),

          GestureDetector(
            onTap: () => onShowInitiativeEditModal(context),
            child: Row(
              children: [
                Expanded(
                  child: CardValue(
                    name: 'ИНИЦИАТИВА',
                    params: _formatInitiativeParams(
                      hero.dexterity,
                      hero.tempDexterity,
                      hero.miscInitiativeBonus,
                    ),
                    onTap: () => onShowInitiativeEditModal(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CardValue(
                    name: 'МОД. ЛВК',
                    params: _formatDexModParams(
                      hero.dexterity,
                      hero.tempDexterity,
                    ),
                    onTap: () => onShowInitiativeEditModal(context),
                  ),
                ),
              ],
            ),
          ),

          SectionHeadInfo(title: 'Атака'),

          Row(
            children: [
              Expanded(
                child: CardValue(
                  name: 'БМА',
                  params: (hero.baseAttackBonus ?? 0).toString(),
                  onTap: () => onShowBMAEditModal(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CardValue(
                  name: 'МБМ',
                  params: _formatMBMParams(
                    hero.baseAttackBonus,
                    hero.strength,
                    hero.tempStrength,
                    hero.sizeModifier,
                  ),
                  onTap:
                      () => onShowMBMFormulaModal(
                        context,
                        hero.baseAttackBonus,
                        hero.tempStrength != null
                            ? _calculateModifier(hero.tempStrength!)
                            : _calculateModifier(hero.strength),
                        hero.sizeModifier,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CardValue(
                  name: 'ЗБМ',
                  params: _formatZBMParams(
                    hero.baseAttackBonus,
                    hero.strength,
                    hero.tempStrength,
                    hero.dexterity,
                    hero.tempDexterity,
                    hero.sizeModifier,
                  ),
                  onTap:
                      () => onShowZBMFormulaModal(
                        context,
                        hero.baseAttackBonus,
                        hero.tempStrength != null
                            ? _calculateModifier(hero.tempStrength!)
                            : _calculateModifier(hero.strength),
                        hero.tempDexterity != null
                            ? _calculateModifier(hero.tempDexterity!)
                            : _calculateModifier(hero.dexterity),
                        hero.sizeModifier,
                      ),
                ),
              ),
            ],
          ),
          SectionHeadInfo(title: 'Оружие'),

          _buildWeaponsSection(hero.equipment, hero.weapons),
        ],
      ),
    );
  }

  Widget _buildWeaponsSection(
    List<Map<String, dynamic>> equipment,
    List<Map<String, dynamic>> weaponsList,
  ) {
    // Объединяем оружие из снаряжения и из списка оружия
    final allWeapons = <Map<String, dynamic>>[];

    // Добавляем оружие из снаряжения
    final equipmentWeapons =
        equipment
            .where(
              (item) =>
                  item['type'] == 'weapon' ||
                  item['type'] == 'Оружие' ||
                  item['category'] == 'weapon' ||
                  item['category'] == 'Оружие' ||
                  (item['name'] != null &&
                      item['name'].toString().toLowerCase().contains('оружие')),
            )
            .toList();

    allWeapons.addAll(equipmentWeapons);
    allWeapons.addAll(weaponsList);

    // Убираем дубликаты по имени
    final uniqueWeapons = <Map<String, dynamic>>[];
    final seenNames = <String>{};

    for (final weapon in allWeapons) {
      final name = weapon['name']?.toString() ?? '';
      if (name.isNotEmpty && !seenNames.contains(name)) {
        seenNames.add(name);
        uniqueWeapons.add(weapon);
      }
    }

    // Исключаем все боеприпасы
    final weapons =
        uniqueWeapons.where((weapon) {
          final name = weapon['name']?.toString().toLowerCase() ?? '';
          return !name.contains('стрела') &&
              !name.contains('болт') &&
              !name.contains('пуля') &&
              !name.contains('дробь') &&
              !name.contains('снаряд') &&
              !name.contains('камень') &&
              !name.contains('дротик') &&
              !name.contains('копье') &&
              !name.contains('метательное') &&
              !name.contains('боеприпас');
        }).toList();

    if (weapons.isEmpty) {
      return Container(
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
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Оружие не найдено в снаряжении',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: weapons.map((weapon) => _buildWeaponCard(weapon)).toList(),
    );
  }

  Widget _buildWeaponCard(Map<String, dynamic> weapon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            // Название оружия
            Row(
              children: [
                Expanded(
                  child: Text(
                    weapon['name'] ?? 'Оружие',
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
                          '${weapon['attackModifier'] ?? weapon['attack'] ?? 0}',
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
                          weapon['criticalRange'] ?? weapon['critical'] ?? '-',
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
                          weapon['damageType'] ?? weapon['type'] ?? '-',
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
                          weapon['range'] ?? weapon['distance'] ?? '-',
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
                          weapon['ammunition'] ?? weapon['bullets'] ?? '-',
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
                          weapon['damage'] ?? '-',
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
    );
  }

  String _formatInitiativeParams(
    int baseDexterity,
    int? tempDexterity,
    int? miscInitiativeBonus,
  ) {
    final dexMod = _calculateModifier(baseDexterity);
    final tempMod =
        tempDexterity != null ? _calculateModifier(tempDexterity) : dexMod;
    final total = tempMod + (miscInitiativeBonus ?? 0);
    return (total >= 0 ? '+' : '') + total.toString();
  }

  String _formatDexModParams(int baseDexterity, int? tempDexterity) {
    final dexMod = _calculateModifier(baseDexterity);
    final tempMod =
        tempDexterity != null ? _calculateModifier(tempDexterity) : dexMod;
    return (tempDexterity != null)
        ? '${tempMod >= 0 ? '+' : ''}$tempMod (${tempDexterity})'
        : '${dexMod >= 0 ? '+' : ''}$dexMod';
  }

  String _formatMBMParams(
    int? baseAttackBonus,
    int strength,
    int? tempStrength,
    int? sizeModifier,
  ) {
    final strMod = _calculateModifier(strength);
    final tempStrMod =
        tempStrength != null ? _calculateModifier(tempStrength) : strMod;
    final total = (baseAttackBonus ?? 0) + tempStrMod + (sizeModifier ?? 0);
    return (total >= 0 ? '+' : '') + total.toString();
  }

  String _formatZBMParams(
    int? baseAttackBonus,
    int strength,
    int? tempStrength,
    int dexterity,
    int? tempDexterity,
    int? sizeModifier,
  ) {
    final strMod = _calculateModifier(strength);
    final tempStrMod =
        tempStrength != null ? _calculateModifier(tempStrength) : strMod;
    final dexMod = _calculateModifier(dexterity);
    final tempDexMod =
        tempDexterity != null ? _calculateModifier(tempDexterity) : dexMod;
    final total =
        (baseAttackBonus ?? 0) +
        tempStrMod +
        tempDexMod +
        (sizeModifier ?? 0) +
        10;
    return (total >= 0 ? '+' : '') + total.toString();
  }

  int _calculateModifier(int value) {
    return ((value - 10) / 2).floor();
  }
}
