import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

@RoutePage()
class GlossaryScreen extends StatelessWidget {
  const GlossaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: NewAppBar(title: 'Глоссарий', actions: null),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 64,
              color: Colors.white.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Глоссарий',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Здесь будет содержимое глоссария',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
