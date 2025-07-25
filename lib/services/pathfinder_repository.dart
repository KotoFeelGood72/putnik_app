import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PathfinderRepository {
  final Dio _dio;
  final String _baseUrl;

  // Кэш для навыков
  static Map<String, dynamic>? _skillsCache;
  static DateTime? _lastCacheTime;
  static const Duration cacheDuration = Duration(minutes: 30);

  PathfinderRepository({Dio? dio})
    : _dio = dio ?? Dio(),
      _baseUrl =
          dotenv.env['PATHFINDER_BASE_URL'] ?? 'https://pathfinder.family/' {
    // Отключаем проверку сертификата только для разработки!
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  // Получение классов
  Future<List<dynamic>> fetchClasses() async {
    final response = await _dio.get('${_baseUrl}api/classes');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Ошибка при получении классов: ${response.statusCode}');
    }
  }

  // Получение архетипов
  Future<List<dynamic>> fetchArchetypes() async {
    final response = await _dio.get('${_baseUrl}api/archetypes');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Ошибка при получении архетипов: ${response.statusCode}');
    }
  }

  // Получение рас
  Future<List<dynamic>> fetchRaces() async {
    final response = await _dio.get('${_baseUrl}api/races');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Ошибка при получении рас: ${response.statusCode}');
    }
  }

  // Получение божеств
  Future<List<dynamic>> fetchGods() async {
    final response = await _dio.get('${_baseUrl}api/gods');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Ошибка при получении божеств: ${response.statusCode}');
    }
  }

  // Получение навыков с кэшированием
  Future<Map<String, dynamic>> getSkills() async {
    // Проверяем кэш
    if (_skillsCache != null && _lastCacheTime != null) {
      final timeSinceLastCache = DateTime.now().difference(_lastCacheTime!);
      if (timeSinceLastCache < cacheDuration) {
        return _skillsCache!;
      }
    }

    try {
      final response = await _dio.get('${_baseUrl}api/skills');

      if (response.statusCode == 200) {
        final data = response.data;
        _skillsCache = data;
        _lastCacheTime = DateTime.now();
        return data;
      } else {
        throw Exception('Ошибка загрузки навыков: ${response.statusCode}');
      }
    } catch (e) {
      // Если ошибка сети, возвращаем кэш если есть
      if (_skillsCache != null) {
        return _skillsCache!;
      }
      throw Exception('Ошибка сети: $e');
    }
  }

  // Получение навыков с классами
  Future<List<Map<String, dynamic>>> getSkillsWithClasses() async {
    final data = await getSkills();
    final skillsWithClasses = data['skillsWithClasses'] as List;
    return skillsWithClasses.cast<Map<String, dynamic>>();
  }

  // Получение информации о конкретном навыке
  Future<Map<String, dynamic>?> getSkillInfo(String skillName) async {
    final skills = await getSkillsWithClasses();
    return skills.firstWhere(
      (skill) => skill['name'] == skillName,
      orElse: () => <String, dynamic>{},
    );
  }

  // Проверка, является ли навык классовым для конкретного класса
  Future<bool> isClassSkill(String skillName, String className) async {
    final skillInfo = await getSkillInfo(skillName);
    if (skillInfo == null || skillInfo.isEmpty) return false;

    final classes = skillInfo['classes'] as List?;
    if (classes == null) return false;

    for (final classInfo in classes) {
      if (classInfo['name'] == className) {
        return classInfo['isClassSkill'] == true;
      }
    }

    return false;
  }

  // Проверка, требует ли навык изучения
  Future<bool> requiresStudy(String skillName) async {
    final skillInfo = await getSkillInfo(skillName);
    if (skillInfo == null || skillInfo.isEmpty) return false;

    // Навыки знаний и языки требуют изучения
    final name = skillInfo['name'] as String?;
    if (name == null) return false;

    return name.startsWith('ЗНАНИЕ') || name == 'ЯЗЫКОЗНАНИЕ';
  }

  // Получение способности для навыка
  String getAbilityForSkill(String skillName) {
    // Маппинг навыков к способностям
    final skillAbilityMap = {
      // Основные навыки (русские названия)
      'Акробатика': 'ЛВК',
      'Блеф': 'ХАР',
      'Верховая езда': 'ЛВК',
      'Внимание': 'МДР',
      'Выживание': 'МДР',
      'Дипломатия': 'ХАР',
      'Запугивание': 'ХАР',
      'Изворотливость': 'ЛВК',
      'Лазание': 'СИЛ',
      'Лечение': 'МДР',
      'Маскировка': 'ХАР',
      'Оценка': 'ИНТ',
      'Плавание': 'СИЛ',
      'Полёт': 'ЛВК',
      'Проницательность': 'МДР',
      'Скрытность': 'ЛВК',

      // Навыки знаний (русские названия)
      'Знание (высший свет)': 'ИНТ',
      'Знание (география)': 'ИНТ',
      'Знание (инженерное дело)': 'ИНТ',
      'Знание (история)': 'ИНТ',
      'Знание (краеведение)': 'ИНТ',
      'Знание (магия)': 'ИНТ',
      'Знание (планы)': 'ИНТ',
      'Знание (подземелья)': 'ИНТ',
      'Знание (природа)': 'ИНТ',
      'Знание (религия)': 'ИНТ',

      // Другие навыки (русские названия)
      'Языкознание': 'ИНТ',
      'Исполнение (пение)': 'ХАР',
      'Исполнение (танец)': 'ХАР',
      'Профессия (повар)': 'МДР',
      'Профессия (писарь)': 'МДР',
      'Ремесло (кузнечное дело)': 'ИНТ',
      'Ремесло (столярное дело)': 'ИНТ',
      'Ремесло (алхимия)': 'ИНТ',

      // Альтернативные названия (если API возвращает другие варианты)
      'Acrobatics': 'ЛВК',
      'Bluff': 'ХАР',
      'Climb': 'СИЛ',
      'Diplomacy': 'ХАР',
      'Disable Device': 'ЛВК',
      'Disguise': 'ХАР',
      'Escape Artist': 'ЛВК',
      'Fly': 'ЛВК',
      'Handle Animal': 'ХАР',
      'Heal': 'МДР',
      'Intimidate': 'ХАР',
      'Knowledge (Arcana)': 'ИНТ',
      'Knowledge (Dungeoneering)': 'ИНТ',
      'Knowledge (Engineering)': 'ИНТ',
      'Knowledge (Geography)': 'ИНТ',
      'Knowledge (History)': 'ИНТ',
      'Knowledge (Local)': 'ИНТ',
      'Knowledge (Nature)': 'ИНТ',
      'Knowledge (Nobility)': 'ИНТ',
      'Knowledge (Planes)': 'ИНТ',
      'Knowledge (Religion)': 'ИНТ',
      'Linguistics': 'ИНТ',
      'Perception': 'МДР',
      'Perform (Act)': 'ХАР',
      'Perform (Comedy)': 'ХАР',
      'Perform (Dance)': 'ХАР',
      'Perform (Keyboard Instruments)': 'ХАР',
      'Perform (Oratory)': 'ХАР',
      'Perform (Percussion Instruments)': 'ХАР',
      'Perform (Sing)': 'ХАР',
      'Perform (String Instruments)': 'ХАР',
      'Perform (Wind Instruments)': 'ХАР',
      'Profession (Barrister)': 'МДР',
      'Profession (Bookkeeper)': 'МДР',
      'Profession (Cook)': 'МДР',
      'Profession (Courtesan)': 'МДР',
      'Profession (Driver)': 'МДР',
      'Profession (Engineer)': 'МДР',
      'Profession (Farmer)': 'МДР',
      'Profession (Fisherman)': 'МДР',
      'Profession (Gambler)': 'МДР',
      'Profession (Gardener)': 'МДР',
      'Profession (Herbalist)': 'МДР',
      'Profession (Innkeeper)': 'МДР',
      'Profession (Librarian)': 'МДР',
      'Profession (Merchant)': 'МДР',
      'Profession (Midwife)': 'МДР',
      'Profession (Miller)': 'МДР',
      'Profession (Miner)': 'МДР',
      'Profession (Porter)': 'МДР',
      'Profession (Sailor)': 'МДР',
      'Profession (Scribe)': 'МДР',
      'Profession (Shepherd)': 'МДР',
      'Profession (Stable Master)': 'МДР',
      'Profession (Soldier)': 'МДР',
      'Profession (Tanner)': 'МДР',
      'Profession (Teamster)': 'МДР',
      'Profession (Woodcutter)': 'МДР',
      'Ride': 'ЛВК',
      'Sense Motive': 'МДР',
      'Sleight of Hand': 'ЛВК',
      'Spellcraft': 'ИНТ',
      'Stealth': 'ЛВК',
      'Survival': 'МДР',
      'Swim': 'СИЛ',
      'Use Magic Device': 'ХАР',
    };

    return skillAbilityMap[skillName] ?? 'ИНТ';
  }
}
