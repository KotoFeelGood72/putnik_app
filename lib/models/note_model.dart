import 'package:cloud_firestore/cloud_firestore.dart';

enum NotePriority { low, medium, high }

class NoteModel {
  final String? id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;
  final NotePriority priority;
  final String userId;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.dueDate,
    required this.isCompleted,
    required this.priority,
    required this.userId,
  });

  // Создание из Firestore документа
  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dueDate:
          data['dueDate'] != null
              ? (data['dueDate'] as Timestamp).toDate()
              : null,
      isCompleted: data['isCompleted'] ?? false,
      priority: NotePriority.values.firstWhere(
        (e) => e.toString() == 'NotePriority.${data['priority']}',
        orElse: () => NotePriority.medium,
      ),
      userId: data['userId'] ?? '',
    );
  }

  // Конвертация в Map для Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'isCompleted': isCompleted,
      'priority': priority.toString().split('.').last,
      'userId': userId,
    };
  }

  // Копирование с изменениями
  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
    NotePriority? priority,
    String? userId,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      userId: userId ?? this.userId,
    );
  }

  // Получение цвета приоритета
  static int getPriorityColor(NotePriority priority) {
    switch (priority) {
      case NotePriority.low:
        return 0xFF4CAF50; // Зеленый
      case NotePriority.medium:
        return 0xFFFF9800; // Оранжевый
      case NotePriority.high:
        return 0xFFF44336; // Красный
    }
  }

  // Получение названия приоритета
  static String getPriorityName(NotePriority priority) {
    switch (priority) {
      case NotePriority.low:
        return 'Низкая';
      case NotePriority.medium:
        return 'Средняя';
      case NotePriority.high:
        return 'Высокая';
    }
  }
}
