import 'package:flutter/foundation.dart';
import 'package:neoeden/models/character_model.dart';

class GameStateService extends ChangeNotifier {
  static final GameStateService _instance = GameStateService._internal();
  factory GameStateService() => _instance;
  GameStateService._internal();

  CharacterModel? _currentCharacter;
  String? _currentZone;
  bool _isInCombat = false;
  String? _targetEnemyId;

  CharacterModel? get currentCharacter => _currentCharacter;
  String? get currentZone => _currentZone;
  bool get isInCombat => _isInCombat;
  String? get targetEnemyId => _targetEnemyId;

  void setCurrentCharacter(CharacterModel? character) {
    _currentCharacter = character;
    _currentZone = character?.currentZone;
    notifyListeners();
  }

  void setCurrentZone(String zone) {
    _currentZone = zone;
    notifyListeners();
  }

  void enterCombat(String enemyId) {
    _isInCombat = true;
    _targetEnemyId = enemyId;
    notifyListeners();
  }

  void exitCombat() {
    _isInCombat = false;
    _targetEnemyId = null;
    notifyListeners();
  }

  void updateCharacterPosition(double x, double y) {
    if (_currentCharacter != null) {
      _currentCharacter = _currentCharacter!.copyWith(
        positionX: x,
        positionY: y,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void updateCharacterHealth(int newHealth) {
    if (_currentCharacter != null) {
      _currentCharacter = _currentCharacter!.copyWith(
        health: newHealth.clamp(0, _currentCharacter!.maxHealth),
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void updateCharacterNano(int newNano) {
    if (_currentCharacter != null) {
      _currentCharacter = _currentCharacter!.copyWith(
        nanoEnergy: newNano.clamp(0, _currentCharacter!.maxNanoEnergy),
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
