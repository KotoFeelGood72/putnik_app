import 'package:flutter/material.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool loading;
  final double? buttonSize;

  const Btn({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonSize = 70,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = disabled || loading || onPressed == null;

    return SizedBox(
      height: buttonSize,
      width: double.infinity,
      child: GestureDetector(
        onTap: isDisabled ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: isDisabled ? const Color(0xFFE57373) : AppColors.primary,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF2B1A10), width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A0000).withOpacity(0.8),
                offset: const Offset(0, 6),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child:
                loading
                    ? const SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontFamily: 'Forum',
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 3),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
