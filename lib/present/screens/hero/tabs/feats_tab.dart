import 'package:flutter/material.dart';
import '../../../../models/feat_model.dart';
import '../../../../services/feats_service.dart';
import '../../../components/inputs/feats_selector.dart';
import '../../../components/button/btn.dart';

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

  String _renderHtml(String? text) {
    if (text == null) return '';
    // Заменяем <a> теги на обычный текст, делая ссылки неактивными
    return text
        .replaceAllMapped(RegExp(r'<a[^>]*>(.*?)</a>', dotAll: true), (match) => match.group(1) ?? '') // Извлекаем только текст из ссылок
        .replaceAll('&nbsp;', ' ') // Заменяем HTML пробелы
        .replaceAll('&amp;', '&') // Заменяем HTML амперсанды
        .replaceAll('&lt;', '<') // Заменяем HTML символы
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim(); // Убираем лишние пробелы
  }

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

  void _onFeatsChanged(List<FeatModel> newFeats) {
    final featsData =
        newFeats
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Заголовок секции
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Черты',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Btn(
                    text: 'ДОБАВИТЬ',
                    onPressed: () {
                      // Селектор уже встроен в FeatsSelector
                    },
                    buttonSize: 40,
                    textSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Селектор черт
          FeatsSelector(
            selectedFeats: _selectedFeats,
            onFeatsChanged: _onFeatsChanged,
            allFeats: widget.allFeats,
          ),

          const SizedBox(height: 20),

          // Список выбранных черт
          if (_selectedFeats.isNotEmpty) ...[
            const Text(
              'Выбранные черты',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildSelectedFeatsList(),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildSelectedFeatsList() {
    final groupedFeats = FeatsService.groupFeatsByType(_selectedFeats);
    final widgets = <Widget>[];

    for (final entry in groupedFeats.entries) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок типа
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B2333),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Черты этого типа
              ...entry.value.map((feat) => _buildFeatCard(feat)),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildFeatCard(FeatModel feat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Название черты
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
              Text(
                feat.book.abbreviation,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),

          // Требования
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

          // Описание
          if (feat.description != null) ...[
            const SizedBox(height: 4),
            Text(
              _renderHtml(feat.description),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
