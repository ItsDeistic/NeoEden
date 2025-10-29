class MapZoneModel {
  final String id;
  final String name;
  final String description;
  final int width;
  final int height;
  final List<List<int>> tiles;
  final List<String> connectedZones;
  final int recommendedLevel;
  final String faction;
  final List<MapNPC> npcs;
  final List<MapEnemy> enemies;
  final List<MapObject> objects;
  final List<SpawnPoint> spawnPoints;
  final DateTime createdAt;
  final DateTime updatedAt;

  MapZoneModel({
    required this.id,
    required this.name,
    required this.description,
    required this.width,
    required this.height,
    required this.tiles,
    required this.connectedZones,
    required this.recommendedLevel,
    required this.faction,
    this.npcs = const [],
    this.enemies = const [],
    this.objects = const [],
    this.spawnPoints = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'width': width,
    'height': height,
    'tiles': tiles,
    'connectedZones': connectedZones,
    'recommendedLevel': recommendedLevel,
    'faction': faction,
    'npcs': npcs.map((npc) => npc.toJson()).toList(),
    'enemies': enemies.map((enemy) => enemy.toJson()).toList(),
    'objects': objects.map((obj) => obj.toJson()).toList(),
    'spawnPoints': spawnPoints.map((sp) => sp.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory MapZoneModel.fromJson(Map<String, dynamic> json) => MapZoneModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    width: json['width'] as int,
    height: json['height'] as int,
    tiles: (json['tiles'] as List).map((row) => List<int>.from(row as List)).toList(),
    connectedZones: List<String>.from(json['connectedZones'] as List),
    recommendedLevel: json['recommendedLevel'] as int,
    faction: json['faction'] as String,
    npcs: (json['npcs'] as List?)?.map((e) => MapNPC.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    enemies: (json['enemies'] as List?)?.map((e) => MapEnemy.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    objects: (json['objects'] as List?)?.map((e) => MapObject.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    spawnPoints: (json['spawnPoints'] as List?)?.map((e) => SpawnPoint.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  MapZoneModel copyWith({
    String? id,
    String? name,
    String? description,
    int? width,
    int? height,
    List<List<int>>? tiles,
    List<String>? connectedZones,
    int? recommendedLevel,
    String? faction,
    List<MapNPC>? npcs,
    List<MapEnemy>? enemies,
    List<MapObject>? objects,
    List<SpawnPoint>? spawnPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MapZoneModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    width: width ?? this.width,
    height: height ?? this.height,
    tiles: tiles ?? this.tiles,
    connectedZones: connectedZones ?? this.connectedZones,
    recommendedLevel: recommendedLevel ?? this.recommendedLevel,
    faction: faction ?? this.faction,
    npcs: npcs ?? this.npcs,
    enemies: enemies ?? this.enemies,
    objects: objects ?? this.objects,
    spawnPoints: spawnPoints ?? this.spawnPoints,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class MapNPC {
  final String id;
  final String name;
  final double x;
  final double y;
  final String type;

  MapNPC({required this.id, required this.name, required this.x, required this.y, required this.type});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'x': x, 'y': y, 'type': type};
  
  factory MapNPC.fromJson(Map<String, dynamic> json) => MapNPC(
    id: json['id'] as String,
    name: json['name'] as String,
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    type: json['type'] as String,
  );
}

class MapEnemy {
  final String id;
  final String name;
  final double x;
  final double y;
  final int level;
  final String type;

  MapEnemy({required this.id, required this.name, required this.x, required this.y, required this.level, required this.type});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'x': x, 'y': y, 'level': level, 'type': type};
  
  factory MapEnemy.fromJson(Map<String, dynamic> json) => MapEnemy(
    id: json['id'] as String,
    name: json['name'] as String,
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    level: json['level'] as int,
    type: json['type'] as String,
  );
}

class MapObject {
  final String id;
  final String name;
  final double x;
  final double y;
  final String type;

  MapObject({required this.id, required this.name, required this.x, required this.y, required this.type});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'x': x, 'y': y, 'type': type};
  
  factory MapObject.fromJson(Map<String, dynamic> json) => MapObject(
    id: json['id'] as String,
    name: json['name'] as String,
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    type: json['type'] as String,
  );
}

class SpawnPoint {
  final double x;
  final double y;
  final String type;

  SpawnPoint({required this.x, required this.y, required this.type});

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'type': type};
  
  factory SpawnPoint.fromJson(Map<String, dynamic> json) => SpawnPoint(
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    type: json['type'] as String,
  );
}
