import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/button/btn.dart';

/// Утилиты для работы с модальными окнами
///
/// Этот класс предоставляет переиспользуемые функции для создания
/// модальных окон с единым дизайном и функциональностью.
///
/// Примеры использования:
///
/// 1. Простое модальное окно с кастомным контентом:
/// ```dart
/// ModalUtils.showCustomModal(
///   context: context,
///   title: 'Заголовок',
///   content: Text('Ваш контент'),
///   onSave: () => print('Сохранено'),
/// );
/// ```
///
/// 2. Модальное окно для редактирования навыка:
/// ```dart
/// ModalUtils.showSkillEditModal(
///   context: context,
///   skillName: 'Акробатика',
///   skillInfoContent: yourSkillInfoWidget,
///   editingFields: yourEditingFieldsWidget,
///   onSave: () => saveSkill(),
/// );
/// ```
///
/// 3. Модальное окно для редактирования характеристик:
/// ```dart
/// ModalUtils.showAbilityEditModal(
///   context: context,
///   abilityName: 'СИЛ',
///   abilityContent: yourAbilityContentWidget,
///   onSave: () => saveAbility(),
/// );
/// ```
///
/// 4. Модальное окно для редактирования испытаний:
/// ```dart
/// ModalUtils.showSaveEditModal(
///   context: context,
///   saveName: 'СТОЙ',
///   saveContent: yourSaveContentWidget,
///   onSave: () => saveSave(),
/// );
/// ```
///
/// 5. Модальное окно для редактирования скоростей:
/// ```dart
/// ModalUtils.showSpeedEditModal(
///   context: context,
///   speedContent: yourSpeedContentWidget,
///   onSave: () => saveSpeeds(),
/// );
/// ```
class ModalUtils {
  /// Показывает переиспользуемое модальное окно с кастомным контентом
  static Future<T?> showCustomModal<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    required VoidCallback? onSave,
    VoidCallback? onCancel,
    String? saveButtonText = 'СОХРАНИТЬ',
    String cancelButtonText = 'ОТМЕНА',
    bool isLoading = false,
    double maxHeightRatio = 0.8,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * maxHeightRatio,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Кастомный контент
                        content,

                        const SizedBox(height: 20),

