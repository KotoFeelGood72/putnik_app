import 'package:dio/dio.dart';
import 'app/dio_config.dart';
import '../models/armor_model.dart';

class ArmorsService {
  static final Dio _dio = DioConfig.instance;

  /// Получить все доспехи
  static Future<List<ArmorModel>> getAllArmors() async {
    try {
      print('Начинаем загрузку доспехов...');
      final response = await _dio.get('/armors');

      if (response.statusCode == 200) {
        print('Ответ от сервера получен: ${response.statusCode}');
        final List<dynamic> data = response.data as List<dynamic>;
        print('Количество доспехов в ответе: ${data.length}');

        // Проверяем первые несколько элементов
        if (data.isNotEmpty) {
          print('Первый элемент: ${data.first}');
          print('Тип первого элемента: ${data.first.runtimeType}');
        }

        final armors = <ArmorModel>[];
        for (int i = 0; i < data.length; i++) {
          try {
            final json = data[i];
            if (json is Map<String, dynamic>) {
              // Проверяем проблемные поля перед парсингом
              if (json.containsKey('armorCategory') &&
                  json['armorCategory'] is String) {
                print(
                  'Элемент $i: armorCategory приходит как строка: ${json['armorCategory']}',
                );
              }
              if (json.containsKey('book') && json['book'] is String) {
                print('Элемент $i: book приходит как строка: ${json['book']}');
              }

              armors.add(ArmorModel.fromJson(json));
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
        print('Загружено доспехов: ${armors.length}');
        final categories =
            armors
                .map((w) => w.armorCategory?.name ?? 'null')
                .where((name) => name != 'null')
                .toSet()
                .toList();
        print('Найденные категории: $categories');

        // Проверяем первые несколько доспехов
        print('Проверка первых 3 доспехов:');
        for (int i = 0; i < 3 && i < armors.length; i++) {
          final armor = armors[i];
          print(
            '  ${armor.name}: armorCategory=${armor.armorCategory?.name ?? "null"}',
          );
        }

        return armors;
      } else {
        throw Exception(
          'Ошибка при получении доспехов: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Ошибка при получении доспехов: $e');
    }
  }

  /// Группировать доспехи по категории
  static Map<String, List<ArmorModel>> groupArmorsByCategory(
    List<ArmorModel> armors,
  ) {
    final Map<String, List<ArmorModel>> grouped = {};
    for (final armor in armors) {
      final category = armor.armorCategory?.name ?? '';
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(armor);
    }
    return grouped;
  }

  /// Получить уникальные категории доспехов
  static List<String> getUniqueArmorCategories(List<ArmorModel> armors) {
    print('getUniqueArmorCategories вызван с ${armors.length} доспехами');

    final allCategories =
        armors.map((w) => w.armorCategory?.name ?? 'null').toList();
    print('Все категории (включая null): $allCategories');

    final categories =
        armors
            .map((w) => w.armorCategory?.name ?? '')
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList();
    categories.sort();

    print('Уникальные категории (без пустых): $categories');
    return categories;
  }
}
