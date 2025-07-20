import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:putnik_app/firebase_options.dart';
import 'package:putnik_app/guards/auth_guard.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/present/theme/app_themes.dart';

final getIt = GetIt.instance;
final String locale = Intl.getCurrentLocale();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Инициализация Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Продолжаем работу без Firebase
  }

  try {
    await initializeDateFormatting('ru_RU');
    print('Date formatting initialized successfully');
  } catch (e) {
    print('Date formatting initialization failed: $e');
    // Продолжаем работу без локализации дат
  }

  final authGuard = AuthGuard();
  final guestGuard = GuestGuard();

  getIt.registerSingleton<AppRouter>(
    AppRouter(authGuard: authGuard, guestGuard: guestGuard),
  );

  runApp(ProviderScope(child: TeenseApp()));
}

class TeenseApp extends StatelessWidget {
  const TeenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    return MaterialApp.router(
      theme: FantasyTheme.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(navigatorObservers: () => []),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
