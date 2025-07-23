import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String placeholder;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final bool isNumber;
  final String? label;
  final bool obscureText;
  final bool showToggle;
  final VoidCallback? onToggle;
  final bool isObscured;
  final double textSize;
  final double height;
  final Widget? customSuffixIcon;

  const InputField({
    Key? key,
    required this.placeholder,
    this.initialValue,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isNumber = false,
    this.label,
    this.obscureText = false,
    this.showToggle = false,
    this.onToggle,
    this.isObscured = false,
    this.textSize = 14,
    this.height = 48,
    this.customSuffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputField = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(color: Colors.white, fontSize: textSize),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: placeholder,
        hintStyle: TextStyle(color: Colors.grey, fontSize: textSize),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        suffixIcon:
            showToggle && customSuffixIcon == null
                ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: onToggle,
                )
                : null,
      ),
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: isNumber ? TextInputType.number : keyboardType,
      obscureText: obscureText && isObscured,
    );

    Widget input = Expanded(child: inputField);

    if (customSuffixIcon != null) {
      input = Expanded(
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            inputField,
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(child: customSuffixIcon!),
            ),
          ],
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(minHeight: height),
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          label != null
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  input,
                ],
              )
              : input,
    );
  }
}
