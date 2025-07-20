import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Отправка сообщения в чат
  Future<void> sendMessage({
    required String chatId,
    required String message,
    String? imageUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Пользователь не авторизован');

      final messageData = {
        'senderId': user.uid,
        'senderName': user.displayName ?? 'Неизвестный',
        'message': message,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'chatId': chatId,
      };

      // Сохраняем сообщение в Firestore
      await _firestore.collection('messages').add(messageData);

      // Обновляем последнее сообщение в чате
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastSenderId': user.uid,
        'lastSenderName': user.displayName ?? 'Неизвестный',
      });
    } catch (e) {
      print('Ошибка при отправке сообщения: $e');
      rethrow;
    }
  }

  // Получение сообщений чата в реальном времени
  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Получение списка чатов пользователя
  Stream<QuerySnapshot> getUserChats() {
    final user = _auth.currentUser;
    if (user == null) return Stream.empty();

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: user.uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Создание нового чата
  Future<String> createChat({
    required List<String> participantIds,
    required String chatName,
  }) async {
    try {
      final chatData = {
        'name': chatName,
        'participants': participantIds,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection('chats').add(chatData);
      return docRef.id;
    } catch (e) {
      print('Ошибка при создании чата: $e');
      rethrow;
    }
  }
}
