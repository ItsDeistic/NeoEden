import 'package:neoeden/models/map_zone_model.dart';
import 'package:neoeden/services/storage_service.dart';
import 'dart:math' as math;

class MapService {
  static final MapService _instance = MapService._internal();
  factory MapService() => _instance;
  MapService._internal() {
    _initializeMaps();
  }

  final StorageService _storage = StorageService();
  final Map<String, MapZoneModel> _zones = {};
  
  List<MapZoneModel> get allZones => _zones.values.toList();
  
  MapZoneModel? getZone(String zoneId) => _zones[zoneId];

  void _initializeMaps() {
    _zones.clear();
    
    _zones['omni_entertainment'] = _createOmniEntertainment();
    _zones['old_athen'] = _createOldAthen();
    _zones['newland_desert'] = _createNewlandDesert();
    _zones['perpetual_wastelands'] = _createPerpetualWastelands();
    _zones['shadowlands'] = _createShadowlands();
    _zones['temple_winds'] = _createTempleOfThreeWinds();
  }

  MapZoneModel _createOmniEntertainment() {
    final width = 100;
    final height = 100;
    final tiles = _generateCityTiles(width, height, TileType.metalFloor);
    
    _addBuildings(tiles, [
      {'x': 10, 'y': 10, 'width': 15, 'height': 15},
      {'x': 40, 'y': 10, 'width': 20, 'height': 18},
      {'x': 70, 'y': 15, 'width': 12, 'height': 12},
      {'x': 15, 'y': 45, 'width': 18, 'height': 16},
      {'x': 50, 'y': 50, 'width': 25, 'height': 20},
    ]);
    
    _addRoads(tiles, width, height);

    return MapZoneModel(
      id: 'omni_entertainment',
      name: 'Omni-1 Entertainment',
      description: 'The bustling entertainment district of Omni-Tek, filled with neon lights and corporate presence.',
      width: width,
      height: height,
      tiles: tiles,
      connectedZones: ['old_athen', 'newland_desert'],
      recommendedLevel: 1,
      faction: 'Omni-Tek',
      npcs: _generateCityNPCs(),
      enemies: [],
      objects: _generateCityObjects(),
      spawnPoints: [
        SpawnPoint(x: 50.0, y: 50.0, type: 'player'),
        SpawnPoint(x: 20.0, y: 20.0, type: 'vendor'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MapZoneModel _createOldAthen() {
    final width = 120;
    final height = 120;
    final tiles = _generateCityTiles(width, height, TileType.concrete);
    
    _addBuildings(tiles, [
      {'x': 15, 'y': 15, 'width': 20, 'height': 20},
      {'x': 50, 'y': 10, 'width': 18, 'height': 22},
      {'x': 80, 'y': 20, 'width': 15, 'height': 18},
      {'x': 25, 'y': 55, 'width': 22, 'height': 18},
      {'x': 65, 'y': 60, 'width': 20, 'height': 25},
      {'x': 40, 'y': 85, 'width': 16, 'height': 14},
    ]);
    
    _addRoads(tiles, width, height);
    _addPark(tiles, 90, 85, 25, 30);

    return MapZoneModel(
      id: 'old_athen',
      name: 'Old Athen',
      description: 'The neutral hub city where Clan and Omni-Tek factions meet in an uneasy truce.',
      width: width,
      height: height,
      tiles: tiles,
      connectedZones: ['omni_entertainment', 'newland_desert', 'perpetual_wastelands'],
      recommendedLevel: 1,
      faction: 'Neutral',
      npcs: _generateCityNPCs(),
      enemies: [],
      objects: _generateCityObjects(),
      spawnPoints: [
        SpawnPoint(x: 60.0, y: 60.0, type: 'player'),
        SpawnPoint(x: 30.0, y: 30.0, type: 'vendor'),
        SpawnPoint(x: 70.0, y: 80.0, type: 'quest_giver'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MapZoneModel _createNewlandDesert() {
    final width = 150;
    final height = 150;
    final tiles = _generateDesertTiles(width, height);

    return MapZoneModel(
      id: 'newland_desert',
      name: 'Newland Desert',
      description: 'Vast sandy wastelands with scattered oases and dangerous creatures.',
      width: width,
      height: height,
      tiles: tiles,
      connectedZones: ['old_athen', 'omni_entertainment', 'perpetual_wastelands'],
      recommendedLevel: 10,
      faction: 'Neutral',
      npcs: _generateDesertNPCs(),
      enemies: _generateDesertEnemies(),
      objects: _generateDesertObjects(),
      spawnPoints: [
        SpawnPoint(x: 75.0, y: 75.0, type: 'player'),
        SpawnPoint(x: 20.0, y: 30.0, type: 'enemy'),
        SpawnPoint(x: 100.0, y: 120.0, type: 'enemy'),
        SpawnPoint(x: 130.0, y: 40.0, type: 'enemy'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MapZoneModel _createPerpetualWastelands() {
    final width = 180;
    final height = 180;
    final tiles = _generateWastelandTiles(width, height);

    return MapZoneModel(
      id: 'perpetual_wastelands',
      name: 'Perpetual Wastelands',
      description: 'Harsh radioactive wasteland filled with mutated creatures and hostile forces.',
      width: width,
      height: height,
      tiles: tiles,
      connectedZones: ['old_athen', 'newland_desert', 'shadowlands'],
      recommendedLevel: 50,
      faction: 'Hostile',
      npcs: [],
      enemies: _generateWastelandEnemies(),
      objects: _generateWastelandObjects(),
      spawnPoints: [
        SpawnPoint(x: 90.0, y: 90.0, type: 'player'),
        SpawnPoint(x: 30.0, y: 40.0, type: 'enemy'),
        SpawnPoint(x: 140.0, y: 160.0, type: 'enemy'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MapZoneModel _createShadowlands() {
    final width = 200;
    final height = 200;
    final tiles = _generateShadowlandsTiles(width, height);

    return MapZoneModel(
      id: 'shadowlands',
      name: 'Shadowlands',
      description: 'A mysterious parallel dimension with alien landscapes and powerful enemies.',
      width: width,
      height: height,
      tiles: tiles,
      connectedZones: ['perpetual_wastelands', 'temple_winds'],
      recommendedLevel: 100,
      faction: 'Alien',
      npcs: _generateShadowlandsNPCs(),
      enemies: _generateShadowlandsEnemies(),
      objects: _generateShadowlandsObjects(),
      spawnPoints: [
        SpawnPoint(x: 100.0, y: 100.0, type: 'player'),
        SpawnPoint(x: 50.0, y: 60.0, type: 'enemy'),
        SpawnPoint(x: 150.0, y: 140.0, type: 'enemy'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MapZoneModel _createTempleOfThreeWinds() {
    final width = 80;
    final height = 80;
    final tiles = _generateTempleTiles(width, height);

    return MapZoneModel(
      id: 'temple_winds',
      name: 'Temple of Three Winds',
      description: 'Ancient temple complex with powerful guardians and ancient secrets.',
      width: width,
      height: height,
      tiles: tiles,
      connectedZones: ['shadowlands'],
      recommendedLevel: 150,
      faction: 'Ancient',
      npcs: _generateTempleNPCs(),
      enemies: _generateTempleEnemies(),
      objects: _generateTempleObjects(),
      spawnPoints: [
        SpawnPoint(x: 40.0, y: 40.0, type: 'player'),
        SpawnPoint(x: 20.0, y: 20.0, type: 'boss'),
        SpawnPoint(x: 60.0, y: 60.0, type: 'boss'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  List<List<int>> _generateCityTiles(int width, int height, int baseType) {
    final tiles = List.generate(height, (_) => List.filled(width, baseType));
    return tiles;
  }

  List<List<int>> _generateDesertTiles(int width, int height) {
    final random = math.Random(42);
    final tiles = List.generate(height, (y) {
      return List.generate(width, (x) {
        final noise = random.nextDouble();
        if (noise < 0.7) return TileType.sand;
        if (noise < 0.85) return TileType.dirtPath;
        return TileType.rock;
      });
    });
    
    _addOasis(tiles, 50, 50, 15);
    _addOasis(tiles, 120, 100, 12);
    
    return tiles;
  }

  List<List<int>> _generateWastelandTiles(int width, int height) {
    final random = math.Random(123);
    final tiles = List.generate(height, (y) {
      return List.generate(width, (x) {
        final noise = random.nextDouble();
        if (noise < 0.4) return TileType.crackedEarth;
        if (noise < 0.7) return TileType.rock;
        if (noise < 0.9) return TileType.toxic;
        return TileType.metal;
      });
    });
    return tiles;
  }

  List<List<int>> _generateShadowlandsTiles(int width, int height) {
    final random = math.Random(456);
    final tiles = List.generate(height, (y) {
      return List.generate(width, (x) {
        final noise = random.nextDouble();
        if (noise < 0.3) return TileType.alienFloor;
        if (noise < 0.6) return TileType.crystal;
        if (noise < 0.85) return TileType.voidTile;
        return TileType.energyField;
      });
    });
    return tiles;
  }

  List<List<int>> _generateTempleTiles(int width, int height) {
    final tiles = List.generate(height, (_) => List.filled(width, TileType.temple));
    
    for (int y = 25; y < 55; y++) {
      for (int x = 25; x < 55; x++) {
        tiles[y][x] = TileType.templeFloor;
      }
    }
    
    return tiles;
  }

  void _addBuildings(List<List<int>> tiles, List<Map<String, int>> buildings) {
    for (final building in buildings) {
      final x = building['x']!;
      final y = building['y']!;
      final width = building['width']!;
      final height = building['height']!;
      
      for (int dy = 0; dy < height; dy++) {
        for (int dx = 0; dx < width; dx++) {
          final ty = y + dy;
          final tx = x + dx;
          if (ty < tiles.length && tx < tiles[0].length) {
            if (dy == 0 || dy == height - 1 || dx == 0 || dx == width - 1) {
              tiles[ty][tx] = TileType.buildingWall;
            } else {
              tiles[ty][tx] = TileType.buildingFloor;
            }
          }
        }
      }
    }
  }

  void _addRoads(List<List<int>> tiles, int width, int height) {
    for (int x = 0; x < width; x++) {
      if (x % 25 == 0) {
        for (int y = 0; y < height; y++) {
          if (tiles[y][x] != TileType.buildingWall && tiles[y][x] != TileType.buildingFloor) {
            tiles[y][x] = TileType.road;
          }
        }
      }
    }
    
    for (int y = 0; y < height; y++) {
      if (y % 25 == 0) {
        for (int x = 0; x < width; x++) {
          if (tiles[y][x] != TileType.buildingWall && tiles[y][x] != TileType.buildingFloor) {
            tiles[y][x] = TileType.road;
          }
        }
      }
    }
  }

  void _addPark(List<List<int>> tiles, int startX, int startY, int width, int height) {
    for (int y = startY; y < startY + height && y < tiles.length; y++) {
      for (int x = startX; x < startX + width && x < tiles[0].length; x++) {
        tiles[y][x] = TileType.grass;
      }
    }
  }

  void _addOasis(List<List<int>> tiles, int centerX, int centerY, int radius) {
    for (int y = centerY - radius; y <= centerY + radius; y++) {
      for (int x = centerX - radius; x <= centerX + radius; x++) {
        if (y >= 0 && y < tiles.length && x >= 0 && x < tiles[0].length) {
          final distance = math.sqrt(math.pow(x - centerX, 2) + math.pow(y - centerY, 2));
          if (distance <= radius * 0.4) {
            tiles[y][x] = TileType.water;
          } else if (distance <= radius) {
            tiles[y][x] = TileType.grass;
          }
        }
      }
    }
  }

  List<MapNPC> _generateCityNPCs() => [
    MapNPC(id: 'vendor_1', name: 'Equipment Vendor', x: 25.0, y: 25.0, type: 'vendor'),
    MapNPC(id: 'vendor_2', name: 'Implant Vendor', x: 45.0, y: 30.0, type: 'vendor'),
    MapNPC(id: 'quest_1', name: 'Mission Terminal', x: 60.0, y: 40.0, type: 'quest_giver'),
    MapNPC(id: 'trainer_1', name: 'Skill Trainer', x: 35.0, y: 55.0, type: 'trainer'),
  ];

  List<MapNPC> _generateDesertNPCs() => [
    MapNPC(id: 'wanderer_1', name: 'Desert Wanderer', x: 75.0, y: 80.0, type: 'quest_giver'),
  ];

  List<MapNPC> _generateShadowlandsNPCs() => [
    MapNPC(id: 'guardian_1', name: 'Shadowlands Guardian', x: 100.0, y: 105.0, type: 'quest_giver'),
  ];

  List<MapNPC> _generateTempleNPCs() => [
    MapNPC(id: 'priest_1', name: 'Ancient Priest', x: 40.0, y: 35.0, type: 'quest_giver'),
  ];

  List<MapEnemy> _generateDesertEnemies() => [
    MapEnemy(id: 'desert_scorpion_1', name: 'Desert Scorpion', x: 30.0, y: 40.0, level: 12, type: 'beast'),
    MapEnemy(id: 'desert_scorpion_2', name: 'Desert Scorpion', x: 110.0, y: 130.0, level: 14, type: 'beast'),
    MapEnemy(id: 'sand_raider_1', name: 'Sand Raider', x: 80.0, y: 90.0, level: 15, type: 'humanoid'),
  ];

  List<MapEnemy> _generateWastelandEnemies() => [
    MapEnemy(id: 'mutant_1', name: 'Mutant Soldier', x: 40.0, y: 50.0, level: 55, type: 'mutant'),
    MapEnemy(id: 'mutant_2', name: 'Mutant Brute', x: 150.0, y: 170.0, level: 60, type: 'mutant'),
    MapEnemy(id: 'robot_1', name: 'War Bot', x: 100.0, y: 100.0, level: 58, type: 'mechanical'),
  ];

  List<MapEnemy> _generateShadowlandsEnemies() => [
    MapEnemy(id: 'redeemed_1', name: 'Redeemed Warrior', x: 60.0, y: 70.0, level: 105, type: 'alien'),
    MapEnemy(id: 'unredeemed_1', name: 'Unredeemed Beast', x: 160.0, y: 150.0, level: 110, type: 'alien'),
  ];

  List<MapEnemy> _generateTempleEnemies() => [
    MapEnemy(id: 'guardian_boss', name: 'Temple Guardian', x: 25.0, y: 25.0, level: 160, type: 'boss'),
    MapEnemy(id: 'wind_elemental', name: 'Wind Elemental', x: 65.0, y: 65.0, level: 155, type: 'elemental'),
  ];

  List<MapObject> _generateCityObjects() => [
    MapObject(id: 'lamp_1', name: 'Street Lamp', x: 20.0, y: 20.0, type: 'decoration'),
    MapObject(id: 'lamp_2', name: 'Street Lamp', x: 50.0, y: 50.0, type: 'decoration'),
    MapObject(id: 'terminal_1', name: 'Info Terminal', x: 60.0, y: 30.0, type: 'interactive'),
  ];

  List<MapObject> _generateDesertObjects() => [
    MapObject(id: 'cactus_1', name: 'Cactus', x: 40.0, y: 60.0, type: 'decoration'),
    MapObject(id: 'rock_1', name: 'Boulder', x: 90.0, y: 80.0, type: 'decoration'),
  ];

  List<MapObject> _generateWastelandObjects() => [
    MapObject(id: 'debris_1', name: 'Wreckage', x: 70.0, y: 80.0, type: 'decoration'),
    MapObject(id: 'barrel_1', name: 'Toxic Barrel', x: 120.0, y: 110.0, type: 'decoration'),
  ];

  List<MapObject> _generateShadowlandsObjects() => [
    MapObject(id: 'crystal_1', name: 'Energy Crystal', x: 80.0, y: 90.0, type: 'decoration'),
    MapObject(id: 'portal_1', name: 'Void Portal', x: 180.0, y: 180.0, type: 'interactive'),
  ];

  List<MapObject> _generateTempleObjects() => [
    MapObject(id: 'altar_1', name: 'Ancient Altar', x: 40.0, y: 40.0, type: 'interactive'),
    MapObject(id: 'statue_1', name: 'Guardian Statue', x: 30.0, y: 30.0, type: 'decoration'),
  ];
}

class TileType {
  static const int grass = 0;
  static const int dirt = 1;
  static const int sand = 2;
  static const int water = 3;
  static const int rock = 4;
  static const int metalFloor = 5;
  static const int concrete = 6;
  static const int road = 7;
  static const int buildingWall = 8;
  static const int buildingFloor = 9;
  static const int dirtPath = 10;
  static const int crackedEarth = 11;
  static const int toxic = 12;
  static const int metal = 13;
  static const int alienFloor = 14;
  static const int crystal = 15;
  static const int voidTile = 16;
  static const int energyField = 17;
  static const int temple = 18;
  static const int templeFloor = 19;
}
