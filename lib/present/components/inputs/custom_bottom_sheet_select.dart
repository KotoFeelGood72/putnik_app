import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/button/btn.dart';

class CustomBottomSheetSelect extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const CustomBottomSheetSelect({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: const Color(0xFF232323),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return _BottomSheetSelectContent(
              label: label,
              value: value,
              items: items,
            );
          },
        );
        if (selected != null && selected != value) {
          onChanged(selected);
        } else if (selected == '') {
          onChanged('');
        }
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  value.isNotEmpty ? value : label,
                  style: TextStyle(
                    color: value.isNotEmpty ? Colors.white : Colors.grey,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// Добавляю новый StatefulWidget для контента модального окна
class _BottomSheetSelectContent extends StatefulWidget {
  final String label;
  final String value;
  final List<String> items;

  const _BottomSheetSelectContent({
    required this.label,
    required this.value,
    required this.items,
  });

  @override
  State<_BottomSheetSelectContent> createState() =>
      _BottomSheetSelectContentState();
}

class _BottomSheetSelectContentState extends State<_BottomSheetSelectContent> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    final tileHeight = 56.0;
    final filteredItems =
        widget.items
            .where((item) => item.toLowerCase().contains(search.toLowerCase()))
            .toList();
    final contentHeight =
        (filteredItems.length * tileHeight) +
        12 +
        8 +
        (widget.value.isNotEmpty ? 56 : 0) +
        60; // +60 для TextField
    final minSheetHeight = 400.0;
    final sheetHeight = contentHeight < maxHeight ? contentHeight : maxHeight;
    final normalizedSheetHeight =
        sheetHeight < minSheetHeight ? minSheetHeight : sheetHeight;
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          minHeight: minSheetHeight,
          maxHeight: normalizedSheetHeight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  filled: true,
                  fillColor: Color(0xFF2A2A2A),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (val) => setState(() => search = val),
              ),
            ),
            Expanded(
              child:
                  filteredItems.isEmpty
                      ? Center(
                        child: Text(
                          'Ничего не найдено',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.only(
                          bottom: 0,
                        ), // если нужен отступ
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: filteredItems.length,
                          separatorBuilder:
                              (context, index) => const Divider(
                                color: Colors.white24,
                                height: 1,
                                thickness: 1,
                              ),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return ListTile(
                              title: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () => Navigator.pop(context, item),
                              selected: item == widget.value,
                              selectedTileColor: Colors.white10,
                            );
                          },
                        ),
                      ),
            ),
            if (widget.value.isNotEmpty)
              Btn(
                text: 'Сбросить',
                onPressed: () => Navigator.pop(context, ''),
                buttonSize: 60,
                textSize: 18,
              ),
          ],
        ),
      ),
    );
  }
}
