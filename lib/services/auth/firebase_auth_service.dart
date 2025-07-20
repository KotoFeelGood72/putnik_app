import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      // 👉 Проверяем и создаём документ пользователя в Firestore, если его нет
      final user = cred.user;
      if (user != null) {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final doc = await docRef.get();
        if (!doc.exists) {
          await docRef.set({
            'uid': user.uid,
            'email': user.email,
            'name': user.displayName,
            'avatar': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return cred;
    } on FirebaseAuthException {
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
      // 👉 Создаём документ пользователя в Firestore
      final user = cred.user;
      if (user != null) {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final doc = await docRef.get();
        if (!doc.exists) {
          await docRef.set({
            'uid': user.uid,
            'email': user.email,
            'name': null,
            'avatar': null,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      // 👉 при желании: await cred.user?.sendEmailVerification();
      return cred;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _fa.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> logout() => _fa.signOut();

  @override
  Future<void> deleteAccount() async {
    final user = _fa.currentUser;
    if (user != null) {
      await user.delete();
    }
  }
}
