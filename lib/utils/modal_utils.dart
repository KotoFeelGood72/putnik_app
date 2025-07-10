import 'package:flutter/material.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool enableDrag = true,
  bool scroll = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // важно
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6, // по умолчанию 60%
        minChildSize: 0.3,
        maxChildSize: 0.9, // максимум 90% от экрана
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 24, top: 20),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                builder(context),
              ],
            ),
          );
        },
      );
    },
  );
}
