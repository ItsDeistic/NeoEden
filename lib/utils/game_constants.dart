class GameConstants {
  static const List<String> professions = [
    'Soldier', 'Engineer', 'Agent', 'Doctor', 'Meta-Physicist',
    'Bureaucrat', 'Trader', 'Enforcer', 'Fixer', 'Adventurer',
    'Martial Artist', 'Shade'
  ];

  static const List<String> breeds = ['Solitus', 'Opifex', 'Nanomage', 'Atrox'];
  
  static const List<String> genders = ['Male', 'Female'];

  static const List<String> attributes = [
    'Strength', 'Agility', 'Stamina', 'Intelligence', 'Sense', 'Psychic'
  ];

  static const List<String> itemTypes = [
    'Weapon', 'Armor', 'Implant', 'Consumable', 'Quest Item', 'Material'
  ];

  static const List<String> rarities = [
    'Common', 'Uncommon', 'Rare', 'Epic', 'Legendary'
  ];

  static const List<String> skillCategories = [
    'Combat', 'Defensive', 'Crafting', 'Social', 'Movement'
  ];

  static const List<String> zones = [
    'Omni-1 Entertainment', 'Old Athen', 'Newland Desert',
    'Perpetual Wastelands', 'Shadowlands', 'Temple of Three Winds'
  ];

  static const int maxLevel = 220;
  static const int inventoryCapacity = 100;
  static const int hotbarSlots = 10;
  static const int startingCredits = 1000;

  static Map<String, int> getBaseAttributes(String breed) {
    switch (breed) {
      case 'Solitus':
        return {'Strength': 10, 'Agility': 10, 'Stamina': 10, 'Intelligence': 10, 'Sense': 10, 'Psychic': 10};
      case 'Opifex':
        return {'Strength': 8, 'Agility': 15, 'Stamina': 8, 'Intelligence': 12, 'Sense': 12, 'Psychic': 8};
      case 'Nanomage':
        return {'Strength': 7, 'Agility': 10, 'Stamina': 7, 'Intelligence': 15, 'Sense': 12, 'Psychic': 14};
      case 'Atrox':
        return {'Strength': 15, 'Agility': 8, 'Stamina': 14, 'Intelligence': 8, 'Sense': 10, 'Psychic': 8};
      default:
        return {'Strength': 10, 'Agility': 10, 'Stamina': 10, 'Intelligence': 10, 'Sense': 10, 'Psychic': 10};
    }
  }

  static int calculateMaxHealth(int stamina, int level) => 100 + (stamina * 5) + (level * 10);

  static int calculateMaxNano(int intelligence, int psychic, int level) => 
      50 + (intelligence * 3) + (psychic * 4) + (level * 5);

  static int experienceForLevel(int level) => (level * level * 100);
}
