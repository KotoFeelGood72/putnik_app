import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/routes/app_router.gr.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

@RoutePage()
class HeroListScreen extends StatelessWidget {
  const HeroListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // временный мок
    final heroes = [
      ('Аларик', 'Человек • Воин 4'),
      ('Т’риэль', 'Эльф • Маг 3'),
      ('Грим', 'Дварф • Жрец 2'),
      ('Лисса', 'Хафлинг • Плут 5'),
      ('Лисса', 'Хафлинг • Плут 5'),
      ('Лисса', 'Хафлинг • Плут 5'),
      ('Лисса', 'Хафлинг • Плут 5'),
      // ('Лисса', 'Хафлинг • Плут 5'),
      // ('Лисса', 'Хафлинг • Плут 5'),
      // ('Лисса', 'Хафлинг • Плут 5'),
      // ('Лисса', 'Хафлинг • Плут 5'),
      // ('Лисса', 'Хафлинг • Плут 5'),
    ];

    return Scaffold(
      appBar: NewAppBar(title: 'Персонажи'),

      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: heroes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final (name, subtitle) = heroes[i];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.blue.withOpacity(.15),
                foregroundColor: AppColors.blue,
                child: Text(name.characters.first),
              ),
              title: Text(name, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(subtitle),
              onTap: () {
                // TODO: открыть подробную карточку героя
              },
            ),
          );
        },
      ),
    );
  }
}
