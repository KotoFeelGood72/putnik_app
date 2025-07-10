import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:putnik_app/firebase_options.dart';
import 'package:putnik_app/guards/auth_guard.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/present/theme/text_themes.dart';

final getIt = GetIt.instance;
final String locale = Intl.getCurrentLocale();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('ru_RU');
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
      theme: ThemeData(
        fontFamily: 'EuclidCircularA',
        textTheme: buildTextTheme(),
        scaffoldBackgroundColor: AppColors.white,
      ),
      debugShowCheckedModeBanner: false,

      routerConfig: appRouter.config(navigatorObservers: () => []),
    );
  }
}
