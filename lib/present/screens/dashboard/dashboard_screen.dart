import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/app/main_bar.dart';
import 'package:putnik_app/present/routes/app_router.dart';

import 'package:putnik_app/present/theme/app_colors.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = [HeroListRoute(), MainRoute(), ProfileRoute()];
    return Container(
      color: AppColors.bg,
      child: AutoTabsScaffold(
        routes: routes,
        bottomNavigationBuilder: (context, tabsRouter) {
          return MainBar(tabsRouter: tabsRouter, routes: routes);
        },
      ),
    );
  }
}
