import 'package:flutter/material.dart';
import 'package:putnik_app/models/weapon_model.dart';
import 'package:putnik_app/services/weapons_service.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/components/inputs/custom_bottom_sheet_select.dart';

class WeaponsSelector extends StatelessWidget {
  final List<Map<String, dynamic>> selectedWeapons;
  final Function(List<Map<String, dynamic>>) onWeaponsChanged;
  final List<WeaponModel> allWeapons;

  const WeaponsSelector({
    super.key,
    required this.selectedWeapons,
    required this.onWeaponsChanged,
    required this.allWeapons,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showWeaponsSelectionModal(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.gps_fixed, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedWeapons.isEmpty
                    ? 'Выберите оружие'
                    : '${selectedWeapons.length} оружий выбрано',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  void _showWeaponsSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _WeaponsSelectionModal(
            selectedWeapons: selectedWeapons,
            onWeaponsChanged: onWeaponsChanged,
            allWeapons: allWeapons,
          ),
    );
  }
}

class _WeaponsSelectionModal extends StatefulWidget {
  final List<Map<String, dynamic>> selectedWeapons;
  final Function(List<Map<String, dynamic>>) onWeaponsChanged;
  final List<WeaponModel> allWeapons;

  const _WeaponsSelectionModal({
    required this.selectedWeapons,
    required this.onWeaponsChanged,
    required this.allWeapons,
  });

  @override
  State<_WeaponsSelectionModal> createState() => _WeaponsSelectionModalState();
}

class _WeaponsSelectionModalState extends State<_WeaponsSelectionModal> {
  late List<WeaponModel> _selectedWeapons;
  late List<WeaponModel> _filteredWeapons;
  String _selectedCategory = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(
      '_WeaponsSelectionModalState initState: allWeapons=${widget.allWeapons.length}',
    );
    _selectedWeapons = _loadSelectedWeapons();
    _updateFilteredWeapons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WeaponModel> _loadSelectedWeapons() {
    return widget.selectedWeapons.map((weaponData) {
      return WeaponModel.fromJson(weaponData);
    }).toList();
  }

  void _updateFilteredWeapons() {
    print(
      '_updateFilteredWeapons: selectedCategory=$_selectedCategory, searchQuery=$_searchQuery',
    );

    List<WeaponModel> categoryWeapons;
    if (_selectedCategory.isEmpty) {
      categoryWeapons = widget.allWeapons;
      print('Фильтр по категории: все оружия (${categoryWeapons.length})');
    } else {
      categoryWeapons =
          widget.allWeapons
              .where(
                (weapon) =>
                    weapon.proficientCategory?.name == _selectedCategory,
              )
              .toList();
      print(
        'Фильтр по категории "$_selectedCategory": ${categoryWeapons.length} оружий',
      );
    }

    if (_searchQuery.isEmpty) {
      _filteredWeapons = categoryWeapons;
      print('Фильтр по поиску: все (${_filteredWeapons.length})');
    } else {
      _filteredWeapons =
          categoryWeapons
              .where(
                (weapon) =>
                    (weapon.name?.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ??
                        false) ||
                    (weapon.description?.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
      print(
        'Фильтр по поиску "$_searchQuery": ${_filteredWeapons.length} оружий',
      );
    }
  }

  void _toggleWeapon(WeaponModel weapon) {
    setState(() {
      final isSelected = _selectedWeapons.any((w) => w.alias == weapon.alias);
      if (isSelected) {
        _selectedWeapons.removeWhere((w) => w.alias == weapon.alias);
      } else {
        _selectedWeapons.add(weapon);
      }
    });
  }

  void _saveSelection() {
    final weaponsData =
        _selectedWeapons.map((weapon) => weapon.toJson()).toList();
    widget.onWeaponsChanged(weaponsData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print('WeaponsSelector build: allWeapons=${widget.allWeapons.length}');

    final uniqueCategories = WeaponsService.getUniqueProficientCategories(
      widget.allWeapons,
    );

    // Отладочная информация
    print('Всего оружий: ${widget.allWeapons.length}');
    print('Уникальные категории: $uniqueCategories');
    if (widget.allWeapons.isNotEmpty) {
      print('Категории с деталями:');
      for (final weapon in widget.allWeapons.take(5)) {
        // Показываем только первые 5
        print('  ${weapon.name}: ${weapon.proficientCategory?.name ?? "null"}');
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Заголовок
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.gps_fixed, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Выбор оружия',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_selectedWeapons.length} выбрано',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Поиск
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Поиск оружия...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _updateFilteredWeapons();
                });
              },
            ),
          ),

          // Фильтр по категории
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                widget.allWeapons.isEmpty
                    ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Загрузка категорий...',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    )
                    : CustomBottomSheetSelect(
                      label: 'Выберите категорию владения',
                      value: _selectedCategory,
                      items: ['', ...uniqueCategories],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          _updateFilteredWeapons();
                        });
                      },
                    ),
          ),

          const SizedBox(height: 20),

          // Список оружия
          Expanded(
            child:
                _filteredWeapons.isEmpty
                    ? Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? (_selectedCategory.isEmpty
                                ? 'Выберите категорию владения'
                                : 'Нет оружия в выбранной категории')
                            : 'Оружие не найдено',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredWeapons.length,
                      itemBuilder: (context, index) {
                        final weapon = _filteredWeapons[index];
                        final isSelected = _selectedWeapons.any(
                          (w) => w.alias == weapon.alias,
                        );
                        return _buildWeaponItem(weapon, isSelected);
                      },
                    ),
          ),

          // Кнопки
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Btn(
                    text: 'СОХРАНИТЬ',
                    onPressed: _saveSelection,
                    buttonSize: 50,
                    textSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2A2A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'ОТМЕНА',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponItem(WeaponModel weapon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF5B2333) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected
                  ? const Color(0xFF5B2333)
                  : Colors.white.withValues(alpha: 0.3),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleWeapon(weapon),
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
                        weapon.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check, color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Урон: ${weapon.damageM} (${weapon.damageS}) | Крит: ${weapon.criticalRoll}/${weapon.criticalDamage}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${weapon.proficientCategory?.name ?? ''} | ${weapon.rangeCategory?.name ?? ''} | ${weapon.encumbranceCategory?.name ?? ''}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
                if (weapon.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    weapon.description!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Вес: ${weapon.weight} фн | Стоимость: ${weapon.cost} зм',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
