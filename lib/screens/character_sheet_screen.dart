import 'package:flutter/material.dart';
import 'package:neoeden/services/game_state_service.dart';
import 'package:neoeden/theme.dart';

class CharacterSheetScreen extends StatelessWidget {
  const CharacterSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = GameStateService().currentCharacter;
    if (character == null) {
      return Scaffold(
        appBar: AppBar(title: Text('CHARACTER', style: Theme.of(context).textTheme.titleLarge)),
        body: Center(child: Text('No character loaded', style: Theme.of(context).textTheme.bodyLarge)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('CHARACTER', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: GameColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCharacterHeader(context, character),
            const SizedBox(height: 24),
            _buildStatsSection(context, character),
            const SizedBox(height: 24),
            _buildAttributesSection(context, character),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterHeader(BuildContext context, dynamic character) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [GameColors.electricPurple.withValues(alpha: 0.3), GameColors.neonCyan.withValues(alpha: 0.3)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GameColors.neonCyan, width: 2),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: GameColors.electricPurple,
              shape: BoxShape.circle,
              border: Border.all(color: GameColors.neonCyan, width: 3),
            ),
            child: Icon(Icons.person, size: 50, color: GameColors.pureWhite),
          ),
          const SizedBox(height: 16),
          Text(character.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('${character.profession} • ${character.breed}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text('Level ${character.level}', style: TextStyle(color: GameColors.acidGreen, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, dynamic character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('STATS', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        _buildStatRow('Health', '${character.health} / ${character.maxHealth}', GameColors.healthGreen),
        const SizedBox(height: 8),
        _buildStatRow('Nano Energy', '${character.nanoEnergy} / ${character.maxNanoEnergy}', GameColors.nanoBlue),
        const SizedBox(height: 8),
        _buildStatRow('Experience', '${character.experience}', GameColors.electricPurple),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GameColors.slateGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: GameColors.pureWhite, fontSize: 16)),
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAttributesSection(BuildContext context, dynamic character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ATTRIBUTES', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GameColors.slateGray,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GameColors.neonCyan, width: 2),
          ),
          child: Column(
            children: character.attributes.entries.map<Widget>((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: TextStyle(color: GameColors.lightGray, fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: GameColors.neonCyan.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${entry.value}', style: TextStyle(color: GameColors.neonCyan, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
