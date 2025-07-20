import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:putnik_app/models/note_model.dart';

class NotesService {
  static final NotesService _instance = NotesService._internal();
  factory NotesService() => _instance;
  NotesService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isFirebaseAvailable = true;

  // Проверка доступности Firebase
  Future<bool> _checkFirebaseAvailability() async {
    try {
      await _firestore.collection('test').limit(1).get();
      _isFirebaseAvailable = true;
      return true;
    } catch (e) {
      print('Firebase not available: $e');
      _isFirebaseAvailable = false;
      return false;
    }
  }

  // Получение всех заметок пользователя
  Stream<List<NoteModel>> getUserNotes() {
    if (!_isFirebaseAvailable) {
      return Stream.value([]);
    }

    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList(),
        )
        .handleError((error) {
          print('Error getting user notes: $error');
          return <NoteModel>[];
        });
  }

  // Создание новой заметки
  Future<void> createNote({
    required String title,
    required String content,
    String? imageUrl,
    DateTime? dueDate,
    NotePriority priority = NotePriority.medium,
  }) async {
    try {
      if (!await _checkFirebaseAvailability()) {
        throw Exception(
          'Firebase недоступен. Заметка не может быть сохранена.',
        );
      }

      final user = _auth.currentUser;
      if (user == null) throw Exception('Пользователь не авторизован');

      final note = NoteModel(
        title: title,
        content: content,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        dueDate: dueDate,
        isCompleted: false,
        priority: priority,
        userId: user.uid,
      );

      await _firestore.collection('notes').add(note.toFirestore());
    } catch (e) {
      print('Error creating note: $e');
      rethrow;
    }
  }

  // Обновление заметки
  Future<void> updateNote(NoteModel note) async {
    try {
      if (!await _checkFirebaseAvailability()) {
        throw Exception(
          'Firebase недоступен. Заметка не может быть обновлена.',
        );
      }

      if (note.id == null) throw Exception('ID заметки не найден');

      await _firestore
          .collection('notes')
          .doc(note.id)
          .update(note.toFirestore());
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  // Удаление заметки
  Future<void> deleteNote(String noteId) async {
    try {
      if (!await _checkFirebaseAvailability()) {
        throw Exception('Firebase недоступен. Заметка не может быть удалена.');
      }

      await _firestore.collection('notes').doc(noteId).delete();
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }

  // Изменение статуса выполнения
  Future<void> toggleNoteCompletion(String noteId, bool isCompleted) async {
    try {
      if (!await _checkFirebaseAvailability()) {
        throw Exception('Firebase недоступен. Статус не может быть изменен.');
      }

      await _firestore.collection('notes').doc(noteId).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      print('Error toggling note completion: $e');
      rethrow;
    }
  }

  // Получение заметки по ID
  Future<NoteModel?> getNoteById(String noteId) async {
    try {
      if (!await _checkFirebaseAvailability()) {
        return null;
      }

      final doc = await _firestore.collection('notes').doc(noteId).get();
      if (doc.exists) {
        return NoteModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting note by ID: $e');
      return null;
    }
  }

  // Поиск заметок по тексту
  Stream<List<NoteModel>> searchNotes(String query) {
    if (!_isFirebaseAvailable) {
      return Stream.value([]);
    }

    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => NoteModel.fromFirestore(doc))
                  .where(
                    (note) =>
                        note.title.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        note.content.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                  )
                  .toList(),
        )
        .handleError((error) {
          print('Error searching notes: $error');
          return <NoteModel>[];
        });
  }

  // Фильтрация заметок по статусу
  Stream<List<NoteModel>> getNotesByStatus(bool isCompleted) {
    if (!_isFirebaseAvailable) {
      return Stream.value([]);
    }

    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .where('isCompleted', isEqualTo: isCompleted)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList(),
        )
        .handleError((error) {
          print('Error getting notes by status: $error');
          return <NoteModel>[];
        });
  }

  // Фильтрация заметок по приоритету
  Stream<List<NoteModel>> getNotesByPriority(NotePriority priority) {
    if (!_isFirebaseAvailable) {
      return Stream.value([]);
    }

    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .where('priority', isEqualTo: priority.toString().split('.').last)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList(),
        )
        .handleError((error) {
          print('Error getting notes by priority: $error');
          return <NoteModel>[];
        });
  }

  // Получение статистики заметок
  Future<Map<String, int>> getNotesStatistics() async {
    try {
      if (!await _checkFirebaseAvailability()) {
        return {'total': 0, 'completed': 0, 'pending': 0, 'highPriority': 0};
      }

      final user = _auth.currentUser;
      if (user == null) return {};

      final snapshot =
          await _firestore
              .collection('notes')
              .where('userId', isEqualTo: user.uid)
              .get();

      final notes =
          snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList();

      return {
        'total': notes.length,
        'completed': notes.where((note) => note.isCompleted).length,
        'pending': notes.where((note) => !note.isCompleted).length,
        'highPriority':
            notes.where((note) => note.priority == NotePriority.high).length,
      };
    } catch (e) {
      print('Error getting notes statistics: $e');
      return {'total': 0, 'completed': 0, 'pending': 0, 'highPriority': 0};
    }
  }

  // Проверка доступности Firebase
  bool get isFirebaseAvailable => _isFirebaseAvailable;
}
