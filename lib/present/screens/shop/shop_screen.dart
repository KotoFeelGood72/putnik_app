import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:putnik_app/models/hero_model.dart';
import 'package:putnik_app/models/weapon_model.dart';
import 'package:putnik_app/models/armor_model.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/components/inputs/custom_bottom_sheet_select.dart';
import 'package:putnik_app/services/weapons_service.dart';
import 'package:putnik_app/services/armors_service.dart';
import 'package:putnik_app/utils/modal_utils.dart';
import 'package:dio/dio.dart';
import 'package:putnik_app/services/app/dio_config.dart';

@RoutePage()
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Оружие', 'Доспехи', 'Товары и услуги'];

  List<WeaponModel> _allWeapons = [];
  List<ArmorModel> _allArmors = [];
  List<Map<String, dynamic>> _allGoods = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShopData();
  }

  Future<void> _loadShopData() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // Загружаем все данные параллельно
      final results = await Future.wait([
        WeaponsService.getAllWeapons(),
        ArmorsService.getAllArmors(),
        _loadGoods(),
      ]);

      setState(() {
        _allWeapons = results[0] as List<WeaponModel>;
        _allArmors = results[1] as List<ArmorModel>;
        _allGoods = results[2] as List<Map<String, dynamic>>;
        _loading = false;
      });
    } catch (e) {
      print('Ошибка загрузки данных магазина: $e');
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<List<Map<String, dynamic>>> _loadGoods() async {
    try {
      final dio = DioConfig.instance;
      final response = await dio.get('/goods');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Ошибка загрузки товаров: $e');
      return [];
    }
  }

  Future<void> _showHeroSelectionModal(
    Map<String, dynamic> item,
    int cost,
    String currency,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Получаем список всех героев пользователя
    final heroesSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('heroes')
            .get();

    if (heroesSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('У вас нет персонажей для покупки предметов'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final heroes =
        heroesSnapshot.docs.map((doc) {
          final data = doc.data();
          return HeroModel.fromJson(data, id: doc.id);
        }).toList();

    // Показываем модальное окно выбора персонажа
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: Text(
              'Выберите персонажа для покупки',
              style: const TextStyle(color: Colors.white),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: heroes.length,
                itemBuilder: (context, index) {
                  final hero = heroes[index];
                  return ListTile(
                    title: Text(
                      hero.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${hero.race} ${hero.characterClass} ${hero.level} уровня',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await _purchaseItemForHero(hero, item, cost, currency);
                    },
                  );
                },
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
            ],
          ),
    );
  }

  Future<void> _purchaseItemForHero(
    HeroModel hero,
    Map<String, dynamic> item,
    int cost,
    String currency,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Проверяем, достаточно ли денег у героя
      int heroMoney = 0;
      switch (currency) {
        case 'copper':
          heroMoney = hero.copperCoins;
          break;
        case 'silver':
          heroMoney = hero.silverCoins;
          break;
        case 'gold':
          heroMoney = hero.goldCoins;
          break;
        case 'platinum':
          heroMoney = hero.platinumCoins;
          break;
      }

      if (heroMoney < cost) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('У ${hero.name} недостаточно денег для покупки'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Списываем деньги
      final heroRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('heroes')
          .doc(hero.id);

      switch (currency) {
        case 'copper':
          await heroRef.update({'copperCoins': hero.copperCoins - cost});
          break;
        case 'silver':
          await heroRef.update({'silverCoins': hero.silverCoins - cost});
          break;
        case 'gold':
          await heroRef.update({'goldCoins': hero.goldCoins - cost});
          break;
        case 'platinum':
          await heroRef.update({'platinumCoins': hero.platinumCoins - cost});
          break;
      }

      // Добавляем предмет в инвентарь героя
      String itemType = '';
      String collectionField = '';

      if (_selectedTab == 0) {
        // Оружие
        itemType = 'Оружие';
        collectionField = 'weapons';
      } else if (_selectedTab == 1) {
        // Доспехи
        itemType = 'Доспех';
        collectionField = 'armors';
      } else {
        // Товары
        itemType = 'Товар';
        collectionField = 'goods';
      }

      final itemToAdd = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': item['name'] ?? item['title'] ?? 'Предмет',
        'type': itemType,
        'weight': item['weight'] ?? 0.0,
        'description': item['description'] ?? '',
        'cost': cost,
        'currency': currency,
        ...item,
      };

      await heroRef.update({
        collectionField: FieldValue.arrayUnion([itemToAdd]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['name'] ?? 'Предмет'} куплен для ${hero.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Ошибка покупки предмета: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка покупки: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: NewAppBar(title: 'Магазин'),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки магазина',
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadShopData,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              )
              : Column(
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
                                    color:
                                        selected
                                            ? Colors.white
                                            : Colors.white70,
                                    fontWeight:
                                        selected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Expanded(child: _buildTabContent()),
                ],
              ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildWeaponsTab();
      case 1:
        return _buildArmorsTab();
      case 2:
        return _buildGoodsTab();
      default:
        return const Center(child: Text('Неизвестная вкладка'));
    }
  }

  Widget _buildWeaponsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allWeapons.length,
      itemBuilder: (context, index) {
        final weapon = _allWeapons[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF2A2A2A),
          child: ListTile(
            title: Text(
              weapon.name ?? 'Неизвестное оружие',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weapon.description != null)
                  Text(
                    weapon.description!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                if (weapon.cost != null)
                  Text(
                    'Стоимость: ${weapon.cost} золотых',
                    style: const TextStyle(color: Colors.yellow),
                  ),
              ],
            ),
            trailing:
                weapon.cost != null
                    ? ElevatedButton(
                      onPressed:
                          () => _showHeroSelectionModal(
                            weapon.toJson(),
                            weapon.cost!,
                            'gold',
                          ),
                      child: const Text('Купить'),
                    )
                    : null,
          ),
        );
      },
    );
  }

  Widget _buildArmorsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allArmors.length,
      itemBuilder: (context, index) {
        final armor = _allArmors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF2A2A2A),
          child: ListTile(
            title: Text(
              armor.name ?? 'Неизвестный доспех',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (armor.description != null)
                  Text(
                    armor.description!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                if (armor.cost != null)
                  Text(
                    'Стоимость: ${armor.cost} золотых',
                    style: const TextStyle(color: Colors.yellow),
                  ),
              ],
            ),
            trailing:
                armor.cost != null
                    ? ElevatedButton(
                      onPressed:
                          () => _showHeroSelectionModal(
                            armor.toJson(),
                            armor.cost!,
                            'gold',
                          ),
                      child: const Text('Купить'),
                    )
                    : null,
          ),
        );
      },
    );
  }

  Widget _buildGoodsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allGoods.length,
      itemBuilder: (context, index) {
        final good = _allGoods[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF2A2A2A),
          child: ListTile(
            title: Text(
              good['name'] ?? good['title'] ?? 'Неизвестный товар',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (good['description'] != null)
                  Text(
                    good['description'],
                    style: const TextStyle(color: Colors.white70),
                  ),
                if (good['cost'] != null)
                  Text(
                    'Стоимость: ${good['cost']} золотых',
                    style: const TextStyle(color: Colors.yellow),
                  ),
              ],
            ),
            trailing:
                good['cost'] != null
                    ? ElevatedButton(
                      onPressed:
                          () => _showHeroSelectionModal(
                            good,
                            good['cost'],
                            'gold',
                          ),
                      child: const Text('Купить'),
                    )
                    : null,
          ),
        );
      },
    );
  }
}
