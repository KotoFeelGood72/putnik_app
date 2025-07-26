import 'package:flutter/material.dart';
import 'package:putnik_app/models/weapon_model.dart';
import 'package:putnik_app/models/armor_model.dart';
import 'package:putnik_app/present/components/inputs/custom_bottom_sheet_select.dart';
import 'package:dio/dio.dart';

import 'package:putnik_app/services/app/dio_config.dart';

// Универсальный компонент для отображения товаров в магазине
class ShopTabContent<T> extends StatefulWidget {
  final List<T> items;
  final List<Map<String, dynamic>> selectedItems;
  final Function(List<Map<String, dynamic>>) onSelectionChanged;
  final String categoryLabel;
  final String searchHint;
  final String Function(T)? getCategory;
  final String Function(T)? getName;
  final String Function(T)? getDescription;
  final int? Function(T)? getCost;
  final int? copperCoins;
  final int? silverCoins;
  final int? goldCoins;
  final int? platinumCoins;
  final void Function({
    required int cost,
    required String currency,
    required Map<String, dynamic> item,
  })?
  onSpendMoney;

  const ShopTabContent({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.categoryLabel = 'Категория',
    this.searchHint = 'Поиск...',
    this.getCategory,
    this.getName,
    this.getDescription,
    this.getCost,
    this.copperCoins,
    this.silverCoins,
    this.goldCoins,
    this.platinumCoins,
    this.onSpendMoney,
  });

  @override
  State<ShopTabContent<T>> createState() => _ShopTabContentState<T>();
}

class _ShopTabContentState<T> extends State<ShopTabContent<T>> {
  String _search = '';
  String _selectedCategory = '';

  // Функция для проверки достаточности денег
  bool _canAfford(int? cost) {
    if (cost == null || cost <= 0) return true;

    // Конвертируем все деньги в медные монеты для сравнения
    int totalCopper = 0;
    totalCopper += widget.copperCoins ?? 0;
    totalCopper += (widget.silverCoins ?? 0) * 10; // 1 серебряная = 10 медных
    totalCopper += (widget.goldCoins ?? 0) * 100; // 1 золотая = 100 медных
    totalCopper +=
        (widget.platinumCoins ?? 0) * 1000; // 1 платиновая = 1000 медных

    return totalCopper >= cost;
  }

  // Функция для показа сообщения о недостатке денег
  void _showInsufficientFundsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Недостаточно денег',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'У вас недостаточно денег для покупки этого предмета.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'ПОНЯТНО',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedAliases = widget.selectedItems.map((w) => w['alias']).toSet();
    final categories = [
      '',
      ...widget.items
          .map((w) => widget.getCategory?.call(w) ?? '')
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList()
        ..sort(),
    ];

    // Отладочная информация о категориях в ShopTabContent
    print('ShopTabContent: всего элементов ${widget.items.length}');
    print('ShopTabContent: найденные категории $categories');

    final filteredItems =
        widget.items.where((item) {
          final query = _search.trim().toLowerCase();
          if (_selectedCategory.isNotEmpty &&
              (widget.getCategory?.call(item) ?? '') != _selectedCategory) {
            return false;
          }
          if (query.isEmpty) return true;
          final name = (widget.getName?.call(item) ?? '').toLowerCase();
          final desc = (widget.getDescription?.call(item) ?? '').toLowerCase();
          return name.contains(query) || desc.contains(query);
        }).toList();

