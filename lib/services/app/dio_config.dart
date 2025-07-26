import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioConfig {
  static const String _baseUrl = 'https://pathfinder.family/api';

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status != null && status < 500,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Отключаем проверку SSL сертификата
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (
      client,
    ) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    // Добавляем логирование для отладки
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ),
    );

    return dio;
  }

  static Dio get instance => createDio();
}
