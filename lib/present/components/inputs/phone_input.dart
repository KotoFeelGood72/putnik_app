import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

class PhoneInput extends StatelessWidget {
  final MaskedTextController controller;
  final bool hasError;
  final String? errorText;
  final void Function(String)? onChanged;

  const PhoneInput({
    super.key,
    required this.controller,
    this.hasError = false,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '+7 (999) 000-00-00',
        hintStyle: const TextStyle(fontSize: 16, color: AppColors.black),
        errorText: hasError ? errorText : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: hasError ? Colors.red : AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: hasError ? Colors.red : AppColors.blue,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