    // Группировка по категориям
    final Map<String, List<T>> grouped = {};
    for (final item in filteredItems) {
      final cat = widget.getCategory?.call(item) ?? 'Без категории';
      grouped.putIfAbsent(cat, () => []).add(item);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
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
                label: widget.categoryLabel,
                value: _selectedCategory,
                items: categories,
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              filteredItems.isEmpty
                  ? const Center(
                    child: Text(
                      'Ничего не найдено',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                  : ListView(
                    children:
                        grouped.entries.expand((entry) {
                          final cat = entry.key;
                          final items = entry.value;
                          return [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                              child: Text(
                                cat,
                                style: const TextStyle(
                                  color: Color(0xFF5B2333),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ...items.map((item) {
                              final alias = _getAlias(item);
                              final isSelected = selectedAliases.contains(
                                alias,
                              );
                              return Card(
                                color:
                                    isSelected
                                        ? Colors.green.withValues(alpha: 0.08)
                                        : Colors.transparent,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  title: Text(
                                    widget.getName?.call(item) ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Стоимость: ${widget.getCost?.call(item) ?? "—"} зм',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      if (widget.getDescription?.call(item) !=
                                          null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            widget.getDescription!.call(item),
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 13,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing:
                                      isSelected
                                          ? IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 28,
                                            ),
                                            tooltip: 'Убрать из выбранных',
                                            onPressed: () {
                                              final updated =
                                                  widget.selectedItems
                                                      .where(
                                                        (w) =>
                                                            w['alias'] != alias,
                                                      )
                                                      .toList();
                                              widget.onSelectionChanged(
                                                updated,
                                              );
                                            },
                                          )
                                          : IconButton(
                                            icon: const Icon(
                                              Icons.add_shopping_cart,
                                              color: Colors.white,
                                            ),
                                            tooltip: 'Добавить',
                                            onPressed: () {
                                              final cost = widget.getCost?.call(
                                                item,
                                              );
                                              // Убираем проверку _canAfford отсюда - она будет в _tryBuyItem
                                              if (widget.onSpendMoney != null &&
                                                  cost != null &&
                                                  cost > 0) {
                                                widget.onSpendMoney!(
                                                  cost: cost,
                                                  currency: 'ЗМ',
                                                  item: _toJson(item),
                                                );
                                              } else {
                                                // Если предмет бесплатный, добавляем через onSelectionChanged
                                                final updated = [
                                                  ...widget.selectedItems,
                                                  _toJson(item),
                                                ];
                                                widget.onSelectionChanged(
                                                  updated,
                                                );
                                              }
                                            },
                                          ),
                                ),
                              );
                            }),
                          ];
                        }).toList(),
                  ),
        ),
      ],
    );
  }

  String _getAlias(T item) {
    if (item is WeaponModel) return item.alias ?? '';
    if (item is ArmorModel) return item.alias ?? '';
    if (item is GoodsModel) return item.alias ?? '';
    return '';
  }

  Map<String, dynamic> _toJson(T item) {
    if (item is WeaponModel) return item.toJson();
    if (item is ArmorModel) return item.toJson();
    if (item is GoodsModel) return item.toJson();
    return {};
  }
}

// --- Использование универсального компонента для всех вкладок ---
class ShopWeaponsTab extends StatelessWidget {
  final List<WeaponModel> allWeapons;
  final List<Map<String, dynamic>> selectedWeapons;
  final Function(List<Map<String, dynamic>>) onWeaponsChanged;
  final int? copperCoins;
  final int? silverCoins;
  final int? goldCoins;
  final int? platinumCoins;
  final void Function({
    required int cost,
    required String currency,
    required Map<String, dynamic> item,
  })?
  onSpendMoney;

  const ShopWeaponsTab({
    super.key,
    required this.allWeapons,
    required this.selectedWeapons,
    required this.onWeaponsChanged,
    this.copperCoins,
    this.silverCoins,
    this.goldCoins,
    this.platinumCoins,
    this.onSpendMoney,
  });
  @override
  Widget build(BuildContext context) {
    return ShopTabContent<WeaponModel>(
      items: allWeapons,
      selectedItems: selectedWeapons,
      onSelectionChanged: onWeaponsChanged,
      categoryLabel: 'Категория',
      searchHint: 'Поиск оружия...',
      getCategory: (weapon) => weapon.proficientCategory?.name ?? '',
      getName: (weapon) => weapon.name ?? '',
      getDescription: (weapon) => weapon.description ?? '',
      getCost: (weapon) => weapon.cost,
      copperCoins: copperCoins,
      silverCoins: silverCoins,
      goldCoins: goldCoins,
      platinumCoins: platinumCoins,
      onSpendMoney: onSpendMoney,
    );
  }
}

class ShopArmorTab extends StatelessWidget {
  final List<ArmorModel> allArmors;
  final List<Map<String, dynamic>> selectedArmors;
  final Function(List<Map<String, dynamic>>) onArmorsChanged;
  final int? copperCoins;
  final int? silverCoins;
  final int? goldCoins;
  final int? platinumCoins;
  final void Function({
    required int cost,
    required String currency,
    required Map<String, dynamic> item,
  })?
  onSpendMoney;

