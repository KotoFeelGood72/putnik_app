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
    return Container(
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

          _buildWeaponsSection(hero.weapons),
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
