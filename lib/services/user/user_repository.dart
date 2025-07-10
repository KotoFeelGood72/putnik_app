import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:putnik_app/models/user_model.dart';

class UserRepository {
  final _collection = FirebaseFirestore.instance.collection('users');

  /// Получить пользователя один раз
  Future<UserModel?> getUser(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.id, doc.data()!);
  }

  /// Подписка на пользователя (реальное время)
  Stream<UserModel?> watchUser(String uid) {
    return _collection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.id, doc.data()!);
    });
  }

  /// Сохранить или обновить пользователя
  Future<void> saveUser(UserModel user) async {
    await _collection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  /// Проверка существования
  Future<bool> userExists(String uid) async {
    final doc = await _collection.doc(uid).get();
    return doc.exists;
  }
}
