import 'package:neoeden/models/ability_model.dart';
import 'package:neoeden/services/storage_service.dart';

class AbilityService {
  static final AbilityService _instance = AbilityService._internal();
  factory AbilityService() => _instance;
  AbilityService._internal();

  final StorageService _storage = StorageService();
  static const String _storageKey = 'abilities';

  Future<List<AbilityModel>> getAllAbilities() async {
    final data = await _storage.load(_storageKey);
    if (data == null) {
      await _initializeAbilities();
      return getAllAbilities();
    }
    
    try {
      return (data as List).map((json) => AbilityModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      await _initializeAbilities();
      return getAllAbilities();
    }
  }

  Future<List<AbilityModel>> getAbilitiesForProfession(String profession) async {
    final abilities = await getAllAbilities();
    return abilities.where((a) => a.allowedProfessions.contains(profession) || a.allowedProfessions.contains('All')).toList();
  }

  Future<void> _initializeAbilities() async {
    final abilities = [
      AbilityModel(id: 'ability_1', name: 'Aimed Shot', description: 'Precise ranged attack', type: 'Attack', nanoCost: 10, cooldown: 3, damage: 40, damageType: 'Physical', range: 30, allowedProfessions: ['Soldier', 'Agent', 'Fixer'], requiredLevel: 1, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      AbilityModel(id: 'ability_2', name: 'Nano Heal', description: 'Restore health using nano energy', type: 'Healing', nanoCost: 30, cooldown: 8, damage: -50, damageType: 'Healing', range: 20, allowedProfessions: ['Doctor', 'Meta-Physicist'], requiredLevel: 1, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      AbilityModel(id: 'ability_3', name: 'Shield Boost', description: 'Temporary defense increase', type: 'Defense', nanoCost: 20, cooldown: 10, damage: 0, damageType: 'Buff', range: 0, allowedProfessions: ['Enforcer', 'Soldier'], requiredLevel: 3, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      AbilityModel(id: 'ability_4', name: 'Energy Blast', description: 'Powerful energy attack', type: 'Attack', nanoCost: 40, cooldown: 6, damage: 80, damageType: 'Energy', range: 25, allowedProfessions: ['Engineer', 'Meta-Physicist'], requiredLevel: 5, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      AbilityModel(id: 'ability_5', name: 'Quick Escape', description: 'Rapid movement burst', type: 'Movement', nanoCost: 25, cooldown: 15, damage: 0, damageType: 'Utility', range: 0, allowedProfessions: ['Fixer', 'Agent', 'Shade'], requiredLevel: 5, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      AbilityModel(id: 'ability_6', name: 'Martial Strike', description: 'Devastating melee combo', type: 'Attack', nanoCost: 15, cooldown: 4, damage: 65, damageType: 'Physical', range: 5, allowedProfessions: ['Martial Artist', 'Enforcer'], requiredLevel: 7, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      AbilityModel(id: 'ability_7', name: 'Bargain', description: 'Reduce vendor prices temporarily', type: 'Utility', nanoCost: 10, cooldown: 60, damage: 0, damageType: 'Buff', range: 0, allowedProfessions: ['Trader', 'Bureaucrat'], requiredLevel: 3, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      AbilityModel(id: 'ability_8', name: 'Critical Strike', description: 'High damage critical hit', type: 'Attack', nanoCost: 35, cooldown: 8, damage: 120, damageType: 'Physical', range: 15, allowedProfessions: ['Shade', 'Adventurer'], requiredLevel: 10, createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ];
    await _storage.save(_storageKey, abilities.map((a) => a.toJson()).toList());
  }
}
