import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/app_colors.dart';

@RoutePage()
class GalarionMapScreen extends StatefulWidget {
  const GalarionMapScreen({super.key});

  @override
  State<GalarionMapScreen> createState() => _GalarionMapScreenState();
}

class _GalarionMapScreenState extends State<GalarionMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Карта Галариона',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Перезагрузить карту
            },
            tooltip: 'Обновить карту',
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Интерактивная карта Галариона
              Container(
                width: double.infinity,
                height: double.infinity,
                child: WebViewWidget(
                  controller:
                      WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..setNavigationDelegate(
                          NavigationDelegate(
                            onNavigationRequest: (NavigationRequest request) {
                              return NavigationDecision.navigate;
                            },
                          ),
                        )
                        ..loadRequest(
                          Uri.parse('https://map.pathfinderwiki.com/'),
                        ),
                ),
              ),

              // Легенда карты
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Легенда',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildLegendItem('🏰', 'Королевства'),
                      _buildLegendItem('🏘️', 'Города'),
                      _buildLegendItem('🌲', 'Леса'),
                      _buildLegendItem('⛰️', 'Горы'),
                      _buildLegendItem('🌊', 'Моря'),
                      _buildLegendItem('🏔️', 'Пустыни'),
                    ],
                  ),
                ),
              ),

              // Информационная панель
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Мир Галарион',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Интерактивная карта мира Pathfinder Wiki. Исследуйте королевства, города и земли мира Галарион с подробной информацией о каждой локации.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
