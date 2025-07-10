import 'package:flutter/material.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool loading; // ← новое

  const Btn({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    // если идёт загрузка или disabled, кнопку блокируем
    final bool isDisabled = disabled || loading || onPressed == null;

    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
          backgroundColor:
              isDisabled ? AppColors.blue.withOpacity(0.5) : AppColors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        onPressed: isDisabled ? null : onPressed,
        child:
            loading
                ? const SizedBox(
                  // индикатор вместо текста
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
                : Text(
                  text,
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
      ),
    );
  }
}
