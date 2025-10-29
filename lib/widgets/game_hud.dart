import 'package:flutter/material.dart';
import 'package:neoeden/services/game_state_service.dart';
import 'package:neoeden/theme.dart';

class GameHUD extends StatelessWidget {
  final VoidCallback onInventoryTap;
  final VoidCallback onCharacterTap;
  final VoidCallback onQuestTap;
  final VoidCallback onMapTap;

  const GameHUD({
    super.key,
    required this.onInventoryTap,
    required this.onCharacterTap,
    required this.onQuestTap,
    required this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GameStateService(),
      builder: (context, _) {
        final character = GameStateService().currentCharacter;
        if (character == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GameColors.darkSteel.withValues(alpha: 0.95), GameColors.darkSteel.withValues(alpha: 0.0)],
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildCharacterInfo(character.name, character.level)),
                  _buildMenuButton(Icons.map, onMapTap),
                  const SizedBox(width: 8),
                  _buildMenuButton(Icons.inventory_2, onInventoryTap),
                  const SizedBox(width: 8),
                  _buildMenuButton(Icons.person, onCharacterTap),
                  const SizedBox(width: 8),
                  _buildMenuButton(Icons.assignment, onQuestTap),
                ],
              ),
              const SizedBox(height: 12),
              _buildHealthBar(character.health, character.maxHealth),
              const SizedBox(height: 8),
              _buildNanoBar(character.nanoEnergy, character.maxNanoEnergy),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCharacterInfo(String name, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(color: GameColors.pureWhite, fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Level $level', style: TextStyle(color: GameColors.neonCyan, fontSize: 14)),
      ],
    );
  }

  Widget _buildMenuButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: GameColors.slateGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GameColors.neonCyan, width: 2),
        ),
        child: Icon(icon, color: GameColors.neonCyan, size: 24),
      ),
    );
  }

  Widget _buildHealthBar(int current, int max) {
    final percentage = current / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('HP', style: TextStyle(color: GameColors.healthGreen, fontSize: 12, fontWeight: FontWeight.bold)),
            Text('$current / $max', style: TextStyle(color: GameColors.pureWhite, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: GameColors.slateGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: GameColors.healthGreen,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNanoBar(int current, int max) {
    final percentage = current / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('NANO', style: TextStyle(color: GameColors.nanoBlue, fontSize: 12, fontWeight: FontWeight.bold)),
            Text('$current / $max', style: TextStyle(color: GameColors.pureWhite, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: GameColors.slateGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: GameColors.nanoBlue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
