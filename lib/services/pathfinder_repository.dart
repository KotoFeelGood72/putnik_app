// Для работы требуется переменная окружения PATHFINDER_BASE_URL в .env
// Пример: PATHFINDER_BASE_URL=https://pathfinder.family/
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PathfinderRepository {
  final Dio _dio;
  final String _baseUrl;

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

  Future<List<dynamic>> fetchClasses() async {
    final response = await _dio.get(_baseUrl + 'api/classes');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Ошибка при получении классов: \\${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchArchetypes() async {
    final response = await _dio.get(_baseUrl + 'api/archetypes');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception(
        'Ошибка при получении архетипов: \\${response.statusCode}',
      );
    }
  }

  Future<List<dynamic>> fetchRaces() async {
    final response = await _dio.get(_baseUrl + 'api/races');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Ошибка при получении рас: \\${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchGods() async {
    final response = await _dio.get(_baseUrl + 'api/gods');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Ошибка при получении божеств: \\${response.statusCode}');
    }
  }
}