                        // Кнопки
                        Row(
                          children: [
                            Expanded(
                              child: Btn(
                                text: cancelButtonText,
                                onPressed:
                                    isLoading
                                        ? null
                                        : (onCancel ??
                                            () => Navigator.pop(context)),
                                buttonSize: 50,
                                textSize: 16,
                                disabled: isLoading,
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (saveButtonText != '')
                              Expanded(
                                child: Btn(
                                  text: saveButtonText!,
                                  onPressed:
                                      isLoading && onSave != null
                                          ? null
                                          : () {
                                            onSave!();
                                            Navigator.pop(context);
                                          },
                                  buttonSize: 50,
                                  textSize: 16,
                                  loading: isLoading,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ), // Дополнительный отступ снизу
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  /// Показывает модальное окно для редактирования навыка
  static Future<void> showSkillEditModal({
    required BuildContext context,
    required String skillName,
    required Widget skillInfoContent,
    required Widget editingFields,
    required VoidCallback onSave,
    bool isLoading = false,
  }) {
    return showCustomModal(
      context: context,
      title: 'Редактировать: $skillName',
      content: Column(
        children: [
          // Информация о навыке
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Информация о навыке',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                skillInfoContent,
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Поля для редактирования
          editingFields,
        ],
      ),
      onSave: onSave,
      isLoading: isLoading,
    );
  }

  /// Показывает модальное окно для редактирования характеристик
  static Future<void> showAbilityEditModal({
    required BuildContext context,
    required String abilityName,
    required Widget abilityContent,
    required VoidCallback onSave,
    bool isLoading = false,
    double maxHeightRatio = 0.5,
  }) {
    return showCustomModal(
      context: context,
      title: 'Редактирование: $abilityName',
      content: abilityContent,
      onSave: onSave,
      isLoading: isLoading,
      maxHeightRatio: maxHeightRatio,
    );
  }

  /// Показывает модальное окно для редактирования испытаний
  static Future<void> showSaveEditModal({
    required BuildContext context,
    required String saveName,
    required Widget saveContent,
    required VoidCallback onSave,
    bool isLoading = false,
    double maxHeightRatio = 0.8,
  }) {
    return showCustomModal(
      context: context,
      title: 'Редактирование: $saveName',
      content: saveContent,
      onSave: onSave,
      isLoading: isLoading,
      maxHeightRatio: maxHeightRatio,
    );
  }

  /// Показывает модальное окно для редактирования скоростей
  static Future<void> showSpeedEditModal({
    required BuildContext context,
    required Widget speedContent,
    required VoidCallback onSave,
    bool isLoading = false,
    double maxHeightRatio = 0.8,
  }) {
    return showCustomModal(
      context: context,
      title: 'Редактировать скорости',
      content: speedContent,
      onSave: onSave,
      isLoading: isLoading,
      maxHeightRatio: maxHeightRatio,
    );
  }

  /// Показывает модальное окно для редактирования защиты
  ///
  /// [context] - контекст для показа модального окна
  /// [defenseName] - название типа защиты (например, "КБ", "КБ касания", "КБ без инициативы")
  /// [defenseContent] - виджет с контентом для редактирования защиты
  /// [onSave] - функция сохранения изменений
  /// [isLoading] - состояние загрузки (по умолчанию false)
  /// [maxHeightRatio] - максимальная высота модального окна (по умолчанию 0.8)
  ///
  /// Пример использования:
  /// ```dart
  /// ModalUtils.showDefenseEditModal(
  ///   context: context,
  ///   defenseName: 'КБ',
  ///   defenseContent: defenseContent,
  ///   onSave: () async {
  ///     // Логика сохранения
  ///   },
  /// );
  /// ```
  static Future<void> showDefenseEditModal({
    required BuildContext context,
    required String defenseName,
    required Widget defenseContent,
    required VoidCallback onSave,
    bool isLoading = false,
    double maxHeightRatio = 0.8,
  }) {
    return showCustomModal(
      context: context,
      title: 'Редактирование: $defenseName',
      content: defenseContent,
      onSave: onSave,
      isLoading: isLoading,
      maxHeightRatio: maxHeightRatio,
    );
  }

  /// Показывает модальное окно для редактирования инициативы
  ///
  /// [context] - контекст для показа модального окна
  /// [initiativeContent] - виджет с контентом для редактирования инициативы
  /// [onSave] - функция сохранения изменений
  /// [isLoading] - состояние загрузки (по умолчанию false)
  /// [maxHeightRatio] - максимальная высота модального окна (по умолчанию 0.6)
  ///
  /// Пример использования:
  /// ```dart
  /// ModalUtils.showInitiativeEditModal(
  ///   context: context,
  ///   initiativeContent: initiativeContent,
  ///   onSave: () async {
  ///     // Логика сохранения
  ///   },
  /// );
  /// ```
  static Future<void> showInitiativeEditModal({
    required BuildContext context,
    required Widget initiativeContent,
    required VoidCallback onSave,
    bool isLoading = false,
    double maxHeightRatio = 0.6,
  }) {
    return showCustomModal(
      context: context,
      title: 'Редактирование: Инициатива',
      content: initiativeContent,
      onSave: onSave,
      isLoading: isLoading,
      maxHeightRatio: maxHeightRatio,
    );
  }

  /// Показывает модальное окно для редактирования базового модификатора атаки (БМА)
  ///
  /// [context] - контекст для показа модального окна
  /// [attackContent] - виджет с контентом для редактирования атаки
  /// [onSave] - функция сохранения изменений
  /// [isLoading] - состояние загрузки (по умолчанию false)
  /// [maxHeightRatio] - максимальная высота модального окна (по умолчанию 0.5)
  ///
  /// Пример использования:
  /// ```dart
  /// ModalUtils.showAttackEditModal(
  ///   context: context,
  ///   attackContent: attackContent,
  ///   onSave: () async {
  ///     // Логика сохранения
  ///   },
  /// );
  /// ```
  static Future<void> showAttackEditModal({
    required BuildContext context,
    required Widget attackContent,
    required VoidCallback onSave,
    bool isLoading = false,
    double maxHeightRatio = 0.5,
  }) {
    return showCustomModal(
      context: context,
      title: 'Редактирование: БМА',
      content: attackContent,
      onSave: onSave,
      isLoading: isLoading,
      maxHeightRatio: maxHeightRatio,
    );
  }
}
