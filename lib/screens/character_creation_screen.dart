import 'package:flutter/material.dart';
import 'package:neoeden/models/character_model.dart';
import 'package:neoeden/services/character_service.dart';
import 'package:neoeden/services/inventory_service.dart';
import 'package:neoeden/theme.dart';
import 'package:neoeden/utils/game_constants.dart';
import 'package:neoeden/screens/character_selection_screen.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _nameController = TextEditingController();
  String? _selectedProfession;
  String? _selectedBreed;
  String? _selectedGender;
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CREATE CHARACTER', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),
              Text('Begin your journey on Rubi-Ka', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              _buildNameField(),
              const SizedBox(height: 24),
              _buildBreedSection(),
              const SizedBox(height: 24),
              _buildProfessionSection(),
              const SizedBox(height: 24),
              _buildGenderSection(),
              const SizedBox(height: 32),
              if (_selectedBreed != null) _buildAttributeDisplay(),
              const SizedBox(height: 32),
              _buildCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Character Name', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: TextStyle(color: GameColors.pureWhite),
          decoration: InputDecoration(
            hintText: 'Enter character name',
            hintStyle: TextStyle(color: GameColors.lightGray),
            filled: true,
            fillColor: GameColors.slateGray,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildBreedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Breed', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: GameConstants.breeds.map((breed) => _buildChoiceChip(breed, _selectedBreed, (value) => setState(() => _selectedBreed = value))).toList(),
        ),
      ],
    );
  }

  Widget _buildProfessionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profession', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: GameConstants.professions.map((prof) => _buildChoiceChip(prof, _selectedProfession, (value) => setState(() => _selectedProfession = value))).toList(),
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: GameConstants.genders.map((gender) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildChoiceChip(gender, _selectedGender, (value) => setState(() => _selectedGender = value)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label, String? selected, ValueChanged<String> onSelected) {
    final isSelected = selected == label;
    return InkWell(
      onTap: () => onSelected(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? GameColors.neonCyan : GameColors.slateGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? GameColors.neonCyan : GameColors.darkSteel, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? GameColors.deepSpace : GameColors.pureWhite, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildAttributeDisplay() {
    final attrs = GameConstants.getBaseAttributes(_selectedBreed!);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: GameColors.slateGray, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Base Attributes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ...attrs.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: Theme.of(context).textTheme.bodyMedium),
                Text('${e.value}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: GameColors.neonCyan)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    final canCreate = _nameController.text.isNotEmpty && _selectedBreed != null && _selectedProfession != null && _selectedGender != null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canCreate && !_isCreating ? _createCharacter : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: GameColors.electricPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isCreating
          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: GameColors.pureWhite, strokeWidth: 2))
          : Text('CREATE CHARACTER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: GameColors.pureWhite)),
      ),
    );
  }

  Future<void> _createCharacter() async {
    setState(() => _isCreating = true);
    
    final character = CharacterService().createNewCharacter(
      userId: 'user_1',
      name: _nameController.text.trim(),
      profession: _selectedProfession!,
      breed: _selectedBreed!,
      gender: _selectedGender!,
    );

    await CharacterService().createCharacter(character);
    await InventoryService().createInventory(character.id);

    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const CharacterSelectionScreen()));
    }
  }
}