  const ShopArmorTab({
    super.key,
    required this.allArmors,
    required this.selectedArmors,
    required this.onArmorsChanged,
    this.copperCoins,
    this.silverCoins,
    this.goldCoins,
    this.platinumCoins,
    this.onSpendMoney,
  });
  @override
  Widget build(BuildContext context) {
    return ShopTabContent<ArmorModel>(
      items: allArmors,
      selectedItems: selectedArmors,
      onSelectionChanged: onArmorsChanged,
      categoryLabel: 'Категория',
      searchHint: 'Поиск доспехов...',
      getCategory: (armor) => armor.armorCategory?.name ?? '',
      getName: (armor) => armor.name ?? '',
      getDescription: (armor) => armor.description ?? '',
      getCost: (armor) => armor.cost,
      copperCoins: copperCoins,
      silverCoins: silverCoins,
      goldCoins: goldCoins,
      platinumCoins: platinumCoins,
      onSpendMoney: onSpendMoney,
    );
  }
}

class ShopMaterialsTab extends StatelessWidget {
  const ShopMaterialsTab({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: заменить на список материалов, когда появится модель
    return const Center(
      child: Text('Особые материалы', style: TextStyle(color: Colors.white)),
    );
  }
}

class WeaponsTab extends StatefulWidget {
  final List<Map<String, dynamic>> weapons;
  final Function(List<Map<String, dynamic>>) onWeaponsChanged;
  final List<WeaponModel> allWeapons;
  final List<ArmorModel> allArmors;
  final List<Map<String, dynamic>> armors;
  final Function(List<Map<String, dynamic>>) onArmorsChanged;
  final List<Map<String, dynamic>> goods;
  final Function(List<Map<String, dynamic>>) onGoodsChanged;
  final int? copperCoins;
  final int? silverCoins;
  final int? goldCoins;
  final int? platinumCoins;
  final void Function({
    required int cost,
    required String currency,
    required Map<String, dynamic> item,
  })?
  onSpendMoney;

  const WeaponsTab({
    super.key,
    required this.weapons,
    required this.onWeaponsChanged,
    required this.allWeapons,
    required this.allArmors,
    required this.armors,
    required this.onArmorsChanged,
    required this.goods,
    required this.onGoodsChanged,
    this.copperCoins,
    this.silverCoins,
    this.goldCoins,
    this.platinumCoins,
    this.onSpendMoney,
  });

