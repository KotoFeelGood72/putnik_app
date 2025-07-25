import 'package:flutter/material.dart';
import 'package:putnik_app/models/weapon_model.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/components/inputs/weapons_selector.dart';
import 'package:putnik_app/services/weapons_service.dart';

class WeaponsTab extends StatefulWidget {
  final List<Map<String, dynamic>> weapons;
  final Function(List<Map<String, dynamic>>) onWeaponsChanged;
  final List<WeaponModel> allWeapons;

  const WeaponsTab({
    super.key,
    required this.weapons,
    required this.onWeaponsChanged,
    required this.allWeapons,
  });

  @override
  State<WeaponsTab> createState() => _WeaponsTabState();
}

class _WeaponsTabState extends State<WeaponsTab> {
  late List<WeaponModel> _selectedWeapons;

  @override
  void initState() {
    super.initState();
    _loadSelectedWeapons();
  }

  @override
  void didUpdateWidget(WeaponsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weapons != widget.weapons) {
      _loadSelectedWeapons();
    }
  }

  void _loadSelectedWeapons() {
    _selectedWeapons =
        widget.weapons.map((weaponData) {
          return WeaponModel.fromJson(weaponData);
        }).toList();
  }

  void _onWeaponsChanged(List<Map<String, dynamic>> weapons) {
    widget.onWeaponsChanged(weapons);
  }

  @override
  Widget build(BuildContext context) {
    final groupedWeapons = WeaponsService.groupWeaponsByProficientCategory(
      _selectedWeapons,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          // Заголовок секции
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Оружие',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Btn(
                    text: 'ДОБАВИТЬ',
                    onPressed: () {
                      // Селектор оружия будет показан через WeaponsSelector
                    },
                    buttonSize: 50,
                    textSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Селектор оружия
          WeaponsSelector(
            selectedWeapons: widget.weapons,
            onWeaponsChanged: _onWeaponsChanged,
            allWeapons: widget.allWeapons,
          ),

          const SizedBox(height: 20),

          // Список выбранного оружия
          if (_selectedWeapons.isNotEmpty) ...[
            ...groupedWeapons.entries.map((entry) {
              final category = entry.key;
              final weapons = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Color(0xFF5B2333),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...weapons.map((weapon) => _buildWeaponItem(weapon)),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.gps_fixed,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Оружие не выбрано',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Нажмите "ДОБАВИТЬ" чтобы выбрать оружие',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeaponItem(WeaponModel weapon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    weapon.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B2333),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    weapon.type ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Урон: ${weapon.damageM} (${weapon.damageS})',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Крит: ${weapon.criticalRoll}/${weapon.criticalDamage}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Вес: ${weapon.weight} фн',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Стоимость: ${weapon.cost} зм',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${weapon.proficientCategory?.name ?? ''} | ${weapon.rangeCategory?.name ?? ''} | ${weapon.encumbranceCategory?.name ?? ''}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
            if (weapon.description != null) ...[
              const SizedBox(height: 8),
              Text(
                weapon.description!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
            if (weapon.special != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B2333).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Особое: ${weapon.special}',
                  style: const TextStyle(
                    color: Color(0xFF5B2333),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
