import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import '../../../models/hero_model.dart';
import 'hero_detail_screen.dart';
import 'create_hero_screen.dart';
import '../../theme/app_colors.dart';
import '../../components/cards/hero_card.dart';

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

  // Для поиска
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

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

  void _filterHeroes() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredHeroes = List.from(heroes);
      });
    } else {
      setState(() {
        filteredHeroes =
            heroes
                .where((hero) => hero.name.toLowerCase().contains(query))
                .toList();
      });
    }
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
            snapshot.docs
                .map((doc) => HeroModel.fromJson(doc.data(), id: doc.id))
                .toList();
      }
    } catch (e) {
      heroes = [];
    }
    setState(() {
      isLoading = false;
      filteredHeroes = List.from(heroes);
    });
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Редактирование персонажа "${hero.name}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: NewAppBar(
            title: 'Мои персонажи',
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isSearchActive = true;
                  });
                },
                tooltip: 'Поиск',
              ),
            ],
          ),
          body:
              isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                  : filteredHeroes.isEmpty
                  ? RefreshIndicator(
                    onRefresh: _loadHeroes,
                    color: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
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
                                      style: const TextStyle(
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
                                return HeroCard(
                                  hero: hero,
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => HeroDetailScreen(hero: hero),
                                      ),
                                    );
                                    await _loadHeroes();
                                  },
                                  onEdit: () => _editHero(hero),
                                  onDelete: () => _showDeleteDialog(hero),
                                );
                              },
                            ),
                          ),
                          // Кнопка добавления персонажа
                          Btn(
                            text: 'Создать персонажа',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateHeroScreen(),
                                ),
                              );
                              await _loadHeroes();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
        // Absolute positioned search bar
        if (_isSearchActive)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: AppColors.surface.withOpacity(0.98),
              elevation: 8,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Поиск персонажей...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                            filled: true,
                            fillColor: AppColors.primary.withOpacity(0.15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSearchActive = false;
                                  _searchController.clear();
                                  filteredHeroes = List.from(heroes);
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
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