  @override
  State<WeaponsTab> createState() => _WeaponsTabState();
}

class _WeaponsTabState extends State<WeaponsTab> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Оружие', 'Доспехи', 'Товары и услуги'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Табы с прокруткой
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final selected = _selectedTab == i;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selected
                                ? const Color(0xFF5B2333)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _tabs[i],
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white70,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              switch (_selectedTab) {
                case 0:
                  return ShopWeaponsTab(
                    allWeapons: widget.allWeapons,
                    selectedWeapons: widget.weapons,
                    onWeaponsChanged: widget.onWeaponsChanged,
                    copperCoins: widget.copperCoins,
                    silverCoins: widget.silverCoins,
                    goldCoins: widget.goldCoins,
                    platinumCoins: widget.platinumCoins,
                    onSpendMoney: widget.onSpendMoney,
                  );
                case 1:
                  return ShopArmorTab(
                    allArmors: widget.allArmors,
                    selectedArmors: widget.armors,
                    onArmorsChanged: widget.onArmorsChanged,
                    copperCoins: widget.copperCoins,
                    silverCoins: widget.silverCoins,
                    goldCoins: widget.goldCoins,
                    platinumCoins: widget.platinumCoins,
                    onSpendMoney: widget.onSpendMoney,
                  );
                case 2:
                  return ShopGoodsTab(
                    selectedGoods: widget.goods,
                    onGoodsChanged: widget.onGoodsChanged,
                    copperCoins: widget.copperCoins,
                    silverCoins: widget.silverCoins,
                    goldCoins: widget.goldCoins,
                    platinumCoins: widget.platinumCoins,
                    onSpendMoney: widget.onSpendMoney,
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}

// 2. Модель для товаров и услуг
class GoodsModel {
  final String? alias;
  final String? name;
  final int? cost;
  final String? description;
  final Map<String, dynamic>? type;
  final double? weight;

  GoodsModel({
    this.alias,
    this.name,
    this.cost,
    this.description,
    this.type,
    this.weight,
  });

  factory GoodsModel.fromJson(Map<String, dynamic> json) {
    String? safeString(dynamic value) => value is String ? value : null;
    int? safeInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    double? safeDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    Map<String, dynamic>? safeMap(dynamic value) =>
        value is Map<String, dynamic> ? value : null;

    return GoodsModel(
      alias: safeString(json['alias']),
      name: safeString(json['name']),
      cost: safeInt(json['cost']),
      description: safeString(json['description']),
      type: safeMap(json['type']),
      weight: safeDouble(json['weight']),
    );
  }

  Map<String, dynamic> toJson() => {
    'alias': alias,
    'name': name,
    'cost': cost,
    'description': description,
    'type': type,
    'weight': weight,
  };
}

// 3. Сервис для загрузки товаров и услуг
class GoodsService {
  static final Dio _dio = DioConfig.instance;

  static Future<List<GoodsModel>> getAllGoods() async {
    try {
      print('Отправляем запрос к /goodsAndServices через DioConfig...');
      final response = await _dio.get('/goodsAndServices');
      print('Получен ответ: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        print('Получено данных: ${data.length}');
        final goods =
            data
                .whereType<Map<String, dynamic>>()
                .map((json) => GoodsModel.fromJson(json))
                .toList();
        print('Парсинг завершен, товаров: ${goods.length}');

        // Отладочная информация о категориях
        if (goods.isNotEmpty) {
          print('Примеры товаров:');
          for (int i = 0; i < goods.take(3).length; i++) {
            final good = goods[i];
            print(
              '  ${i + 1}. ${good.name} - категория: "${good.type?['name']}"',
            );
          }

          final categories =
              goods
                  .map((g) => g.type?['name'])
                  .where((c) => c != null && c.isNotEmpty)
                  .toSet();
          print('Найденные категории: $categories');
        }

        return goods;
      } else {
        throw Exception('Ошибка при получении товаров: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка в GoodsService: $e');
      throw Exception('Ошибка при получении товаров: $e');
    }
  }
}

// 4. ShopGoodsTab с загрузкой данных
class ShopGoodsTab extends StatefulWidget {
  final List<Map<String, dynamic>> selectedGoods;
  final Function(List<Map<String, dynamic>>) onGoodsChanged;
  final int? copperCoins;
  final int? silverCoins;
  final int? goldCoins;
  final int? platinumCoins;
  final void Function({
    required int cost,
    required String currency,
    required Map<String, dynamic> item,
  })?
  onSpendMoney;

  const ShopGoodsTab({
    super.key,
    required this.selectedGoods,
    required this.onGoodsChanged,
    this.copperCoins,
    this.silverCoins,
    this.goldCoins,
    this.platinumCoins,
    this.onSpendMoney,
  });
  @override
  State<ShopGoodsTab> createState() => _ShopGoodsTabState();
}

class _ShopGoodsTabState extends State<ShopGoodsTab> {
  List<GoodsModel> _goods = [];
  bool _loading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _loadGoods();
  }

  Future<void> _loadGoods() async {
    try {
      print('Загружаем товары и услуги...');
      final goods = await GoodsService.getAllGoods();
      print('Загружено товаров: ${goods.length}');
      setState(() {
        _goods = goods;
        _loading = false;
      });
    } catch (e) {
      print('Ошибка загрузки товаров: $e');
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Ошибка загрузки товаров',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ShopTabContent<GoodsModel>(
      items: _goods,
      selectedItems: widget.selectedGoods,
      onSelectionChanged: widget.onGoodsChanged,
      categoryLabel: 'Категория',
      searchHint: 'Поиск товаров...',
      getCategory: (g) => g.type?['name'] ?? '',
      getName: (g) => g.name ?? '',
      getDescription: (g) => g.description ?? '',
      getCost: (g) => g.cost,
      copperCoins: widget.copperCoins,
      silverCoins: widget.silverCoins,
      goldCoins: widget.goldCoins,
      platinumCoins: widget.platinumCoins,
      onSpendMoney: widget.onSpendMoney,
    );
  }
}
