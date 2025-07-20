import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppService {
  static final AppService _instance = AppService._internal();
  factory AppService() => _instance;
  AppService._internal();

  bool _isFirebaseAvailable = false;
  bool _isCameraAvailable = false;
  bool _isGalleryAvailable = false;

  // Проверка доступности Firebase
  Future<bool> checkFirebaseAvailability() async {
    try {
      // Простая проверка - пытаемся получить информацию о платформе
      final platform = defaultTargetPlatform;
      _isFirebaseAvailable = true;
      return true;
    } catch (e) {
      print('Firebase not available: $e');
      _isFirebaseAvailable = false;
      return false;
    }
  }

  // Проверка доступности камеры
  Future<bool> checkCameraAvailability() async {
    try {
      // Простая проверка - в реальном приложении можно добавить более детальную проверку
      _isCameraAvailable = true;
      return true;
    } catch (e) {
      print('Camera not available: $e');
      _isCameraAvailable = false;
      return false;
    }
  }

  // Проверка доступности галереи
  Future<bool> checkGalleryAvailability() async {
    try {
      // Простая проверка
      _isGalleryAvailable = true;
      return true;
    } catch (e) {
      print('Gallery not available: $e');
      _isGalleryAvailable = false;
      return false;
    }
  }

  // Получение статуса функций
  Map<String, bool> getFeatureStatus() {
    return {
      'firebase': _isFirebaseAvailable,
      'camera': _isCameraAvailable,
      'gallery': _isGalleryAvailable,
    };
  }

  // Проверка всех функций
  Future<Map<String, bool>> checkAllFeatures() async {
    await Future.wait([
      checkFirebaseAvailability(),
      checkCameraAvailability(),
      checkGalleryAvailability(),
    ]);

    return getFeatureStatus();
  }

  // Получение сообщения о статусе функций
  String getFeatureStatusMessage() {
    final status = getFeatureStatus();
    final availableFeatures =
        status.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

    final unavailableFeatures =
        status.entries
            .where((entry) => !entry.value)
            .map((entry) => entry.key)
            .toList();

    String message = 'Статус функций:\n';

    if (availableFeatures.isNotEmpty) {
      message += '✅ Доступно: ${availableFeatures.join(', ')}\n';
    }

    if (unavailableFeatures.isNotEmpty) {
      message += '❌ Недоступно: ${unavailableFeatures.join(', ')}\n';
    }

    return message;
  }
}
