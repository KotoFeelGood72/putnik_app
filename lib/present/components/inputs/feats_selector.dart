import 'package:flutter/material.dart';
import '../../../models/feat_model.dart';
import '../../../services/feats_service.dart';
import '../button/btn.dart';
import 'custom_bottom_sheet_select.dart';

class FeatsSelector extends StatefulWidget {
  final List<FeatModel> selectedFeats;
  final Function(List<FeatModel>) onFeatsChanged;
  final List<FeatModel> allFeats;

  const FeatsSelector({
    Key? key,
    required this.selectedFeats,
    required this.onFeatsChanged,
    required this.allFeats,
  }) : super(key: key);

  @override
  State<FeatsSelector> createState() => _FeatsSelectorState();
}

class _FeatsSelectorState extends State<FeatsSelector> {
  Map<String, List<FeatModel>> _groupedFeats = {};
  List<String> _uniqueTypes = [];

  @override
  void initState() {
    super.initState();
    _initializeFeats();
  }

  @override
  void didUpdateWidget(FeatsSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allFeats != widget.allFeats) {
      _initializeFeats();
    }
  }

  void _initializeFeats() {
    _groupedFeats = FeatsService.groupFeatsByType(widget.allFeats);
    _uniqueTypes = FeatsService.getUniqueTypes(widget.allFeats);
  }

  void _showFeatsSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _FeatsSelectionModal(
            groupedFeats: _groupedFeats,
            uniqueTypes: _uniqueTypes,
            selectedFeats: widget.selectedFeats,
            onFeatsChanged: widget.onFeatsChanged,
            allFeats: widget.allFeats,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showFeatsSelector,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Черты',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.selectedFeats.isEmpty)
              Text(
                'Нажмите для выбора черт',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              )
            else
              _buildSelectedFeatsPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFeatsPreview() {
    final groupedSelected = FeatsService.groupFeatsByType(widget.selectedFeats);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          groupedSelected.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ...entry.value.map(
                  (feat) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 2),
                    child: Text(
                      '• ${feat.name}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
    );
  }
}

class _FeatsSelectionModal extends StatefulWidget {
  final Map<String, List<FeatModel>> groupedFeats;
  final List<String> uniqueTypes;
  final List<FeatModel> selectedFeats;
  final Function(List<FeatModel>) onFeatsChanged;
  final List<FeatModel> allFeats;

  const _FeatsSelectionModal({
    required this.groupedFeats,
    required this.uniqueTypes,
    required this.selectedFeats,
    required this.onFeatsChanged,
    required this.allFeats,
  });

  @override
  State<_FeatsSelectionModal> createState() => _FeatsSelectionModalState();
}

class _FeatsSelectionModalState extends State<_FeatsSelectionModal> {
  late List<FeatModel> _tempSelectedFeats;
  String _selectedType = '';
  String _searchQuery = '';
  List<FeatModel> _filteredFeats = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedFeats = List.from(widget.selectedFeats);
    // По умолчанию не выбрано
    _selectedType = '';
    _updateFilteredFeats();
  }

  String _renderHtml(String? text) {
    if (text == null) return '';
    // Заменяем <a> теги на обычный текст, делая ссылки неактивными
    return text
        .replaceAllMapped(
          RegExp(r'<a[^>]*>(.*?)</a>', dotAll: true),
          (match) => match.group(1) ?? '',
        ) // Извлекаем только текст из ссылок
        .replaceAll('&nbsp;', ' ') // Заменяем HTML пробелы
        .replaceAll('&amp;', '&') // Заменяем HTML амперсанды
        .replaceAll('&lt;', '<') // Заменяем HTML символы
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim(); // Убираем лишние пробелы
  }

  void _updateFilteredFeats() {
    List<FeatModel> typeFeats;
    if (_selectedType.isEmpty) {
      // Если тип не выбран, показываем все черты
      typeFeats = widget.allFeats;
    } else {
      typeFeats = widget.groupedFeats[_selectedType] ?? [];
    }

    if (_searchQuery.isEmpty) {
      _filteredFeats = typeFeats;
    } else {
      _filteredFeats =
          typeFeats
              .where(
                (feat) =>
                    feat.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    (_renderHtml(
                      feat.description,
                    ).toLowerCase().contains(_searchQuery.toLowerCase())) ||
                    (_renderHtml(
                      feat.requirements,
                    ).toLowerCase().contains(_searchQuery.toLowerCase())),
              )
              .toList();
    }
  }

  void _toggleFeat(FeatModel feat) {
    setState(() {
      if (_tempSelectedFeats.any((f) => f.id == feat.id)) {
        _tempSelectedFeats.removeWhere((f) => f.id == feat.id);
      } else {
        _tempSelectedFeats.add(feat);
      }
    });
  }

  void _saveSelection() {
    widget.onFeatsChanged(_tempSelectedFeats);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Выбор черт',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Выбрано: ${_tempSelectedFeats.length}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Поиск
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск по чертам...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.search,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _updateFilteredFeats();
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Селектор типа
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomBottomSheetSelect(
              label: 'Выберите тип черты',
              value: _selectedType,
              items: [
                '',
                ...widget.uniqueTypes,
              ], // Добавляем пустую строку для "Не выбрано"
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                  _updateFilteredFeats();
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Список черт
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (_filteredFeats.isNotEmpty)
                    ..._filteredFeats.map((feat) {
                      final isSelected = _tempSelectedFeats.any(
                        (f) => f.id == feat.id,
                      );
                      return _buildFeatItem(feat, isSelected);
                    })
                  else
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _searchQuery.isEmpty
                            ? (_selectedType.isEmpty
                                ? 'Выберите тип черты'
                                : 'Нет черт в выбранном типе')
                            : 'Черты не найдены',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Кнопки
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Btn(
                    text: 'СОХРАНИТЬ',
                    onPressed: _saveSelection,
                    buttonSize: 50,
                    textSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2A2A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'ОТМЕНА',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatItem(FeatModel feat, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF5B2333) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected
                  ? const Color(0xFF5B2333)
                  : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleFeat(feat),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        feat.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check, color: Colors.white, size: 20),
                  ],
                ),
                if (feat.requirements != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Требования: ${_renderHtml(feat.requirements)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
                if (feat.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _renderHtml(feat.description),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Источник: ${feat.book.abbreviation}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
