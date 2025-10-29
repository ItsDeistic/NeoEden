import 'package:neoeden/models/item_model.dart';
import 'package:neoeden/services/storage_service.dart';

class ItemService {
  static final ItemService _instance = ItemService._internal();
  factory ItemService() => _instance;
  ItemService._internal();

  final StorageService _storage = StorageService();
  static const String _storageKey = 'items';

  Future<List<ItemModel>> getAllItems() async {
    final data = await _storage.load(_storageKey);
    if (data == null) {
      await _initializeItems();
      return getAllItems();
    }
    
    try {
      return (data as List).map((json) => ItemModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      await _initializeItems();
      return getAllItems();
    }
  }

  Future<ItemModel?> getItemById(String id) async {
    final items = await getAllItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> _initializeItems() async {
    final items = [
      ItemModel(id: 'weapon_1', name: 'Plasma Pistol', description: 'Basic energy weapon', type: 'Weapon', rarity: 'Common', level: 1, stats: {'damage': 15, 'range': 20}, weight: 2, value: 50, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'weapon_2', name: 'Nano Rifle', description: 'Advanced nano-tech rifle', type: 'Weapon', rarity: 'Uncommon', level: 5, stats: {'damage': 35, 'range': 30}, weight: 4, value: 250, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'weapon_3', name: 'Molecular Blade', description: 'Sharp molecular weapon', type: 'Weapon', rarity: 'Rare', level: 10, stats: {'damage': 55, 'range': 5}, weight: 3, value: 800, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'armor_1', name: 'Light Combat Suit', description: 'Basic protection', type: 'Armor', rarity: 'Common', level: 1, stats: {'defense': 10, 'stamina': 2}, weight: 5, value: 40, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'armor_2', name: 'Reinforced Vest', description: 'Enhanced armor plating', type: 'Armor', rarity: 'Uncommon', level: 5, stats: {'defense': 25, 'stamina': 5}, weight: 8, value: 200, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'armor_3', name: 'Nano-Weave Armor', description: 'Advanced defensive suit', type: 'Armor', rarity: 'Rare', level: 10, stats: {'defense': 45, 'stamina': 10}, weight: 10, value: 750, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'implant_1', name: 'Basic Neural Chip', description: 'Enhances cognition', type: 'Implant', rarity: 'Common', level: 1, stats: {'intelligence': 3}, weight: 0, value: 100, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'implant_2', name: 'Strength Booster', description: 'Muscle enhancement', type: 'Implant', rarity: 'Uncommon', level: 5, stats: {'strength': 8}, weight: 0, value: 300, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'implant_3', name: 'Reflex Enhancer', description: 'Speed augmentation', type: 'Implant', rarity: 'Rare', level: 10, stats: {'agility': 12}, weight: 0, value: 700, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'consumable_1', name: 'Health Stim', description: 'Restores 50 HP', type: 'Consumable', rarity: 'Common', level: 1, stats: {'healing': 50}, weight: 1, value: 20, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'consumable_2', name: 'Nano Injector', description: 'Restores 100 nano energy', type: 'Consumable', rarity: 'Common', level: 1, stats: {'nanoRestore': 100}, weight: 1, value: 25, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ItemModel(id: 'consumable_3', name: 'Combat Stimulant', description: 'Temporary damage boost', type: 'Consumable', rarity: 'Uncommon', level: 5, stats: {'damageBoost': 20}, weight: 1, value: 80, createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ];
    await _storage.save(_storageKey, items.map((i) => i.toJson()).toList());
  }
}
