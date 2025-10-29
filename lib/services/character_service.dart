import 'dart:convert';
import 'package:neoeden/models/character_model.dart';
import 'package:neoeden/services/storage_service.dart';
import 'package:neoeden/utils/game_constants.dart';

class CharacterService {
  static final CharacterService _instance = CharacterService._internal();
  factory CharacterService() => _instance;
  CharacterService._internal();

  final StorageService _storage = StorageService();
  static const String _storageKey = 'characters';

  Future<List<CharacterModel>> getAllCharacters() async {
    final data = await _storage.load(_storageKey);
    if (data == null) return [];
    
    try {
      return (data as List).map((json) => CharacterModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      await _storage.save(_storageKey, []);
      return [];
    }
  }

  Future<CharacterModel?> getCharacterById(String id) async {
    final characters = await getAllCharacters();
    try {
      return characters.firstWhere((char) => char.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createCharacter(CharacterModel character) async {
    final characters = await getAllCharacters();
    characters.add(character);
    await _storage.save(_storageKey, characters.map((c) => c.toJson()).toList());
  }

  Future<void> updateCharacter(CharacterModel character) async {
    final characters = await getAllCharacters();
    final index = characters.indexWhere((c) => c.id == character.id);
    if (index != -1) {
      characters[index] = character;
      await _storage.save(_storageKey, characters.map((c) => c.toJson()).toList());
    }
  }

  Future<void> deleteCharacter(String id) async {
    final characters = await getAllCharacters();
    characters.removeWhere((c) => c.id == id);
    await _storage.save(_storageKey, characters.map((c) => c.toJson()).toList());
  }

  CharacterModel createNewCharacter({
    required String userId,
    required String name,
    required String profession,
    required String breed,
    required String gender,
  }) {
    final baseAttributes = GameConstants.getBaseAttributes(breed);
    final maxHealth = GameConstants.calculateMaxHealth(baseAttributes['Stamina']!, 1);
    final maxNano = GameConstants.calculateMaxNano(baseAttributes['Intelligence']!, baseAttributes['Psychic']!, 1);

    return CharacterModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: name,
      profession: profession,
      breed: breed,
      gender: gender,
      level: 1,
      experience: 0,
      health: maxHealth,
      maxHealth: maxHealth,
      nanoEnergy: maxNano,
      maxNanoEnergy: maxNano,
      attributes: baseAttributes,
      equippedItems: [],
      currentZone: 'Omni-1 Entertainment',
      positionX: 10.0,
      positionY: 10.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  void gainExperience(CharacterModel character, int exp) {
    int newExp = character.experience + exp;
    int newLevel = character.level;
    
    while (newExp >= GameConstants.experienceForLevel(newLevel)) {
      newExp -= GameConstants.experienceForLevel(newLevel);
      newLevel++;
    }
    
    if (newLevel > character.level) {
      final newMaxHealth = GameConstants.calculateMaxHealth(character.attributes['Stamina']!, newLevel);
      final newMaxNano = GameConstants.calculateMaxNano(
        character.attributes['Intelligence']!,
        character.attributes['Psychic']!,
        newLevel
      );
      
      updateCharacter(character.copyWith(
        level: newLevel,
        experience: newExp,
        maxHealth: newMaxHealth,
        maxNanoEnergy: newMaxNano,
        health: newMaxHealth,
        nanoEnergy: newMaxNano,
        updatedAt: DateTime.now(),
      ));
    } else {
      updateCharacter(character.copyWith(
        experience: newExp,
        updatedAt: DateTime.now(),
      ));
    }
  }
}
