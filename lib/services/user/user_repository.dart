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

  /// Получить список друзей пользователя (uid)
  Future<List<UserModel>> getFriends(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return [];
    final data = doc.data()!;
    final friendsIds =
        data['friends'] != null
            ? List<String>.from(data['friends'])
            : <String>[];
    if (friendsIds.isEmpty) return [];
    final friendsSnapshots = await Future.wait(
      friendsIds.map((fid) => _collection.doc(fid).get()),
    );
    return friendsSnapshots
        .where((doc) => doc.exists)
        .map((doc) => UserModel.fromMap(doc.id, doc.data()!))
        .toList();
  }

  /// Получить только онлайн-друзей пользователя
  Future<List<UserModel>> getOnlineFriends(String uid) async {
    final friends = await getFriends(uid);
    return friends.where((f) => f.isOnline).toList();
  }

  /// Стрим онлайн-друзей пользователя
  Stream<List<UserModel>> watchOnlineFriends(String uid) async* {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) yield [];
    final data = doc.data()!;
    final friendsIds =
        data['friends'] != null
            ? List<String>.from(data['friends'])
            : <String>[];
    if (friendsIds.isEmpty) yield [];
    yield* _collection
        .where(FieldPath.documentId, whereIn: friendsIds)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => UserModel.fromMap(doc.id, doc.data()!))
                  .where((u) => u.isOnline)
                  .toList(),
        );
  }
}
