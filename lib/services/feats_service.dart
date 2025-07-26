import 'package:dio/dio.dart';
import 'app/dio_config.dart';
import '../models/feat_model.dart';

class FeatsService {
  static const String _featsEndpoint = '/feats';

  /// Получает все черты с сервера
  static Future<List<FeatModel>> getAllFeats() async {
    try {
      final dio = DioConfig.instance;
      final response = await dio.get(_featsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => FeatModel.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки черт: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  /// Группирует черты по типам
  static Map<String, List<FeatModel>> groupFeatsByType(List<FeatModel> feats) {
    final Map<String, List<FeatModel>> groupedFeats = {};

    for (final feat in feats) {
      for (final type in feat.types) {
        if (!groupedFeats.containsKey(type.name)) {
          groupedFeats[type.name] = [];
        }
        groupedFeats[type.name]!.add(feat);
      }
    }

    // Сортируем черты в каждой группе по имени
    for (final type in groupedFeats.keys) {
      groupedFeats[type]!.sort((a, b) => a.name.compareTo(b.name));
    }

    return groupedFeats;
  }

  /// Получает уникальные типы черт
  static List<String> getUniqueTypes(List<FeatModel> feats) {
    final Set<String> types = {};
    for (final feat in feats) {
      for (final type in feat.types) {
        types.add(type.name);
      }
    }
    return types.toList()..sort();
  }
}
