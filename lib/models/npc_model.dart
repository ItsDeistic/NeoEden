class NPCModel {
  final String id;
  final String name;
  final String type;
  final String? dialogue;
  final String? faction;
  final double positionX;
  final double positionY;
  final String zone;
  final List<String>? availableQuests;
  final List<String>? vendorItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  NPCModel({
    required this.id,
    required this.name,
    required this.type,
    this.dialogue,
    this.faction,
    required this.positionX,
    required this.positionY,
    required this.zone,
    this.availableQuests,
    this.vendorItems,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'dialogue': dialogue,
    'faction': faction,
    'positionX': positionX,
    'positionY': positionY,
    'zone': zone,
    'availableQuests': availableQuests,
    'vendorItems': vendorItems,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory NPCModel.fromJson(Map<String, dynamic> json) => NPCModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    dialogue: json['dialogue'] as String?,
    faction: json['faction'] as String?,
    positionX: (json['positionX'] as num).toDouble(),
    positionY: (json['positionY'] as num).toDouble(),
    zone: json['zone'] as String,
    availableQuests: json['availableQuests'] != null ? List<String>.from(json['availableQuests'] as List) : null,
    vendorItems: json['vendorItems'] != null ? List<String>.from(json['vendorItems'] as List) : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  NPCModel copyWith({
    String? id,
    String? name,
    String? type,
    String? dialogue,
    String? faction,
    double? positionX,
    double? positionY,
    String? zone,
    List<String>? availableQuests,
    List<String>? vendorItems,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NPCModel(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    dialogue: dialogue ?? this.dialogue,
    faction: faction ?? this.faction,
    positionX: positionX ?? this.positionX,
    positionY: positionY ?? this.positionY,
    zone: zone ?? this.zone,
    availableQuests: availableQuests ?? this.availableQuests,
    vendorItems: vendorItems ?? this.vendorItems,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
