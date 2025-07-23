import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:putnik_app/guards/auth_guard.dart';
import 'package:putnik_app/models/hero_model.dart';
import 'package:putnik_app/present/screens/auth/auth_screen.dart';
import 'package:putnik_app/present/screens/auth/register_screen.dart';
import 'package:putnik_app/present/screens/auth/reset_password_screen.dart';
import 'package:putnik_app/present/screens/chat/chat_list_screen.dart';
import 'package:putnik_app/present/screens/chat/chat_screen.dart';
import 'package:putnik_app/present/screens/dashboard/dashboard_screen.dart';
import 'package:putnik_app/present/screens/debug/features_status_screen.dart';
import 'package:putnik_app/present/screens/hero/create_hero_screen.dart';
import 'package:putnik_app/present/screens/hero/hero_detail_screen.dart';
import 'package:putnik_app/present/screens/hero/hero_list_screen.dart';
import 'package:putnik_app/present/screens/main/main_screen.dart';
import 'package:putnik_app/present/screens/map/galarion_map_screen.dart';
import 'package:putnik_app/present/screens/notes/create_note_screen.dart';
import 'package:putnik_app/present/screens/notes/edit_note_screen.dart';
import 'package:putnik_app/present/screens/notes/notes_list_screen.dart';
import 'package:putnik_app/present/screens/profile/profile_edit_screen.dart';
import 'package:putnik_app/present/screens/profile/profile_screen.dart';
import 'package:putnik_app/present/screens/static/welcome_screen.dart';
import 'package:putnik_app/present/screens/static/start_screen.dart';
import 'package:putnik_app/present/screens/glossary/glossary_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;
  final GuestGuard guestGuard;

  AppRouter({required this.authGuard, required this.guestGuard});

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: StartRoute.page, path: '/', initial: true),
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
      guards: [authGuard],
      children: [
        AutoRoute(page: HeroListRoute.page, path: 'hero'),
        AutoRoute(page: GalarionMapRoute.page, path: 'map'),
        AutoRoute(page: MainRoute.page, path: 'main'),
        AutoRoute(page: ChatListRoute.page, path: 'chat'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),
    AutoRoute(page: WelcomeRoute.page, path: '/welcome', guards: [guestGuard]),
    AutoRoute(page: AuthRoute.page, path: '/auth', guards: [guestGuard]),
    AutoRoute(
      page: CreateHeroRoute.page,
      path: '/create-hero',
      guards: [authGuard],
    ),
    AutoRoute(
      page: RegisterRoute.page,
      path: '/registration',
      guards: [guestGuard],
    ),
    AutoRoute(
      page: ResetPasswordRoute.page,
      path: '/reset-password',
      guards: [guestGuard],
    ),
    AutoRoute(
      page: HeroDetailRoute.page,
      path: '/hero/:id',
      guards: [authGuard],
    ),
    AutoRoute(path: '/chat/:chatId', page: ChatRoute.page, guards: [authGuard]),
    AutoRoute(
      page: ProfileEditRoute.page,
      path: '/profile/edit',
      guards: [authGuard],
    ),
    AutoRoute(page: NotesListRoute.page, path: '/notes', guards: [authGuard]),
    AutoRoute(
      page: CreateNoteRoute.page,
      path: '/notes/create',
      guards: [authGuard],
    ),
    AutoRoute(
      page: EditNoteRoute.page,
      path: '/notes/:id/edit',
      guards: [authGuard],
    ),
    AutoRoute(page: GlossaryRoute.page, path: '/glossary', guards: [authGuard]),
    AutoRoute(page: FeaturesStatusRoute.page, path: '/debug/features'),
  ];
}
