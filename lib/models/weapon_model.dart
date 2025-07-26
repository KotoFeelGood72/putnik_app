class WeaponModel {
  final String? alias;
  final String? name;
  final String? engName;
  final String? type;
  final int? cost;
  final String? damageS;
  final String? damageM;
  final String? criticalRoll;
  final String? criticalDamage;
  final String? range;
  final String? misfire;
  final String? capacity;
  final double? weight;
  final String? special;
  final String? description;
  final WeaponCategory? proficientCategory;
  final WeaponCategory? rangeCategory;
  final WeaponCategory? encumbranceCategory;
  final List<WeaponModel>? parents;
  final WeaponBook? book;
  final List<WeaponModel>? childs;

  WeaponModel({
    this.alias,
    this.name,
    this.engName,
    this.type,
    this.cost = 0,
    this.damageS,
    this.damageM,
    this.criticalRoll,
    this.criticalDamage,
    this.range,
    this.misfire,
    this.capacity,
    this.weight,
    this.special,
    this.description,
    this.proficientCategory,
    this.rangeCategory,
    this.encumbranceCategory,
    this.parents,
    this.book,
    this.childs,
  });

  factory WeaponModel.fromJson(Map<String, dynamic> json) {
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

    WeaponCategory? safeWeaponCategory(dynamic value) {
      if (value is Map<String, dynamic>) {
        return WeaponCategory.fromJson(value);
      }
      return null;
    }

    WeaponBook? safeWeaponBook(dynamic value) {
      if (value is Map<String, dynamic>) {
        return WeaponBook.fromJson(value);
      }
      return null;
    }

    List<WeaponModel>? safeWeaponList(dynamic value) {
      if (value is List) {
        return value
            .where((e) => e is Map<String, dynamic>)
            .map((e) => WeaponModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return null;
    }

    return WeaponModel(
      alias: safeString(json['alias']),
      name: safeString(json['name']),
      engName: safeString(json['engName']),
      type: safeString(json['type']),
      cost: safeInt(json['cost']) ?? 0,
      damageS: safeString(json['damageS']),
      damageM: safeString(json['damageM']),
      criticalRoll: safeString(json['criticalRoll']),
      criticalDamage: safeString(json['criticalDamage']),
      range: safeString(json['range']),
      misfire: safeString(json['misfire']),
      capacity: safeString(json['capacity']),
      weight: safeDouble(json['weight']),
      special: safeString(json['special']),
      description: safeString(json['description']),
      proficientCategory: safeWeaponCategory(json['proficientCategory']),
      rangeCategory: safeWeaponCategory(json['rangeCategory']),
      encumbranceCategory: safeWeaponCategory(json['encumbranceCategory']),
      parents: safeWeaponList(json['parents']),
      book: safeWeaponBook(json['book']),
      childs: safeWeaponList(json['childs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      'name': name,
      'engName': engName,
      'type': type,
      'cost': cost,
      'damageS': damageS,
      'damageM': damageM,
      'criticalRoll': criticalRoll,
      'criticalDamage': criticalDamage,
      'range': range,
      'misfire': misfire,
      'capacity': capacity,
      'weight': weight,
      'special': special,
      'description': description,
      'proficientCategory': proficientCategory?.toJson(),
      'rangeCategory': rangeCategory?.toJson(),
      'encumbranceCategory': encumbranceCategory?.toJson(),
      'parents': parents?.map((e) => e.toJson()).toList(),
      'book': book?.toJson(),
      'childs': childs?.map((e) => e.toJson()).toList(),
    };
  }
}

class WeaponCategory {
  final String? name;
  final String? alias;

  WeaponCategory({this.name, this.alias});

  factory WeaponCategory.fromJson(Map<String, dynamic> json) {
    String? safeString(dynamic value) {
      return value is String ? value : null;
    }

    return WeaponCategory(
      name: safeString(json['name']),
      alias: safeString(json['alias']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'alias': alias};
  }
}

class WeaponBook {
  final String? alias;
  final String? name;
  final int? order;
  final String? abbreviation;

  WeaponBook({this.alias, this.name, this.order, this.abbreviation});

  factory WeaponBook.fromJson(Map<String, dynamic> json) {
    String? safeString(dynamic value) {
      return value is String ? value : null;
    }

    int? safeInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return WeaponBook(
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
