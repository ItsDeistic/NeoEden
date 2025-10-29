class CharacterModel {
  final String id;
  final String userId;
  final String name;
  final String profession;
  final String breed;
  final String gender;
  final int level;
  final int experience;
  final int health;
  final int maxHealth;
  final int nanoEnergy;
  final int maxNanoEnergy;
  final Map<String, int> attributes;
  final List<String> equippedItems;
  final String? currentZone;
  final double positionX;
  final double positionY;
  final DateTime createdAt;
  final DateTime updatedAt;

  CharacterModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.profession,
    required this.breed,
    required this.gender,
    required this.level,
    required this.experience,
    required this.health,
    required this.maxHealth,
    required this.nanoEnergy,
    required this.maxNanoEnergy,
    required this.attributes,
    required this.equippedItems,
    this.currentZone,
    required this.positionX,
    required this.positionY,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'profession': profession,
    'breed': breed,
    'gender': gender,
    'level': level,
    'experience': experience,
    'health': health,
    'maxHealth': maxHealth,
    'nanoEnergy': nanoEnergy,
    'maxNanoEnergy': maxNanoEnergy,
    'attributes': attributes,
    'equippedItems': equippedItems,
    'currentZone': currentZone,
    'positionX': positionX,
    'positionY': positionY,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    profession: json['profession'] as String,
    breed: json['breed'] as String,
    gender: json['gender'] as String,
    level: json['level'] as int,
    experience: json['experience'] as int,
    health: json['health'] as int,
    maxHealth: json['maxHealth'] as int,
    nanoEnergy: json['nanoEnergy'] as int,
    maxNanoEnergy: json['maxNanoEnergy'] as int,
    attributes: Map<String, int>.from(json['attributes'] as Map),
    equippedItems: List<String>.from(json['equippedItems'] as List),
    currentZone: json['currentZone'] as String?,
    positionX: (json['positionX'] as num).toDouble(),
    positionY: (json['positionY'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  CharacterModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? profession,
    String? breed,
    String? gender,
    int? level,
    int? experience,
    int? health,
    int? maxHealth,
    int? nanoEnergy,
    int? maxNanoEnergy,
    Map<String, int>? attributes,
    List<String>? equippedItems,
    String? currentZone,
    double? positionX,
    double? positionY,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CharacterModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    profession: profession ?? this.profession,
    breed: breed ?? this.breed,
    gender: gender ?? this.gender,
    level: level ?? this.level,
    experience: experience ?? this.experience,
    health: health ?? this.health,
    maxHealth: maxHealth ?? this.maxHealth,
    nanoEnergy: nanoEnergy ?? this.nanoEnergy,
    maxNanoEnergy: maxNanoEnergy ?? this.maxNanoEnergy,
    attributes: attributes ?? this.attributes,
    equippedItems: equippedItems ?? this.equippedItems,
    currentZone: currentZone ?? this.currentZone,
    positionX: positionX ?? this.positionX,
    positionY: positionY ?? this.positionY,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
