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
    this.cost,
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
    return WeaponModel(
      alias: json['alias'] as String?,
      name: json['name'] as String?,
      engName: json['engName'] as String?,
      type: json['type'] as String?,
      cost: json['cost'] as int?,
      damageS: json['damageS'] as String?,
      damageM: json['damageM'] as String?,
      criticalRoll: json['criticalRoll'] as String?,
      criticalDamage: json['criticalDamage'] as String?,
      range: json['range'] as String?,
      misfire: json['misfire'] as String?,
      capacity: json['capacity'] as String?,
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      special: json['special'] as String?,
      description: json['description'] as String?,
      proficientCategory:
          json['proficientCategory'] != null
              ? WeaponCategory.fromJson(
                json['proficientCategory'] as Map<String, dynamic>,
              )
              : null,
      rangeCategory:
          json['rangeCategory'] != null
              ? WeaponCategory.fromJson(
                json['rangeCategory'] as Map<String, dynamic>,
              )
              : null,
      encumbranceCategory:
          json['encumbranceCategory'] != null
              ? WeaponCategory.fromJson(
                json['encumbranceCategory'] as Map<String, dynamic>,
              )
              : null,
      parents:
          json['parents'] != null
              ? (json['parents'] as List)
                  .map((e) => WeaponModel.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
      book:
          json['book'] != null
              ? WeaponBook.fromJson(json['book'] as Map<String, dynamic>)
              : null,
      childs:
          json['childs'] != null
              ? (json['childs'] as List)
                  .map((e) => WeaponModel.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
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
    return WeaponCategory(
      name: json['name'] as String?,
      alias: json['alias'] as String?,
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
    return WeaponBook(
      alias: json['alias'] as String?,
      name: json['name'] as String?,
      order: json['order'] as int?,
      abbreviation: json['abbreviation'] as String?,
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
