import 'package:neoeden/models/quest_model.dart';
import 'package:neoeden/services/storage_service.dart';

class QuestService {
  static final QuestService _instance = QuestService._internal();
  factory QuestService() => _instance;
  QuestService._internal();

  final StorageService _storage = StorageService();
  static const String _storageKey = 'quests';

  Future<List<QuestModel>> getAllQuests() async {
    final data = await _storage.load(_storageKey);
    if (data == null) {
      await _initializeQuests();
      return getAllQuests();
    }
    
    try {
      return (data as List).map((json) => QuestModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      await _initializeQuests();
      return getAllQuests();
    }
  }

  Future<List<QuestModel>> getActiveQuests() async {
    final quests = await getAllQuests();
    return quests.where((q) => q.status == 'active').toList();
  }

  Future<void> updateQuest(QuestModel quest) async {
    final quests = await getAllQuests();
    final index = quests.indexWhere((q) => q.id == quest.id);
    if (index != -1) {
      quests[index] = quest;
      await _storage.save(_storageKey, quests.map((q) => q.toJson()).toList());
    }
  }

  Future<void> _initializeQuests() async {
    final quests = [
      QuestModel(
        id: 'quest_1',
        title: 'Welcome to Rubi-Ka',
        description: 'Speak to the Omni-Tek representative and learn about the world.',
        type: 'Main Story',
        status: 'available',
        level: 1,
        objectives: {'talkToNPC': 'npc_1', 'completed': false},
        rewards: {'experience': 100, 'credits': 50},
        questGiverId: 'npc_1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      QuestModel(
        id: 'quest_2',
        title: 'First Combat',
        description: 'Defeat 5 security drones to test your combat skills.',
        type: 'Combat',
        status: 'available',
        level: 1,
        objectives: {'killEnemies': 5, 'current': 0, 'completed': false},
        rewards: {'experience': 200, 'credits': 100, 'itemId': 'weapon_2'},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      QuestModel(
        id: 'quest_3',
        title: 'Resource Gathering',
        description: 'Collect 10 nano crystals from the wasteland.',
        type: 'Collection',
        status: 'available',
        level: 3,
        objectives: {'collectItems': 10, 'current': 0, 'completed': false},
        rewards: {'experience': 300, 'credits': 150},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      QuestModel(
        id: 'quest_4',
        title: 'Faction Choice',
        description: 'Choose your allegiance: Omni-Tek, Clan, or remain Neutral.',
        type: 'Main Story',
        status: 'available',
        level: 5,
        objectives: {'makeChoice': true, 'completed': false},
        rewards: {'experience': 500, 'credits': 250},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      QuestModel(
        id: 'quest_5',
        title: 'Explore the Shadowlands',
        description: 'Venture into the mysterious Shadowlands zone.',
        type: 'Exploration',
        status: 'available',
        level: 10,
        objectives: {'exploreZone': 'Shadowlands', 'completed': false},
        rewards: {'experience': 800, 'credits': 400, 'itemId': 'armor_3'},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    await _storage.save(_storageKey, quests.map((q) => q.toJson()).toList());
  }
}
