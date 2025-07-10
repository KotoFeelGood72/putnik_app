import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:putnik_app/services/auth/auth_service.dart';
import 'package:putnik_app/services/auth/firebase_auth_service.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => FirebaseAuthService(),
);
