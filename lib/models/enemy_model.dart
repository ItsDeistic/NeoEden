class EnemyModel {
  final String id;
  final String name;
  final int level;
  final int health;
  final int maxHealth;
  final Map<String, int> attributes;
  final List<String> abilities;
  final List<String> dropTable;
  final int experienceReward;
  final String zone;
  final double positionX;
  final double positionY;
  final DateTime createdAt;
  final DateTime updatedAt;

  EnemyModel({
    required this.id,
    required this.name,
    required this.level,
    required this.health,
    required this.maxHealth,
    required this.attributes,
    required this.abilities,
    required this.dropTable,
    required this.experienceReward,
    required this.zone,
    required this.positionX,
    required this.positionY,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'level': level,
    'health': health,
    'maxHealth': maxHealth,
    'attributes': attributes,
    'abilities': abilities,
    'dropTable': dropTable,
    'experienceReward': experienceReward,
    'zone': zone,
    'positionX': positionX,
    'positionY': positionY,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory EnemyModel.fromJson(Map<String, dynamic> json) => EnemyModel(
    id: json['id'] as String,
    name: json['name'] as String,
    level: json['level'] as int,
    health: json['health'] as int,
    maxHealth: json['maxHealth'] as int,
    attributes: Map<String, int>.from(json['attributes'] as Map),
    abilities: List<String>.from(json['abilities'] as List),
    dropTable: List<String>.from(json['dropTable'] as List),
    experienceReward: json['experienceReward'] as int,
    zone: json['zone'] as String,
    positionX: (json['positionX'] as num).toDouble(),
    positionY: (json['positionY'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  EnemyModel copyWith({
    String? id,
    String? name,
    int? level,
    int? health,
    int? maxHealth,
    Map<String, int>? attributes,
    List<String>? abilities,
    List<String>? dropTable,
    int? experienceReward,
    String? zone,
    double? positionX,
    double? positionY,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EnemyModel(
    id: id ?? this.id,
    name: name ?? this.name,
    level: level ?? this.level,
    health: health ?? this.health,
    maxHealth: maxHealth ?? this.maxHealth,
    attributes: attributes ?? this.attributes,
    abilities: abilities ?? this.abilities,
    dropTable: dropTable ?? this.dropTable,
    experienceReward: experienceReward ?? this.experienceReward,
    zone: zone ?? this.zone,
    positionX: positionX ?? this.positionX,
    positionY: positionY ?? this.positionY,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
