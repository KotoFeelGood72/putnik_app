import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:putnik_app/present/components/app/new_appbar.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/services/notes/notes_service.dart';
import 'package:putnik_app/models/note_model.dart';

import 'package:intl/intl.dart';

@RoutePage()
class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final NotesService _notesService = NotesService();
  final TextEditingController _searchController = TextEditingController();
  NotePriority? _selectedPriority;
  bool? _selectedStatus;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onPriorityFilterChanged(NotePriority? priority) {
    setState(() {
      _selectedPriority = priority;
    });
  }

  void _onStatusFilterChanged(bool? status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedPriority = null;
      _selectedStatus = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NewAppBar(
        title: 'Заметки',
        onBack: () => Navigator.of(context).maybePop(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white),
            onPressed: () {
              context.router.push(const CreateNoteRoute());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(child: _buildNotesList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Поиск
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                hintText: 'Поиск заметок...',
                hintStyle: TextStyle(color: AppColors.white),
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Фильтры
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  label: 'Все',
                  isSelected: _selectedStatus == null,
                  onTap: () => _onStatusFilterChanged(null),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  label: 'Выполнено',
                  isSelected: _selectedStatus == true,
                  onTap: () => _onStatusFilterChanged(true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  label: 'В работе',
                  isSelected: _selectedStatus == false,
                  onTap: () => _onStatusFilterChanged(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Фильтр по приоритету
          Row(
            children: [
              Expanded(
                child: _buildPriorityFilterChip(
                  label: 'Все',
                  isSelected: _selectedPriority == null,
                  onTap: () => _onPriorityFilterChanged(null),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPriorityFilterChip(
                  label: 'Высокий',
                  isSelected: _selectedPriority == NotePriority.high,
                  onTap: () => _onPriorityFilterChanged(NotePriority.high),
                  color: Color(NoteModel.getPriorityColor(NotePriority.high)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPriorityFilterChip(
                  label: 'Средний',
                  isSelected: _selectedPriority == NotePriority.medium,
                  onTap: () => _onPriorityFilterChanged(NotePriority.medium),
                  color: Color(NoteModel.getPriorityColor(NotePriority.medium)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPriorityFilterChip(
                  label: 'Низкий',
                  isSelected: _selectedPriority == NotePriority.low,
                  onTap: () => _onPriorityFilterChanged(NotePriority.low),
                  color: Color(NoteModel.getPriorityColor(NotePriority.low)),
                ),
              ),
            ],
          ),
          if (_selectedPriority != null ||
              _selectedStatus != null ||
              _searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: _clearFilters,
                child: const Text(
                  'Очистить фильтры',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.3),
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

  Widget _buildPriorityFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? (color ?? AppColors.primary) : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? (color ?? AppColors.primary)
                    : AppColors.primary.withOpacity(0.3),
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

  Widget _buildNotesList() {
    return StreamBuilder<List<NoteModel>>(
      stream: _notesService.getUserNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ошибка загрузки заметок: ${snapshot.error}',
              style: const TextStyle(color: AppColors.white),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        List<NoteModel> notes = snapshot.data ?? [];

        // Применяем фильтры
        if (_selectedStatus != null) {
          notes =
              notes
                  .where((note) => note.isCompleted == _selectedStatus)
                  .toList();
        }

        if (_selectedPriority != null) {
          notes =
              notes
                  .where((note) => note.priority == _selectedPriority)
                  .toList();
        }

        if (_searchQuery.isNotEmpty) {
          notes =
              notes
                  .where(
                    (note) =>
                        note.title.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        note.content.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                  )
                  .toList();
        }

        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note_add,
                  size: 64,
                  color: AppColors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Нет заметок',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Создайте свою первую заметку',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return _buildNoteCard(note);
          },
        );
      },
    );
  }

  Widget _buildNoteCard(NoteModel note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.router.push(EditNoteRoute(noteId: note.id!));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration:
                              note.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(NoteModel.getPriorityColor(note.priority)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        NoteModel.getPriorityName(note.priority),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.8),
                      fontSize: 14,
                      decoration:
                          note.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (note.imageUrl != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      note.imageUrl!,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd.MM.yyyy').format(note.createdAt),
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    if (note.dueDate != null) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppColors.white.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Срок: ${DateFormat('dd.MM.yyyy').format(note.dueDate!)}',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        _notesService.toggleNoteCompletion(
                          note.id!,
                          !note.isCompleted,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              note.isCompleted
                                  ? AppColors.success
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color:
                                note.isCompleted
                                    ? AppColors.success
                                    : AppColors.primary,
                          ),
                        ),
                        child: Icon(
                          note.isCompleted
                              ? Icons.check
                              : Icons.check_box_outline_blank,
                          size: 16,
                          color:
                              note.isCompleted
                                  ? AppColors.white
                                  : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
