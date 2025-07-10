// auth_guard.dart

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:putnik_app/present/routes/app_router.gr.dart';


/// Только для авторизованных
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (isLoggedIn) {
      resolver.next(true);
    } else {
      router.replace(AuthRoute());
    }
  }
}

/// Только для гостей (неавторизованных)
class GuestGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (!isLoggedIn) {
      resolver.next(true);
    } else {
      router.replace(const DashboardRoute());
    }
  }
}
