import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/services/notes/notes_service.dart';
import 'package:putnik_app/models/note_model.dart';
import 'package:intl/intl.dart';

@RoutePage()
class EditNoteScreen extends StatefulWidget {
  final String noteId;

  const EditNoteScreen({super.key, required this.noteId});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final NotesService _notesService = NotesService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  NoteModel? _note;
  String? _selectedImagePath;
  DateTime? _selectedDueDate;
  NotePriority _selectedPriority = NotePriority.medium;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadNote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final note = await _notesService.getNoteById(widget.noteId);
      if (note != null) {
        setState(() {
          _note = note;
          _titleController.text = note.title;
          _contentController.text = note.content;
          _selectedDueDate = note.dueDate;
          _selectedPriority = note.priority;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки заметки: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.accentLight],
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
    if (_note == null) return;
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
      _isSaving = true;
    });

    try {
      // TODO: Загрузить изображение в Firebase Storage и получить URL
      String? imageUrl = _note!.imageUrl;
      if (_selectedImagePath != null) {
        // Временно используем локальный путь
        imageUrl = _selectedImagePath;
      }

      final updatedNote = _note!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imageUrl: imageUrl,
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
      );

      await _notesService.updateNote(updatedNote);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заметка обновлена'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при обновлении заметки: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _deleteNote() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text(
              'Удалить заметку?',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Вы уверены, что хотите удалить эту заметку? Это действие необратимо.',
              style: TextStyle(color: AppColors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Отмена',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Удалить',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _notesService.deleteNote(widget.noteId);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Заметка удалена'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при удалении заметки: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: NewAppBar(
          title: 'Редактирование',
          onBack: () => Navigator.of(context).maybePop(),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_note == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: NewAppBar(
          title: 'Редактирование',
          onBack: () => Navigator.of(context).maybePop(),
        ),
        body: const Center(
          child: Text(
            'Заметка не найдена',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NewAppBar(
        title: 'Редактирование',
        onBack: () => Navigator.of(context).maybePop(),
        actions: [
          if (_isSaving)
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
          else ...[
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: _deleteNote,
            ),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            if (_selectedImagePath != null || _note!.imageUrl != null) ...[
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
                      child:
                          _selectedImagePath != null
                              ? Image.file(
                                File(_selectedImagePath!),
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                              : Image.network(
                                _note!.imageUrl!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: AppColors.white,
                                    ),
                                  );
                                },
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
