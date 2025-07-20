import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/components/button/custom_btn.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/services/notes/notes_service.dart';
import 'package:putnik_app/models/note_model.dart';
import 'package:putnik_app/services/app/app_service.dart';
import 'package:intl/intl.dart';

@RoutePage()
class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final NotesService _notesService = NotesService();
  final AppService _appService = AppService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedImagePath;
  DateTime? _selectedDueDate;
  NotePriority _selectedPriority = NotePriority.medium;
  bool _isLoading = false;
  bool _isCameraAvailable = true;
  bool _isGalleryAvailable = true;
  bool _isFirebaseAvailable = true;

  @override
  void initState() {
    super.initState();
    _checkFeaturesAvailability();
  }

  Future<void> _checkFeaturesAvailability() async {
    try {
      final features = await _appService.checkAllFeatures();
      setState(() {
        _isCameraAvailable = features['camera'] ?? false;
        _isGalleryAvailable = features['gallery'] ?? false;
        _isFirebaseAvailable = features['firebase'] ?? false;
      });
    } catch (e) {
      print('Error checking features availability: $e');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera && !_isCameraAvailable) {
      _showFeatureUnavailableDialog('Камера недоступна');
      return;
    }

    if (source == ImageSource.gallery && !_isGalleryAvailable) {
      _showFeatureUnavailableDialog('Галерея недоступна');
      return;
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при выборе изображения: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showFeatureUnavailableDialog(String feature) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text(
              'Функция недоступна',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              '$feature. Возможно, требуется настройка аккаунта разработчика или разрешений.',
              style: TextStyle(color: AppColors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Понятно',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Выберите источник изображения',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildImageSourceButton(
                        icon: Icons.camera_alt,
                        title: 'Камера',
                        isAvailable: _isCameraAvailable,
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImageSourceButton(
                        icon: Icons.photo_library,
                        title: 'Галерея',
                        isAvailable: _isGalleryAvailable,
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String title,
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isAvailable ? onTap : () => _showFeatureUnavailableDialog(title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isAvailable
                    ? [AppColors.primary, AppColors.accentLight]
                    : [Colors.grey, Colors.grey.shade600],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!isAvailable) ...[
              const SizedBox(height: 4),
              Text(
                'Недоступно',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
              onPrimary: AppColors.white,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите заголовок заметки'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Проверяем доступность Firebase
      if (!_isFirebaseAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Firebase недоступен. Заметка будет сохранена локально.',
            ),
            backgroundColor: AppColors.warning,
          ),
        );
      }

      // TODO: Загрузить изображение в Firebase Storage и получить URL
      String? imageUrl;
      if (_selectedImagePath != null) {
        // Временно используем локальный путь
        imageUrl = _selectedImagePath;
      }

      await _notesService.createNote(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imageUrl: imageUrl,
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заметка создана'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при создании заметки: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NewAppBar(
        title: 'Новая заметка',
        onBack: () => Navigator.of(context).maybePop(),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveNote,
              child: const Text(
                'Сохранить',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Предупреждение о недоступных функциях
            if (!_isFirebaseAvailable ||
                !_isCameraAvailable ||
                !_isGalleryAvailable)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: AppColors.warning, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Некоторые функции недоступны',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Возможно, требуется настройка аккаунта разработчика или разрешений.',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

            // Заголовок
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(color: AppColors.white, fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Заголовок заметки',
                  hintStyle: TextStyle(color: AppColors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Содержание
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _contentController,
                style: const TextStyle(color: AppColors.white),
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Содержание заметки...',
                  hintStyle: TextStyle(color: AppColors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Приоритет
            Text(
              'Приоритет',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildPriorityButton(
                    label: 'Низкий',
                    priority: NotePriority.low,
                    color: Color(NoteModel.getPriorityColor(NotePriority.low)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriorityButton(
                    label: 'Средний',
                    priority: NotePriority.medium,
                    color: Color(
                      NoteModel.getPriorityColor(NotePriority.medium),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriorityButton(
                    label: 'Высокий',
                    priority: NotePriority.high,
                    color: Color(NoteModel.getPriorityColor(NotePriority.high)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Дата выполнения
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _selectDueDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDueDate != null
                                ? DateFormat(
                                  'dd.MM.yyyy',
                                ).format(_selectedDueDate!)
                                : 'Установить срок',
                            style: TextStyle(
                              color:
                                  _selectedDueDate != null
                                      ? AppColors.white
                                      : AppColors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_selectedDueDate != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDueDate = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Изображение
            Text(
              'Изображение',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedImagePath != null) ...[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_selectedImagePath!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImagePath = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Добавить изображение',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton({
    required String label,
    required NotePriority priority,
    required Color color,
  }) {
    final isSelected = _selectedPriority == priority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
