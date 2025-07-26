import 'package:dio/dio.dart';
import 'app/dio_config.dart';
import '../models/weapon_model.dart';

class WeaponsService {
  static final Dio _dio = DioConfig.instance;

  /// Получить все оружие
  static Future<List<WeaponModel>> getAllWeapons() async {
    try {
      final response = await _dio.get('/weapons');

      if (response.statusCode == 200) {
        print('Ответ от сервера получен: ${response.statusCode}');
        final List<dynamic> data = response.data as List<dynamic>;
        print('Количество оружий в ответе: ${data.length}');

        // Проверяем первые несколько элементов
        if (data.isNotEmpty) {
          print('Первый элемент: ${data.first}');
          print('Тип первого элемента: ${data.first.runtimeType}');
        }

        final weapons = <WeaponModel>[];
        for (int i = 0; i < data.length; i++) {
          try {
            final json = data[i];
            if (json is Map<String, dynamic>) {
              // Проверяем проблемные поля перед парсингом
              if (json.containsKey('proficientCategory') &&
                  json['proficientCategory'] is String) {
                print(
                  'Элемент $i: proficientCategory приходит как строка: ${json['proficientCategory']}',
                );
              }
              if (json.containsKey('rangeCategory') &&
                  json['rangeCategory'] is String) {
                print(
                  'Элемент $i: rangeCategory приходит как строка: ${json['rangeCategory']}',
                );
              }
              if (json.containsKey('encumbranceCategory') &&
                  json['encumbranceCategory'] is String) {
                print(
                  'Элемент $i: encumbranceCategory приходит как строка: ${json['encumbranceCategory']}',
                );
              }
              if (json.containsKey('book') && json['book'] is String) {
                print('Элемент $i: book приходит как строка: ${json['book']}');
              }
              if (json.containsKey('parents') && json['parents'] is String) {
                print(
                  'Элемент $i: parents приходит как строка: ${json['parents']}',
                );
              }
              if (json.containsKey('childs') && json['childs'] is String) {
                print(
                  'Элемент $i: childs приходит как строка: ${json['childs']}',
                );
              }

              weapons.add(WeaponModel.fromJson(json));
            } else {
              print('Пропускаем элемент $i: неверный тип ${json.runtimeType}');
            }
          } catch (e) {
            print('Ошибка при парсинге элемента $i: $e');
            print('Данные элемента: ${data[i]}');
            // Показываем все ключи элемента
            if (data[i] is Map) {
              final map = data[i] as Map;
              print('Ключи элемента: ${map.keys.toList()}');
              for (final key in map.keys) {
                final value = map[key];
                print('  $key: ${value.runtimeType} = $value');
              }
            }
          }
        }

        // Отладочная информация о категориях
        print('Загружено оружий: ${weapons.length}');
        final categories =
            weapons
                .map((w) => w.proficientCategory?.name ?? 'null')
                .where((name) => name != 'null')
                .toSet()
                .toList();
        print('Найденные категории: $categories');

        // Проверяем первые несколько оружий
        print('Проверка первых 3 оружий:');
        for (int i = 0; i < 3 && i < weapons.length; i++) {
          final weapon = weapons[i];
          print(
            '  ${weapon.name}: proficientCategory=${weapon.proficientCategory?.name ?? "null"}',
          );
        }

        return weapons;
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
    print('getUniqueProficientCategories вызван с ${weapons.length} оружиями');

    final allCategories =
        weapons.map((w) => w.proficientCategory?.name ?? 'null').toList();
    print('Все категории (включая null): $allCategories');

    final categories =
        weapons
            .map((w) => w.proficientCategory?.name ?? '')
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList();
    categories.sort();

    print('Уникальные категории (без пустых): $categories');
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
