import 'package:flutter/material.dart';
import 'package:neoeden/models/character_model.dart';
import 'package:neoeden/services/character_service.dart';
import 'package:neoeden/services/game_state_service.dart';
import 'package:neoeden/theme.dart';
import 'package:neoeden/screens/character_creation_screen.dart';
import 'package:neoeden/screens/game_screen.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  List<CharacterModel> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    final chars = await CharacterService().getAllCharacters();
    setState(() {
      _characters = chars;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
          ? Center(child: CircularProgressIndicator(color: GameColors.neonCyan))
          : _characters.isEmpty
            ? _buildEmptyState()
            : _buildCharacterList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 80, color: GameColors.neonCyan),
            const SizedBox(height: 24),
            Text('No Characters', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text('Create your first character to begin', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CharacterCreationScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: GameColors.electricPurple, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
              child: Text('CREATE CHARACTER', style: TextStyle(color: GameColors.pureWhite, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SELECT CHARACTER', style: Theme.of(context).textTheme.headlineMedium),
              IconButton(
                icon: Icon(Icons.add_circle, color: GameColors.electricPurple, size: 32),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CharacterCreationScreen())),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _characters.length,
            itemBuilder: (context, index) => _buildCharacterCard(_characters[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterCard(CharacterModel character) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _selectCharacter(character),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GameColors.slateGray,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GameColors.darkSteel, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: GameColors.neonCyan,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person, size: 40, color: GameColors.deepSpace),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(character.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text('${character.profession} • ${character.breed}', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text('Level ${character.level}', style: TextStyle(color: GameColors.acidGreen, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: GameColors.neonCyan),
            ],
          ),
        ),
      ),
    );
  }

  void _selectCharacter(CharacterModel character) {
    GameStateService().setCurrentCharacter(character);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const GameScreen()));
  }
}
