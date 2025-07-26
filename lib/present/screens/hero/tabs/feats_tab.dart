import 'package:flutter/material.dart';
import '../../../../models/feat_model.dart';
import '../../../../services/feats_service.dart';
import '../../../components/inputs/custom_bottom_sheet_select.dart';

class FeatsTab extends StatefulWidget {
  final List<Map<String, dynamic>> feats;
  final Function(List<Map<String, dynamic>>) onFeatsChanged;
  final List<FeatModel> allFeats;

  const FeatsTab({
    super.key,
    required this.feats,
    required this.onFeatsChanged,
    required this.allFeats,
  });

  @override
  State<FeatsTab> createState() => _FeatsTabState();
}

class _FeatsTabState extends State<FeatsTab> {
  List<FeatModel> _selectedFeats = [];
  String _search = '';
  String _selectedType = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedFeats();
  }

  @override
  void didUpdateWidget(FeatsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feats != widget.feats) {
      _loadSelectedFeats();
    }
  }

  void _loadSelectedFeats() {
    _selectedFeats = [];
    for (final featData in widget.feats) {
      final featId = featData['id'] as int?;
      if (featId != null) {
        final feat = widget.allFeats.firstWhere(
          (f) => f.id == featId,
          orElse:
              () => FeatModel(
                id: featId,
                name: featData['name'] ?? 'Неизвестная черта',
                alias: featData['alias'] ?? 'unknown',
                requirements: featData['requirements'],
                description: featData['description'],
                parentFeatId: featData['parentFeatId'],
                types: [
                  FeatType(
                    name: featData['type'] ?? 'Общая',
                    alias: featData['typeAlias'] ?? 'general',
                  ),
                ],
                book: FeatBook(
                  alias: featData['bookAlias'] ?? 'unknown',
                  name: featData['bookName'] ?? 'Неизвестный источник',
                  order: featData['bookOrder'] ?? 0,
                  abbreviation: featData['bookAbbreviation'] ?? '?',
                ),
              ),
        );
        _selectedFeats.add(feat);
      }
    }
  }

  void _onRemoveFeat(FeatModel feat) {
    setState(() {
      _selectedFeats.removeWhere((f) => f.id == feat.id);
      _saveSelection();
    });
  }

  void _onAddFeat(FeatModel feat) {
    setState(() {
      if (!_selectedFeats.any((f) => f.id == feat.id)) {
        _selectedFeats.add(feat);
        _saveSelection();
      }
    });
  }

  void _saveSelection() {
    final featsData =
        _selectedFeats
            .map(
              (feat) => {
                'id': feat.id,
                'name': feat.name,
                'alias': feat.alias,
                'requirements': feat.requirements,
                'description': feat.description,
                'parentFeatId': feat.parentFeatId,
                'type': feat.types.isNotEmpty ? feat.types.first.name : 'Общая',
                'typeAlias':
                    feat.types.isNotEmpty ? feat.types.first.alias : 'general',
                'bookAlias': feat.book.alias,
                'bookName': feat.book.name,
                'bookOrder': feat.book.order,
                'bookAbbreviation': feat.book.abbreviation,
              },
            )
            .toList();
    widget.onFeatsChanged(featsData);
  }

  List<String> get _allTypes {
    final types =
        widget.allFeats
            .expand((f) => f.types.map((t) => t.name))
            .toSet()
            .toList();
    types.sort();
    return types;
  }

  List<FeatModel> get _filteredFeats {
    final allFeats =
        _selectedType == 'Мои черты' ? _selectedFeats : widget.allFeats;
    return allFeats.where((feat) {
      final matchesType =
          _selectedType.isEmpty ||
          _selectedType == 'Мои черты' ||
          feat.types.any((t) => t.name == _selectedType);
      final matchesSearch =
          _search.isEmpty ||
          feat.name.toLowerCase().contains(_search.toLowerCase()) ||
          (feat.description?.toLowerCase().contains(_search.toLowerCase()) ??
              false);
      return matchesType && matchesSearch;
    }).toList();
  }

  String _renderHtml(String? text) {
    if (text == null) return '';
    return text
        .replaceAllMapped(
          RegExp(r'<a[^>]*>(.*?)</a>', dotAll: true),
          (match) => match.group(1) ?? '',
        )
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск черты...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF232323),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8,
                  ),
                ),
                onChanged: (val) => setState(() => _search = val),
              ),
              const SizedBox(height: 8),
              CustomBottomSheetSelect(
                label: 'Тип черты',
                value: _selectedType,
                items: ['', 'Мои черты', ..._allTypes],
                onChanged: (val) => setState(() => _selectedType = val),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              _filteredFeats.isEmpty
                  ? const Center(
                    child: Text(
                      'Ничего не найдено',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                  : ListView(
                    children:
                        _filteredFeats
                            .map((feat) => _buildFeatCard(feat))
                            .toList(),
                  ),
        ),
      ],
    );
  }

  Widget _buildFeatCard(FeatModel feat) {
    final isSelected = _selectedFeats.any((f) => f.id == feat.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isSelected
                ? Colors.green.withOpacity(0.08)
                : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: null,
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
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white54,
                          size: 20,
                        ),
                        onPressed: () => _onRemoveFeat(feat),
                        tooltip: 'Убрать',
                      )
                    else
                      IconButton(
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white54,
                          size: 20,
                        ),
                        onPressed: () => _onAddFeat(feat),
                        tooltip: 'Добавить',
                      ),
                  ],
                ),
                if (feat.requirements != null &&
                    feat.requirements!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Требования: ${_renderHtml(feat.requirements)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
                if (feat.description != null &&
                    feat.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _renderHtml(feat.description),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  feat.types.isNotEmpty ? feat.types.first.name : '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
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
