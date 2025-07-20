import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../models/hero_model.dart';
import 'hero_detail_screen.dart';
import 'create_hero_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_colors.dart';

@RoutePage()
class HeroListScreen extends StatefulWidget {
  const HeroListScreen({super.key});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  List<HeroModel> heroes = [];
  List<HeroModel> filteredHeroes = [];
  bool isLoading = true;

  // Поиск и фильтрация
  final TextEditingController _searchController = TextEditingController();
  String _selectedRace = 'Все расы';
  String _selectedClass = 'Все классы';
  String _selectedLevel = 'Все уровни';
  bool _isSearchExpanded = false;

  // Списки для фильтров
  List<String> races = ['Все расы'];
  List<String> classes = ['Все классы'];
  List<String> levels = ['Все уровни'];

  @override
  void initState() {
    super.initState();
    _loadHeroes();
    _searchController.addListener(_filterHeroes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHeroes() async {
    setState(() => isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        heroes = [];
      } else {
        final snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('heroes')
                .get();
        heroes =
            snapshot.docs.map((doc) => HeroModel.fromJson(doc.data())).toList();

        // Обновляем списки для фильтров
        _updateFilterLists();
      }
    } catch (e) {
      heroes = [];
    }
    setState(() {
      isLoading = false;
      _filterHeroes();
    });
  }

  void _updateFilterLists() {
    // Обновляем списки для фильтров
    final heroRaces = heroes.map((h) => h.race).toSet().toList()..sort();
    final heroClasses =
        heroes.map((h) => h.characterClass).toSet().toList()..sort();
    final heroLevels = heroes.map((h) => h.level).toSet().toList()..sort();

    setState(() {
      races = ['Все расы', ...heroRaces];
      classes = ['Все классы', ...heroClasses];
      levels = ['Все уровни', ...heroLevels];
    });
  }

  void _filterHeroes() {
    final searchQuery = _searchController.text.toLowerCase();

    filteredHeroes =
        heroes.where((hero) {
          // Поиск по имени
          final matchesSearch = hero.name.toLowerCase().contains(searchQuery);

          // Фильтр по расе
          final matchesRace =
              _selectedRace == 'Все расы' || hero.race == _selectedRace;

          // Фильтр по классу
          final matchesClass =
              _selectedClass == 'Все классы' ||
              hero.characterClass == _selectedClass;

          // Фильтр по уровню
          final matchesLevel =
              _selectedLevel == 'Все уровни' || hero.level == _selectedLevel;

          return matchesSearch && matchesRace && matchesClass && matchesLevel;
        }).toList();

    setState(() {});
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedRace = 'Все расы';
      _selectedClass = 'Все классы';
      _selectedLevel = 'Все уровни';
      _isSearchExpanded = false;
    });
    _filterHeroes();
  }

  Future<void> _deleteHero(HeroModel hero) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Находим документ по данным героя
        final snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('heroes')
                .where('name', isEqualTo: hero.name)
                .where('race', isEqualTo: hero.race)
                .where('characterClass', isEqualTo: hero.characterClass)
                .get();

        if (snapshot.docs.isNotEmpty) {
          await snapshot.docs.first.reference.delete();
          await _loadHeroes();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Персонаж "${hero.name}" удален')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка при удалении персонажа'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _editHero(HeroModel hero) {
    // Здесь можно добавить навигацию к экрану редактирования
    // Пока что просто показываем сообщение
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Редактирование персонажа "${hero.name}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои персонажи', style: TextStyle(fontSize: 18)),
        actions: [
          // Поиск
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                  _filterHeroes();
                }
              });
            },
            icon: Icon(
              _isSearchExpanded ? Icons.close : Icons.search,
              color: Colors.white,
              size: 20,
            ),
            tooltip: 'Поиск персонажей',
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isSearchExpanded ? 60 : 0,
            child:
                _isSearchExpanded
                    ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Поиск персонажей...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          suffixIcon:
                              _searchController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterHeroes();
                                    },
                                  )
                                  : null,
                          filled: true,
                          fillColor: AppColors.primary.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    )
                    : null,
          ),

          // Фильтры
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        value: _selectedRace,
                        items: races,
                        label: 'Раса',
                        onChanged: (value) {
                          setState(() => _selectedRace = value!);
                          _filterHeroes();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterDropdown(
                        value: _selectedClass,
                        items: classes,
                        label: 'Класс',
                        onChanged: (value) {
                          setState(() => _selectedClass = value!);
                          _filterHeroes();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterDropdown(
                        value: _selectedLevel,
                        items: levels,
                        label: 'Уровень',
                        onChanged: (value) {
                          setState(() => _selectedLevel = value!);
                          _filterHeroes();
                        },
                      ),
                    ),
                  ],
                ),

                // Кнопка сброса фильтров
                if (_selectedRace != 'Все расы' ||
                    _selectedClass != 'Все классы' ||
                    _selectedLevel != 'Все уровни' ||
                    _searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton.icon(
                      onPressed: _resetFilters,
                      icon: const Icon(
                        Icons.clear_all,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: const Text(
                        'Сбросить фильтры',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Список персонажей
          Expanded(
            child:
                isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                    : filteredHeroes.isEmpty
                    ? RefreshIndicator(
                      onRefresh: _loadHeroes,
                      color: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 300,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.sentiment_dissatisfied,
                                        size: 64,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        heroes.isEmpty
                                            ? 'Нет созданных персонажей'
                                            : 'Персонажи не найдены',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        heroes.isEmpty
                                            ? 'Создайте своего первого героя'
                                            : 'Попробуйте изменить параметры поиска',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: _loadHeroes,
                      color: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemCount: filteredHeroes.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final hero = filteredHeroes[index];
                                  return _buildHeroCard(hero);
                                },
                              ),
                            ),
                            // Кнопка добавления персонажа
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 16),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CreateHeroScreen(),
                                    ),
                                  );
                                  await _loadHeroes();
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: const Text(
                                  'Создать персонажа',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required String label,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
        ),
        dropdownColor: AppColors.surface,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
        style: const TextStyle(color: Colors.white, fontSize: 12),
        isExpanded: true,
      ),
    );
  }

  Widget _buildHeroCard(HeroModel hero) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _editHero(hero),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Изменить',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          SlidableAction(
            onPressed: (_) => _showDeleteDialog(hero),
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HeroDetailScreen(hero: hero)),
            );
            await _loadHeroes();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Верхняя часть с изображением и основной информацией
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Изображение героя
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/icons/cup.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Основная информация
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hero.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  hero.race,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.amber.withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  hero.characterClass,
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  'Ур. ${hero.level}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.5),
                      size: 16,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Сетка характеристик
                Row(
                  children: [
                    Expanded(child: _buildStatItem('Сил', hero.strength)),
                    Expanded(child: _buildStatItem('Лов', hero.dexterity)),
                    Expanded(child: _buildStatItem('Вын', hero.constitution)),
                    Expanded(child: _buildStatItem('Инт', hero.intelligence)),
                    Expanded(child: _buildStatItem('Мдр', hero.wisdom)),
                    Expanded(child: _buildStatItem('Хар', hero.charisma)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(HeroModel hero) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Удалить персонажа?',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Вы уверены, что хотите удалить персонажа "${hero.name}"? Это действие нельзя отменить.',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteHero(hero);
              },
              child: const Text(
                'Удалить',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
