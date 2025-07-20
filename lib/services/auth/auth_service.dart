import 'package:firebase_auth/firebase_auth.dart';

/// Общий интерфейс авторизации
abstract class AuthService {
  /// Стрим текущего пользователя (пушит null при логауте)
  Stream<User?> get user;

  /// Синхронно – кто залогинен прямо сейчас
  User? get currentUser;

  /// Email/пароль: вход
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  });

  /// Email/пароль: регистрация
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  });

  /// Сброс пароля (отправка письма)
  Future<void> resetPassword(String email);

  /// Выход
  Future<void> logout();

  /// Удаление аккаунта
  Future<void> deleteAccount();
}
