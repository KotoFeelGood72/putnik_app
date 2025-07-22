class EditField {
  final String key;
  final String label;
  final dynamic value;
  final String? displayValue;
  final String hint;
  final bool isEditable;

  EditField({
    required this.key,
    required this.label,
    required this.value,
    this.displayValue,
    required this.hint,
    this.isEditable = true,
  });
}
