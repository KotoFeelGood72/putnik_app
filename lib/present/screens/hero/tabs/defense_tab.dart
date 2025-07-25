import 'package:flutter/material.dart';
import '../../../../models/hero_model.dart';
import '../../../components/cards/card_value.dart';
import '../../../components/head/section_head_info.dart';

class DefenseTab extends StatelessWidget {
  final HeroModel hero;
  final Function(String, int, int, int, int, int, int) onShowDefenseEditModal;

  const DefenseTab({
    super.key,
    required this.hero,
    required this.onShowDefenseEditModal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SectionHeadInfo(title: 'Защита'),
          Row(
            children: [
              Expanded(
                child: CardValue(
                  name: 'КБ',
                  params: _formatACParams(
                    hero.dexterity,
                    hero.tempDexterity,
                    hero.armorBonus ?? 0,
                    hero.shieldBonus ?? 0,
                    hero.naturalArmor ?? 0,
                    hero.deflectionBonus ?? 0,
                    hero.miscACBonus ?? 0,
                    hero.sizeModifier ?? 0,
                  ),
                  onTap:
                      () => onShowDefenseEditModal(
                        'КБ',
                        hero.armorBonus ?? 0,
                        hero.shieldBonus ?? 0,
                        hero.naturalArmor ?? 0,
                        hero.deflectionBonus ?? 0,
                        hero.miscACBonus ?? 0,
                        hero.sizeModifier ?? 0,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CardValue(
                  name: 'КАСАНИЕ',
                  params: _formatACParams(
                    hero.dexterity,
                    hero.tempDexterity,
                    0,
                    0,
                    hero.naturalArmor ?? 0,
                    hero.deflectionBonus ?? 0,
                    hero.miscACBonus ?? 0,
                    hero.sizeModifier ?? 0,
                  ),
                  onTap: () => (),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CardValue(
                  name: 'ВРАСПЛОХ',
                  params: _formatACParams(
                    0,
                    0,
                    hero.armorBonus ?? 0,
                    hero.shieldBonus ?? 0,
                    hero.naturalArmor ?? 0,
                    hero.deflectionBonus ?? 0,
                    hero.miscACBonus ?? 0,
                    hero.sizeModifier ?? 0,
                  ),
                  onTap: () => (),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: CardValue(
              name: 'УСТОЙЧИВОСТЬ К МАГИИ',
              params: hero.spellResistance.toString(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatACParams(
    int? baseDexterity,
    int? tempDexterity,
    int armorBonus,
    int shieldBonus,
    int naturalArmor,
    int deflectionBonus,
    int miscACBonus,
    int sizeModifier,
  ) {
    final dexterityModifier =
        baseDexterity != null ? _calculateModifier(baseDexterity) : 0;
    final tempDexterityModifier =
        tempDexterity != null
            ? _calculateModifier(tempDexterity)
            : dexterityModifier;
    final baseAC = 10;
    final totalAC =
        baseAC +
        armorBonus +
        shieldBonus +
        tempDexterityModifier +
        sizeModifier +
        naturalArmor +
        deflectionBonus +
        miscACBonus;
    return totalAC.toString();
  }

  int _calculateModifier(int value) {
    return ((value - 10) / 2).floor();
  }
}
