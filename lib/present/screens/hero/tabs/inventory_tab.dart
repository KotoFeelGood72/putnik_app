import 'package:flutter/material.dart';
import '../../../components/cards/card_value.dart';
import '../../../components/head/section_head_info.dart';

class InventoryTab extends StatelessWidget {
  final List<Map<String, dynamic>> equipment;
  final int copperCoins;
  final int silverCoins;
  final int goldCoins;
  final int platinumCoins;
  final VoidCallback onShowAddEquipmentModal;
  final VoidCallback onShowLoadEditModal;
  final Function(int) onRemoveEquipment;
  final Function(String) onEditCurrency;

  const InventoryTab({
    super.key,
    required this.equipment,
    required this.copperCoins,
    required this.silverCoins,
    required this.goldCoins,
    required this.platinumCoins,
    required this.onShowAddEquipmentModal,
    required this.onShowLoadEditModal,
    required this.onRemoveEquipment,
    required this.onEditCurrency,
  });

  @override
  Widget build(BuildContext context) {
    // Вычисляем общий вес снаряжения
    int totalWeight = 0;
    for (var item in equipment) {
      totalWeight += (item['weight'] as int?) ?? 0;
    }

    return Padding(
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
                ...List.generate(equipment.length, (index) {
                  return _buildEquipmentRow(equipment[index], index);
                }),
                // Кнопка добавления (всегда отображается)
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: onShowAddEquipmentModal,
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
            onTap: onShowLoadEditModal,
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
                      params: copperCoins.toString(),
                      onTap: () => onEditCurrency('ММ'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CardValue(
                      name: 'СМ',
                      params: silverCoins.toString(),
                      onTap: () => onEditCurrency('СМ'),
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
                      params: goldCoins.toString(),
                      onTap: () => onEditCurrency('ЗМ'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CardValue(
                      name: 'ПМ',
                      params: platinumCoins.toString(),
                      onTap: () => onEditCurrency('ПМ'),
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
            onPressed: () => onRemoveEquipment(index),
            icon: const Icon(Icons.delete, color: Colors.red, size: 16),
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
}
