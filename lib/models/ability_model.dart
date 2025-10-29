class AbilityModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final int nanoCost;
  final int cooldown;
  final int damage;
  final String damageType;
  final int range;
  final List<String> allowedProfessions;
  final int requiredLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  AbilityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.nanoCost,
    required this.cooldown,
    required this.damage,
    required this.damageType,
    required this.range,
    required this.allowedProfessions,
    required this.requiredLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type,
    'nanoCost': nanoCost,
    'cooldown': cooldown,
    'damage': damage,
    'damageType': damageType,
    'range': range,
    'allowedProfessions': allowedProfessions,
    'requiredLevel': requiredLevel,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory AbilityModel.fromJson(Map<String, dynamic> json) => AbilityModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
    nanoCost: json['nanoCost'] as int,
    cooldown: json['cooldown'] as int,
    damage: json['damage'] as int,
    damageType: json['damageType'] as String,
    range: json['range'] as int,
    allowedProfessions: List<String>.from(json['allowedProfessions'] as List),
    requiredLevel: json['requiredLevel'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  AbilityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    int? nanoCost,
    int? cooldown,
    int? damage,
    String? damageType,
    int? range,
    List<String>? allowedProfessions,
    int? requiredLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AbilityModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    type: type ?? this.type,
    nanoCost: nanoCost ?? this.nanoCost,
    cooldown: cooldown ?? this.cooldown,
    damage: damage ?? this.damage,
    damageType: damageType ?? this.damageType,
    range: range ?? this.range,
    allowedProfessions: allowedProfessions ?? this.allowedProfessions,
    requiredLevel: requiredLevel ?? this.requiredLevel,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
