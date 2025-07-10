import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final _fa = FirebaseAuth.instance;

  @override
  Stream<User?> get user => _fa.authStateChanges();

  @override
  User? get currentUser => _fa.currentUser;

  @override
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _fa.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      // можно прокинуть далее своё кастом-исключение
      rethrow;
    }
  }

  @override
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _fa.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 👉 при желании: await cred.user?.sendEmailVerification();
      return cred;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _fa.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() => _fa.signOut();
}
