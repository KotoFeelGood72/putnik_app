class FeatModel {
  final int id;
  final String name;
  final String alias;
  final String? requirements;
  final String? description;
  final int? parentFeatId;
  final List<FeatType> types;
  final FeatBook book;

  FeatModel({
    required this.id,
    required this.name,
    required this.alias,
    this.requirements,
    this.description,
    this.parentFeatId,
    required this.types,
    required this.book,
  });

  factory FeatModel.fromJson(Map<String, dynamic> json) {
    return FeatModel(
      id: json['id'],
      name: json['name'],
      alias: json['alias'],
      requirements: json['requirements'],
      description: json['description'],
      parentFeatId: json['parentFeatId'],
      types:
          (json['types'] as List)
              .map((type) => FeatType.fromJson(type))
              .toList(),
      book: FeatBook.fromJson(json['book']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'alias': alias,
    if (requirements != null) 'requirements': requirements,
    if (description != null) 'description': description,
    if (parentFeatId != null) 'parentFeatId': parentFeatId,
    'types': types.map((type) => type.toJson()).toList(),
    'book': book.toJson(),
  };
}

class FeatType {
  final String name;
  final String alias;

  FeatType({required this.name, required this.alias});

  factory FeatType.fromJson(Map<String, dynamic> json) {
    return FeatType(name: json['name'], alias: json['alias']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'alias': alias};
}

class FeatBook {
  final String alias;
  final String name;
  final int order;
  final String abbreviation;

  FeatBook({
    required this.alias,
    required this.name,
    required this.order,
    required this.abbreviation,
  });

  factory FeatBook.fromJson(Map<String, dynamic> json) {
    return FeatBook(
      alias: json['alias'],
      name: json['name'],
      order: json['order'],
      abbreviation: json['abbreviation'],
    );
  }

  Map<String, dynamic> toJson() => {
    'alias': alias,
    'name': name,
    'order': order,
    'abbreviation': abbreviation,
  };
}
