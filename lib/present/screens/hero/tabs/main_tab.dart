import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../models/hero_model.dart';
import '../../../components/cards/card_value.dart';
import '../../../components/button/custom_tags.dart';
import '../../../components/head/section_head_info.dart';

class MainTab extends StatelessWidget {
  final HeroModel hero;
  final Function() onShowHpEditModal;
  final Function() onShowEditHeroModal;
  final Function(String, int, int?) onShowAbilityEditModal;
  final Function(String, int, int?, int?, int?, int?) onShowSaveEditModal;
  final VoidCallback onShowSpeedEditModal;

  const MainTab({
    super.key,
    required this.hero,
    required this.onShowHpEditModal,
    required this.onShowEditHeroModal,
    required this.onShowAbilityEditModal,
    required this.onShowSaveEditModal,
    required this.onShowSpeedEditModal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Карточка героя
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Увеличенный аватар
                Stack(
                  children: [
                    Container(
                      width: 160,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        ),
                        color: const Color(0xFF3A2A2A),
                      ),
                      child:
                          hero.photoPath != null && hero.photoPath!.isNotEmpty
                              ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  bottomLeft: Radius.circular(18),
                                ),
                                child: Image.file(
                                  File(hero.photoPath!),
                                  width: 160,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Center(
                                child: Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                    ),
                    // HP абсолютно внизу слева
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: GestureDetector(
                        onTap: onShowHpEditModal,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${hero.currentHp}',
                                style: const TextStyle(
                                  color: Color(0xFFD6B97B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' / ${hero.maxHp}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                // Информация о герое + карандаш
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hero.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                CustomTags(text: hero.characterClass),
                                CustomTags(text: hero.race),
                                CustomTags(text: hero.alignment),
                                CustomTags(text: '${hero.age} лет'),
                                CustomTags(text: hero.gender),
                                if (hero.archetype != null &&
                                    hero.archetype!.isNotEmpty)
                                  CustomTags(text: hero.archetype!),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: onShowEditHeroModal,
                          tooltip: 'Редактировать',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Прогресс-бар опыта
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'ОПЫТ',
                      style: TextStyle(
                        color: Color(0xFFD6B97B),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              '47235 / 53000', // TODO: заменить на '${hero.experience} / ${hero.experienceToLevelUp}'
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'УРОВЕНЬ 7', // TODO: заменить на 'УРОВЕНЬ ${hero.level}'
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value:
                        47235 /
                        53000, // TODO: заменить на hero.experience / hero.experienceToLevelUp
                    minHeight: 10,
                    backgroundColor: const Color(0xFF181818),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFD6B97B),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            child: Column(
              children: [
                SectionHeadInfo(title: 'Характеристики'),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1.6,
                  children: [
                    CardValue(
                      name: 'СИЛ',
                      params: _formatAbilityParams(
                        hero.strength,
                        hero.tempStrength,
                      ),
                      onTap:
                          () => onShowAbilityEditModal(
                            'СИЛ',
                            hero.strength,
                            hero.tempStrength,
                          ),
                    ),
                    CardValue(
                      name: 'ЛВК',
                      params: _formatAbilityParams(
                        hero.dexterity,
                        hero.tempDexterity,
                      ),
                      onTap:
                          () => onShowAbilityEditModal(
                            'ЛВК',
                            hero.dexterity,
                            hero.tempDexterity,
                          ),
                    ),
                    CardValue(
                      name: 'ВЫН',
                      params: _formatAbilityParams(
                        hero.constitution,
                        hero.tempConstitution,
                      ),
                      onTap:
                          () => onShowAbilityEditModal(
                            'ВЫН',
                            hero.constitution,
                            hero.tempConstitution,
                          ),
                    ),
                    CardValue(
                      name: 'ИНТ',
                      params: _formatAbilityParams(
                        hero.intelligence,
                        hero.tempIntelligence,
                      ),
                      onTap:
                          () => onShowAbilityEditModal(
                            'ИНТ',
                            hero.intelligence,
                            hero.tempIntelligence,
                          ),
                    ),
                    CardValue(
                      name: 'МДР',
                      params: _formatAbilityParams(
                        hero.wisdom,
                        hero.tempWisdom,
                      ),
                      onTap:
                          () => onShowAbilityEditModal(
                            'МДР',
                            hero.wisdom,
                            hero.tempWisdom,
                          ),
                    ),
                    CardValue(
                      name: 'ХАР',
                      params: _formatAbilityParams(
                        hero.charisma,
                        hero.tempCharisma,
                      ),
                      onTap:
                          () => onShowAbilityEditModal(
                            'ХАР',
                            hero.charisma,
                            hero.tempCharisma,
                          ),
                    ),
                  ],
                ),

                SectionHeadInfo(title: 'Испытания'),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1.5,
                  children: [
                    CardValue(
                      name: 'СТОЙ',
                      params: _formatSaveParams(
                        hero.constitution,
                        hero.tempConstitution,
                        hero.tempFortitude,
                        hero.miscFortitude,
                        hero.magicFortitude,
                      ),
                      onTap:
                          () => onShowSaveEditModal(
                            'СТОЙ',
                            hero.constitution,
                            hero.tempConstitution,
                            hero.tempFortitude,
                            hero.miscFortitude,
                            hero.magicFortitude,
                          ),
                    ),
                    CardValue(
                      name: 'РЕАК',
                      params: _formatSaveParams(
                        hero.dexterity,
                        hero.tempDexterity,
                        hero.tempReflex,
                        hero.miscReflex,
                        hero.magicReflex,
                      ),
                      onTap:
                          () => onShowSaveEditModal(
                            'РЕАК',
                            hero.dexterity,
                            hero.tempDexterity,
                            hero.tempReflex,
                            hero.miscReflex,
                            hero.magicReflex,
                          ),
                    ),
                    CardValue(
                      name: 'ВОЛЯ',
                      params: _formatSaveParams(
                        hero.wisdom,
                        hero.tempWisdom,
                        hero.tempWill,
                        hero.miscWill,
                        hero.magicWill,
                      ),
                      onTap:
                          () => onShowSaveEditModal(
                            'ВОЛЯ',
                            hero.wisdom,
                            hero.tempWisdom,
                            hero.tempWill,
                            hero.miscWill,
                            hero.magicWill,
                          ),
                    ),
                  ],
                ),
                SectionHeadInfo(title: 'Скорость'),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 2.2,
                  children: [
                    CardValue(
                      name: 'БЕЗ БРОНИ',
                      params: _formatSpeedParams(hero.baseSpeed ?? 30, 'фт'),
                      onTap: onShowSpeedEditModal,
                    ),
                    CardValue(
                      name: 'В БРОНЕ',
                      params: _formatSpeedParams(hero.armorSpeed ?? 20, 'фт'),
                      onTap: onShowSpeedEditModal,
                    ),
                    CardValue(
                      name: 'ПОЛЕТ',
                      params: _formatSpeedParams(hero.flySpeed, 'фт'),
                      onTap: onShowSpeedEditModal,
                    ),
                    CardValue(
                      name: 'ПЛАВАНИЕ',
                      params: _formatSpeedParams(hero.swimSpeed, 'фт'),
                      onTap: onShowSpeedEditModal,
                    ),
                    CardValue(
                      name: 'ЛАЗАНИЕ',
                      params: _formatSpeedParams(hero.climbSpeed, 'фт'),
                      onTap: onShowSpeedEditModal,
                    ),
                    CardValue(
                      name: 'РЫТЬЕ',
                      params: _formatSpeedParams(hero.burrowSpeed, 'фт'),
                      onTap: onShowSpeedEditModal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAbilityParams(int baseValue, int? tempValue) {
    final modifier = _calculateModifier(baseValue);
    final tempModifier =
        tempValue != null ? _calculateModifier(tempValue) : modifier;
    return tempValue != null
        ? '${tempModifier >= 0 ? '+' : ''}$tempModifier (${tempValue})'
        : '${modifier >= 0 ? '+' : ''}$modifier';
  }

  String _formatSaveParams(
    int baseAbility,
    int? tempAbility,
    int? tempSave,
    int? miscSave,
    int? magicSave,
  ) {
    final baseMod = _calculateModifier(baseAbility);
    final tempMod =
        tempAbility != null ? _calculateModifier(tempAbility) : baseMod;
    final level = int.tryParse(hero.level) ?? 1;
    final baseBonus = (level / 2).floor();
    final total =
        tempMod +
        baseBonus +
        (tempSave ?? 0) +
        (miscSave ?? 0) +
        (magicSave ?? 0);
    return (total >= 0 ? '+' : '') + total.toString();
  }

  String _formatSpeedParams(int? speed, String unit) {
    final speedValue = speed ?? 0;
    final cells = (speedValue / 5).floor();
    return '$speedValue $unit  |  $cells клет.';
  }

  int _calculateModifier(int value) {
    return ((value - 10) / 2).floor();
  }
}
