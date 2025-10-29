import 'package:neoeden/models/inventory_model.dart';
import 'package:neoeden/services/storage_service.dart';
import 'package:neoeden/utils/game_constants.dart';

class InventoryService {
  static final InventoryService _instance = InventoryService._internal();
  factory InventoryService() => _instance;
  InventoryService._internal();

  final StorageService _storage = StorageService();
  static const String _storageKey = 'inventories';

  Future<List<InventoryModel>> getAllInventories() async {
    final data = await _storage.load(_storageKey);
    if (data == null) return [];
    
    try {
      return (data as List).map((json) => InventoryModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      await _storage.save(_storageKey, []);
      return [];
    }
  }

  Future<InventoryModel?> getInventoryByCharacterId(String characterId) async {
    final inventories = await getAllInventories();
    try {
      return inventories.firstWhere((inv) => inv.characterId == characterId);
    } catch (e) {
      return null;
    }
  }

  Future<void> createInventory(String characterId) async {
    final inventory = InventoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      characterId: characterId,
      items: [
        InventoryItem(itemId: 'weapon_1', quantity: 1),
        InventoryItem(itemId: 'armor_1', quantity: 1),
        InventoryItem(itemId: 'consumable_1', quantity: 5),
        InventoryItem(itemId: 'consumable_2', quantity: 5),
      ],
      maxCapacity: GameConstants.inventoryCapacity,
      credits: GameConstants.startingCredits,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final inventories = await getAllInventories();
    inventories.add(inventory);
    await _storage.save(_storageKey, inventories.map((i) => i.toJson()).toList());
  }

  Future<void> updateInventory(InventoryModel inventory) async {
    final inventories = await getAllInventories();
    final index = inventories.indexWhere((i) => i.id == inventory.id);
    if (index != -1) {
      inventories[index] = inventory;
      await _storage.save(_storageKey, inventories.map((i) => i.toJson()).toList());
    }
  }

  Future<void> addItem(String characterId, String itemId, int quantity) async {
    final inventory = await getInventoryByCharacterId(characterId);
    if (inventory == null) return;

    final items = List<InventoryItem>.from(inventory.items);
    final existingIndex = items.indexWhere((i) => i.itemId == itemId);

    if (existingIndex != -1) {
      items[existingIndex] = InventoryItem(
        itemId: itemId,
        quantity: items[existingIndex].quantity + quantity,
        isEquipped: items[existingIndex].isEquipped,
      );
    } else {
      items.add(InventoryItem(itemId: itemId, quantity: quantity));
    }

    await updateInventory(inventory.copyWith(items: items, updatedAt: DateTime.now()));
  }

  Future<void> removeItem(String characterId, String itemId, int quantity) async {
    final inventory = await getInventoryByCharacterId(characterId);
    if (inventory == null) return;

    final items = List<InventoryItem>.from(inventory.items);
    final existingIndex = items.indexWhere((i) => i.itemId == itemId);

    if (existingIndex != -1) {
      final newQuantity = items[existingIndex].quantity - quantity;
      if (newQuantity <= 0) {
        items.removeAt(existingIndex);
      } else {
        items[existingIndex] = InventoryItem(
          itemId: itemId,
          quantity: newQuantity,
          isEquipped: items[existingIndex].isEquipped,
        );
      }
      await updateInventory(inventory.copyWith(items: items, updatedAt: DateTime.now()));
    }
  }

  Future<void> equipItem(String characterId, String itemId) async {
    final inventory = await getInventoryByCharacterId(characterId);
    if (inventory == null) return;

    final items = List<InventoryItem>.from(inventory.items);
    final index = items.indexWhere((i) => i.itemId == itemId);

    if (index != -1) {
      items[index] = InventoryItem(
        itemId: itemId,
        quantity: items[index].quantity,
        isEquipped: true,
      );
      await updateInventory(inventory.copyWith(items: items, updatedAt: DateTime.now()));
    }
  }
}
