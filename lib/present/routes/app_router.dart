import 'package:auto_route/auto_route.dart';

import 'package:putnik_app/guards/auth_guard.dart';
import 'package:putnik_app/present/routes/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;
  final GuestGuard guestGuard;

  AppRouter({required this.authGuard, required this.guestGuard});

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
      guards: [authGuard],
      children: [
        AutoRoute(page: HeroListRoute.page, path: 'hero'),
        // AutoRoute(page: PetsRoute.page, path: 'pets', initial: true),
        // AutoRoute(page: BagRoute.page, path: 'bag'),
        // AutoRoute(page: ChartRoute.page, path: 'chart'),
        // AutoRoute(page: TargetRoute.page, path: 'target'),
      ],
    ),
    AutoRoute(
      page: WelcomeRoute.page,
      path: '/',
      initial: true,
      guards: [guestGuard],
    ),
    AutoRoute(page: AuthRoute.page, path: '/auth', guards: [guestGuard]),
    AutoRoute(
      page: CreateHeroRoute.page,
      path: '/create-hero',
      guards: [guestGuard],
    ),
    AutoRoute(
      page: RegisterRoute.page,
      path: '/registration',
      guards: [guestGuard],
    ),
    // AutoRoute(page: ProfileRoute.page, path: '/profile', guards: [authGuard]),
    // AutoRoute(
    //   page: LevelprogressRoute.page,
    //   path: '/levels',
    //   guards: [authGuard],
    // ),
    // AutoRoute(page: SettingsRoute.page, path: '/settings', guards: [authGuard]),
  ];
}
