class ItemModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final String rarity;
  final int level;
  final Map<String, int> stats;
  final int weight;
  final int value;
  final String? iconName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.level,
    required this.stats,
    required this.weight,
    required this.value,
    this.iconName,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type,
    'rarity': rarity,
    'level': level,
    'stats': stats,
    'weight': weight,
    'value': value,
    'iconName': iconName,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
    rarity: json['rarity'] as String,
    level: json['level'] as int,
    stats: Map<String, int>.from(json['stats'] as Map),
    weight: json['weight'] as int,
    value: json['value'] as int,
    iconName: json['iconName'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  ItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? rarity,
    int? level,
    Map<String, int>? stats,
    int? weight,
    int? value,
    String? iconName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ItemModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    type: type ?? this.type,
    rarity: rarity ?? this.rarity,
    level: level ?? this.level,
    stats: stats ?? this.stats,
    weight: weight ?? this.weight,
    value: value ?? this.value,
    iconName: iconName ?? this.iconName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
