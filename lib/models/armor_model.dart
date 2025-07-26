class ArmorModel {
  final String? alias;
  final String? name;
  final String? engName;
  final String? type;
  final int? cost;
  final int? armorBonus;
  final int? maxDexBonus;
  final int? armorCheckPenalty;
  final int? arcaneSpellFailure;
  final double? weight;
  final String? special;
  final String? description;
  final ArmorCategory? armorCategory;
  final ArmorBook? book;

  ArmorModel({
    this.alias,
    this.name,
    this.engName,
    this.type,
    this.cost,
    this.armorBonus,
    this.maxDexBonus,
    this.armorCheckPenalty,
    this.arcaneSpellFailure,
    this.weight,
    this.special,
    this.description,
    this.armorCategory,
    this.book,
  });

  factory ArmorModel.fromJson(Map<String, dynamic> json) {
    // Безопасное извлечение значений с проверкой типов
    String? safeString(dynamic value) {
      return value is String ? value : null;
    }

    int? safeInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    double? safeDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    ArmorCategory? safeArmorCategory(dynamic value) {
      if (value is Map<String, dynamic>) {
        return ArmorCategory.fromJson(value);
      }
      return null;
    }

    ArmorBook? safeArmorBook(dynamic value) {
      if (value is Map<String, dynamic>) {
        return ArmorBook.fromJson(value);
      }
      return null;
    }

    return ArmorModel(
      alias: safeString(json['alias']),
      name: safeString(json['name']),
      engName: safeString(json['engName']),
      type: safeString(json['type']),
      cost: safeInt(json['cost']),
      armorBonus: safeInt(json['armorBonus']),
      maxDexBonus: safeInt(json['maxDexBonus']),
      armorCheckPenalty: safeInt(json['armorCheckPenalty']),
      arcaneSpellFailure: safeInt(json['arcaneSpellFailure']),
      weight: safeDouble(json['weight']),
      special: safeString(json['special']),
      description: safeString(json['description']),
      armorCategory: safeArmorCategory(json['armorCategory']),
      book: safeArmorBook(json['book']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      'name': name,
      'engName': engName,
      'type': type,
      'cost': cost,
      'armorBonus': armorBonus,
      'maxDexBonus': maxDexBonus,
      'armorCheckPenalty': armorCheckPenalty,
      'arcaneSpellFailure': arcaneSpellFailure,
      'weight': weight,
      'special': special,
      'description': description,
      'armorCategory': armorCategory?.toJson(),
      'book': book?.toJson(),
    };
  }
}

class ArmorCategory {
  final String? name;
  final String? alias;

  ArmorCategory({this.name, this.alias});

  factory ArmorCategory.fromJson(Map<String, dynamic> json) {
    String? safeString(dynamic value) {
      return value is String ? value : null;
    }

    return ArmorCategory(
      name: safeString(json['name']),
      alias: safeString(json['alias']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'alias': alias};
  }
}

class ArmorBook {
  final String? alias;
  final String? name;
  final int? order;
  final String? abbreviation;

  ArmorBook({this.alias, this.name, this.order, this.abbreviation});

  factory ArmorBook.fromJson(Map<String, dynamic> json) {
    String? safeString(dynamic value) {
      return value is String ? value : null;
    }

    int? safeInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return ArmorBook(
      alias: safeString(json['alias']),
      name: safeString(json['name']),
      order: safeInt(json['order']),
      abbreviation: safeString(json['abbreviation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      'name': name,
      'order': order,
      'abbreviation': abbreviation,
    };
  }
}
