import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/app/main_bar.dart';
import 'package:putnik_app/present/routes/app_router.gr.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: AutoTabsScaffold(
        routes: [
          HeroListRoute(),

          // ChartRoute(),
          // PetsRoute(),
          // BagRoute(),
          // TargetRoute(),
        ],
        bottomNavigationBuilder: (context, tabsRouter) {
          return MainBar(tabsRouter: tabsRouter);
        },
      ),
    );
  }
}
