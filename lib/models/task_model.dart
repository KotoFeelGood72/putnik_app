enum TaskFrequency {
  once, // Выполняется один раз
  daily, // Повторяется каждый день
  weekly, // Повторяется каждую неделю
  monthly, // Повторяется каждый месяц
}

enum TaskValidation {
  manual, // Проверка вручную (например, родителем)
  photo, // Проверка по загруженному фото
  steps, // Проверка по количеству шагов
  screenTime, // Проверка по времени за экраном
  location, // Проверка по геолокации
}

enum TaskType {
  focus, // Концентрация / внимательные задачи
  learning, // Образовательные / познавательные
  active, // Активные / физические
  habit, // Привычки
  creative, // Творческие / креативные
}

class TaskModel {
  /// Уникальный ID задачи
  final String taskId;

  /// ID ребёнка/пользователя (null → общая задача)
  final String? childId;

  /// Частота задачи: разовая, ежедневная и т.д.
  final TaskFrequency freq;

  /// Текстовое описание
  final String description;

  /// Тип задачи (активность, привычка и т.п.)
  final TaskType taskType;

  /// Как проверяется выполнение
  final TaskValidation validation;

  /// Сколько минут занимает
  final int estimationMin;

  /// Награда: опыт
  final int xpBonus;

  /// Награда: настроение
  final int moodBonus;

  /// Награда: медали
  final int medalBonus;

  /// Ссылка на инструкцию
  final String? howToLink;

  /// Выполнена ли задача (по умолчанию — нет)
  final bool isCompleted;

  /// Дата создания задачи
  final DateTime createdAt;

  /// Крайний срок (если есть)
  final DateTime? dueDate;

  /// Повторять задачу до этой даты (для daily/weekly)
  final DateTime? repeatUntil;

  TaskModel({
    required this.taskId,
    this.childId,
    required this.freq,
    required this.description,
    required this.taskType,
    required this.validation,
    required this.estimationMin,
    this.xpBonus = 0,
    this.moodBonus = 0,
    this.medalBonus = 0,
    this.howToLink,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.repeatUntil,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'],
      childId: json['childId'],
      freq: TaskFrequency.values.firstWhere((e) => e.name == json['freq']),
      description: json['description'],
      taskType: TaskType.values.firstWhere((e) => e.name == json['taskType']),
      validation: TaskValidation.values.firstWhere(
        (e) => e.name == json['validation'],
      ),
      estimationMin: json['estimationMin'],
      xpBonus: json['xpBonus'] ?? 0,
      moodBonus: json['moodBonus'] ?? 0,
      medalBonus: json['medalBonus'] ?? 0,
      howToLink: json['howToLink'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      repeatUntil:
          json['repeatUntil'] != null
              ? DateTime.parse(json['repeatUntil'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'childId': childId,
      'freq': freq.name,
      'description': description,
      'taskType': taskType.name,
      'validation': validation.name,
      'estimationMin': estimationMin,
      'xpBonus': xpBonus,
      'moodBonus': moodBonus,
      'medalBonus': medalBonus,
      'howToLink': howToLink,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'repeatUntil': repeatUntil?.toIso8601String(),
    };
  }
}
