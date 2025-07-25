import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:putnik_app/services/providers/pathfinder_provider.dart';
import '../../../models/hero_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'input_field.dart';
import 'package:putnik_app/present/components/inputs/custom_bottom_sheet_select.dart';

@RoutePage()
class CreateHeroScreen extends StatefulWidget {
  const CreateHeroScreen({super.key});

  @override
  State<CreateHeroScreen> createState() => _CreateHeroScreenState();
}

class _CreateHeroScreenState extends State<CreateHeroScreen> {
  final _formKey = GlobalKey<FormState>();

  // === БАЗОВАЯ ИНФОРМАЦИЯ ===
  String name = '';
  String race = '';
  String characterClass = '';
  String alignment = '';
  String deity = '';
  String homeland = '';
  String gender = '';
  String ageStr = '';
  String height = '';
  String weight = '';
  String hair = '';
  String eyes = '';
  String levelStr = '';
  String size = '';
  int age = 18;
  int level = 1;
  int maxHitPoints = 0;
  int currentHitPoints = 0;
  int strength = 10;
  int dexterity = 10;
  int constitution = 10;
  int intelligence = 10;
  int wisdom = 10;
  int charisma = 10;
  String selectedArchetype = '';

  // === НАВЫКИ ===
  Map<String, int> skills = {};
  List<String> languages = [];

  // --- Pathfinder lists ---
  final List<String> alignments = [
    'Законопослушный добрый',
    'Нейтральный добрый',
    'Хаотичный добрый',
    'Законопослушный нейтральный',
    'Истинно нейтральный',
    'Хаотичный нейтральный',
    'Законопослушный злой',
    'Нейтральный злой',
    'Хаотичный злой',
  ];
  final List<String> genders = ['Мужской', 'Женский', 'Другое'];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveHero() async {
    final hero = HeroModel(
      id: null,
      name: name,
      race: race,
      characterClass: characterClass,
      alignment: alignment,
      deity: deity,
      homeland: homeland,
      gender: gender,
      age: age.toString(),
      height: height,
      weight: weight,
      hair: hair,
      eyes: eyes,
      level: level.toString(),
      size: size,
      strength: strength,
      dexterity: dexterity,
      constitution: constitution,
      intelligence: intelligence,
      wisdom: wisdom,
      charisma: charisma,
      endurance: constitution,
      maxHp: maxHitPoints,
      currentHp: currentHitPoints,
      skills: skills,
      weapons: const [],
      languages: languages,
      skillDetails: const [],
      feats: const [],
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('heroes')
        .add(hero.toJson());
    hero.id = docRef.id;

    if (mounted) {
      Navigator.pop(context, hero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: NewAppBar(title: 'Создание персонажа'),
      body: Consumer(
        builder: (context, ref, _) {
          final asyncArchetypes = ref.watch(pathfinderArchetypesProvider);
          final asyncGods = ref.watch(pathfinderGodsProvider);
          final asyncRaces = ref.watch(pathfinderRacesProvider);

          final isLoading =
              asyncArchetypes.isLoading ||
              asyncGods.isLoading ||
              asyncRaces.isLoading;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Можно добавить обработку ошибок, если нужно

          final archetypesList = asyncArchetypes.value ?? [];
          final classNames =
              archetypesList.map<String>((c) => c['name'] as String).toList();
          final godsList = asyncGods.value ?? [];
          final godNames =
              godsList.map<String>((g) => g['name'] as String).toList();
          final racesList = asyncRaces.value ?? [];
          final raceNames =
              racesList.map<String>((r) => r['name'] as String).toList();

          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 12,
                        children: [
                          InputField(
                            placeholder: 'Имя персонажа',
                            initialValue: name,
                            onChanged: (v) => setState(() => name = v),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomBottomSheetSelect(
                                      label: 'Класс',
                                      value: characterClass,
                                      items: classNames,
                                      onChanged:
                                          (v) => setState(() {
                                            characterClass = v;
                                            selectedArchetype = '';
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                              if (characterClass.isNotEmpty)
                                Builder(
                                  builder: (context) {
                                    final classObj = archetypesList.firstWhere(
                                      (c) => c['name'] == characterClass,
                                      orElse: () => null,
                                    );
                                    final archetypes =
                                        classObj != null &&
                                                classObj['archetypes'] != null
                                            ? List<Map<String, dynamic>>.from(
                                              classObj['archetypes'],
                                            )
                                            : [];
                                    if (archetypes.isEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          'Нет архетипов для этого класса',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: CustomBottomSheetSelect(
                                        label: 'Архетип',
                                        value: selectedArchetype,
                                        items:
                                            archetypes
                                                .map((a) => a['name'] as String)
                                                .toList(),
                                        onChanged:
                                            (v) => setState(
                                              () => selectedArchetype = v,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  label: 'Лет',
                                  placeholder: '',
                                  initialValue: age.toString(),
                                  onChanged:
                                      (v) => setState(
                                        () => age = int.tryParse(v) ?? 0,
                                      ),
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomBottomSheetSelect(
                                  label: 'Пол',
                                  value: gender,
                                  items: genders,
                                  onChanged: (v) => setState(() => gender = v),
                                ),
                              ),
                            ],
                          ),
                          CustomBottomSheetSelect(
                            label: 'Мировоззрение',
                            value: alignment,
                            items: alignments,
                            onChanged: (v) => setState(() => alignment = v),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomBottomSheetSelect(
                                  label: 'Божество',
                                  value: deity,
                                  items: godNames,
                                  onChanged: (v) => setState(() => deity = v),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomBottomSheetSelect(
                                  label: 'Раса',
                                  value: race,
                                  items: raceNames,
                                  onChanged: (v) => setState(() => race = v),
                                ),
                              ),
                            ],
                          ),
                          InputField(
                            label: 'Уровень',
                            placeholder: '',
                            initialValue: level.toString(),
                            onChanged:
                                (v) => setState(
                                  () => level = int.tryParse(v) ?? 1,
                                ),
                            isNumber: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Btn(
                    text: 'Создать',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _saveHero();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
