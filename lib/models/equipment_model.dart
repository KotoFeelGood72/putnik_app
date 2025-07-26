class EquipmentModel {
  final String name;
  final double weight;
  final String? description;
  final String? type;
  final String? id;

  EquipmentModel({
    required this.name,
    required this.weight,
    this.description,
    this.type,
    this.id,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'description': description,
      'type': type,
    };
  }
}
