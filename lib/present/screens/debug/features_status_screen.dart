import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/services/app/app_service.dart';

@RoutePage()
class FeaturesStatusScreen extends StatefulWidget {
  const FeaturesStatusScreen({super.key});

  @override
  State<FeaturesStatusScreen> createState() => _FeaturesStatusScreenState();
}

class _FeaturesStatusScreenState extends State<FeaturesStatusScreen> {
  final AppService _appService = AppService();
  Map<String, bool> _featuresStatus = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFeatures();
  }

  Future<void> _checkFeatures() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await _appService.checkAllFeatures();
      setState(() {
        _featuresStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при проверке функций: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NewAppBar(
        title: 'Статус функций',
        onBack: () => Navigator.of(context).maybePop(),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _checkFeatures,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Общий статус
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Общий статус',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _appService.getFeatureStatusMessage(),
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Детальный статус функций
                    Text(
                      'Детальный статус',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: ListView(
                        children: [
                          _buildFeatureCard(
                            title: 'Firebase',
                            description: 'База данных и аутентификация',
                            isAvailable: _featuresStatus['firebase'] ?? false,
                            icon: Icons.cloud,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            title: 'Уведомления',
                            description:
                                'Push-уведомления и локальные уведомления',
                            isAvailable:
                                _featuresStatus['notifications'] ?? false,
                            icon: Icons.notifications,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            title: 'Камера',
                            description: 'Съемка фотографий',
                            isAvailable: _featuresStatus['camera'] ?? false,
                            icon: Icons.camera_alt,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureCard(
                            title: 'Галерея',
                            description: 'Выбор изображений из галереи',
                            isAvailable: _featuresStatus['gallery'] ?? false,
                            icon: Icons.photo_library,
                          ),
                        ],
                      ),
                    ),

                    // Рекомендации
                    if (_featuresStatus.values.any(
                      (available) => !available,
                    )) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.warning),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Рекомендации',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Для полной функциональности приложения:\n'
                              '• Настройте аккаунт разработчика в Xcode\n'
                              '• Добавьте необходимые разрешения в Info.plist\n'
                              '• Настройте Firebase в проекте',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required bool isAvailable,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable ? AppColors.success : AppColors.error,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.success : AppColors.error,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.success : AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isAvailable ? 'Доступно' : 'Недоступно',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
