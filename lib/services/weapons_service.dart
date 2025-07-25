import 'package:dio/dio.dart';
import '../models/weapon_model.dart';

class WeaponsService {
  static final Dio _dio = Dio();
  static const String _baseUrl = 'https://pathfinder.family/api';

  /// Получить все оружие
  static Future<List<WeaponModel>> getAllWeapons() async {
    try {
      final response = await _dio.get('$_baseUrl/weapons');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => WeaponModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Ошибка при получении оружия: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при получении оружия: $e');
    }
  }

  /// Группировать оружие по категории владения
  static Map<String, List<WeaponModel>> groupWeaponsByProficientCategory(
    List<WeaponModel> weapons,
  ) {
    final Map<String, List<WeaponModel>> grouped = {};
    for (final weapon in weapons) {
      final category = weapon.proficientCategory?.name ?? '';
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(weapon);
    }
    return grouped;
  }

  /// Получить уникальные категории владения
  static List<String> getUniqueProficientCategories(List<WeaponModel> weapons) {
    final categories =
        weapons
            .map((w) => w.proficientCategory?.name ?? '')
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList();
    categories.sort();
    return categories;
  }

  /// Группировать оружие по типу дистанции
  static Map<String, List<WeaponModel>> groupWeaponsByRangeCategory(
    List<WeaponModel> weapons,
  ) {
    final Map<String, List<WeaponModel>> grouped = {};
    for (final weapon in weapons) {
      final category = weapon.rangeCategory?.name ?? '';
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(weapon);
    }
    return grouped;
  }

  /// Получить уникальные типы дистанции
  static List<String> getUniqueRangeCategories(List<WeaponModel> weapons) {
    final categories =
        weapons
            .map((w) => w.rangeCategory?.name ?? '')
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList();
    categories.sort();
    return categories;
  }
}
