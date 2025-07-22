import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String placeholder;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final bool isNumber;
  final String? label;

  const InputField({
    Key? key,
    required this.placeholder,
    this.initialValue,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isNumber = false,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final input = Expanded(
      child: TextFormField(
        style: const TextStyle(color: Colors.white, fontSize: 12),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.grey),
          isDense: true,
          contentPadding: const EdgeInsets.all(10),
        ),
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: isNumber ? TextInputType.number : keyboardType,
      ),
    );

    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
