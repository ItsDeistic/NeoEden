# NeoEden - 2D Isometric MMORPG Architecture

## Overview
A 2D isometric MMORPG inspired by Anarchy Online, featuring all core systems including character creation, combat, inventory, skills, quests, and an expansive isometric world map. All visuals use sprite-based graphics with a sleek, modern UI.

## Core Systems

### 1. Character System
- **Professions**: Soldier, Engineer, Agent, Doctor, Meta-Physicist, Bureaucrat, Trader, Enforcer, Fixer, Adventurer, Martial Artist, Shade
- **Breeds**: Solitus, Opifex, Nanomage, Atrox
- **Gender**: Male, Female
- **Attributes**: Strength, Agility, Stamina, Intelligence, Sense, Psychic
- **Stats**: Health, Nano Energy, Level, Experience
- **Appearance Customization**: Hair style, face, body type

### 2. Skills System
- Combat Skills: Melee, Ranged, Nano
- Defensive Skills: Dodge, Parry, Evade
- Crafting Skills: Mechanical Engineering, Electrical Engineering, Pharmaceutical
- Social Skills: Trading, Leadership
- Movement Skills: Run Speed, Swim Speed
- Skill Points allocation on level up

### 3. Inventory & Equipment System
- Equipment Slots: Head, Chest, Legs, Boots, Gloves, Weapon (Right/Left Hand), Implants (Head, Eye, Ear, Chest, Waist, Arms, Legs, Feet, Hands)
- Inventory Grid (10x10)
- Item Types: Weapons, Armor, Implants, Consumables, Quest Items, Materials
- Item Rarity: Common, Uncommon, Rare, Epic, Legendary
- Weight/Capacity System

### 4. Combat System
- Target Selection
- Auto-attack and Special Abilities
- Damage Types: Physical, Energy, Chemical, Poison, Radiation
- Defensive Ratings: Armor Class, Nano Resistance
- Combat Log
- Health/Nano Bar Display
- Cooldown System

### 5. Quest System
- Quest Types: Main Story, Side Quests, Daily Quests, Faction Quests
- Quest Log with tracking
- Quest Objectives: Kill, Collect, Talk, Explore
- Rewards: Experience, Credits, Items
- Quest Markers on Map

### 6. Map & Navigation
- Isometric Grid-Based World
- Multiple Zones: Omni Entertainment, Clan Territory, Neutral Zones, Shadowlands, Dungeons
- Mini-map with player position
- World Map with zone selection
- Fast Travel System (Grid Network)
- NPC Locations
- Resource Nodes
- Points of Interest

### 7. Social Systems
- Chat System: Local, Team, Clan, Global
- Friend List
- Team Formation (6 players max)
- Clan System
- Player Trading

### 8. Economy System
- Credits (Currency)
- Vendor System (Buy/Sell)
- Player Trading
- Auction House
- Crafting Materials

### 9. Progression System
- Experience Points & Leveling (Max Level 220)
- Skill Points Distribution
- Title System
- Achievement System

## UI/UX Design

### Color Palette (Cyberpunk Sci-Fi Theme)
- Primary: Cyan Blue (#00D9FF) - Neon tech accent
- Secondary: Electric Purple (#B026FF) - Energy effects
- Tertiary: Acid Green (#39FF14) - Success/Health indicators
- Background Dark: Deep Space (#0A0E1A)
- Background Mid: Dark Steel (#1A1F2E)
- Surface: Slate Gray (#2A3142)
- Text Primary: Pure White (#FFFFFF)
- Text Secondary: Light Gray (#B8C5D6)
- Warning: Neon Orange (#FF6B35)
- Error: Hot Pink (#FF006E)
- Success: Lime Green (#39FF14)

### Layout Structure
- Game HUD: Health/Nano bars, Mini-map, Hotbar (10 slots), Character portrait, Target frame
- Main Viewport: Isometric game world with sprite rendering
- Menus: Slide-in panels with transparency effects
- Chat Box: Bottom-left overlay
- Action Bar: Bottom center with ability icons

### Fonts
- Primary: Orbitron (Sci-fi futuristic)
- Secondary: Rajdhani (Clean tech)
- Body: Inter (Readable UI text)

## Technical Architecture

### Data Models (lib/models/)
1. `user_model.dart` - Player account data
2. `character_model.dart` - Character stats, profession, breed
3. `inventory_model.dart` - Inventory items and equipment
4. `item_model.dart` - Item properties and stats
5. `skill_model.dart` - Skill definitions and levels
6. `quest_model.dart` - Quest data and progress
7. `map_tile_model.dart` - World tile data
8. `npc_model.dart` - NPC data and dialogue
9. `enemy_model.dart` - Enemy stats and drops
10. `ability_model.dart` - Character abilities and spells

### Services (lib/services/)
1. `character_service.dart` - Character CRUD, stats calculation
2. `inventory_service.dart` - Inventory management, equipment
3. `combat_service.dart` - Combat mechanics, damage calculation
4. `skill_service.dart` - Skill progression, requirements
5. `quest_service.dart` - Quest tracking, completion
6. `map_service.dart` - World data, navigation
7. `game_state_service.dart` - Overall game state management
8. `storage_service.dart` - Local storage wrapper

### Screens (lib/screens/)
1. `splash_screen.dart` - Initial loading
2. `character_creation_screen.dart` - Create new character
3. `character_selection_screen.dart` - Choose character
4. `game_screen.dart` - Main game viewport
5. `inventory_screen.dart` - Inventory/Equipment UI
6. `character_sheet_screen.dart` - Stats and skills
7. `quest_log_screen.dart` - Active and completed quests
8. `map_screen.dart` - World map navigation
9. `settings_screen.dart` - Game settings

### Widgets (lib/widgets/)
1. `isometric_tile.dart` - Single isometric tile renderer
2. `character_sprite.dart` - Animated character sprite
3. `health_bar.dart` - Health/Nano bar widget
4. `hotbar.dart` - Action bar with abilities
5. `mini_map.dart` - Mini-map display
6. `chat_widget.dart` - Chat interface
7. `inventory_grid.dart` - Grid-based inventory
8. `item_slot.dart` - Individual item slot
9. `ability_button.dart` - Hotbar ability button
10. `stat_display.dart` - Character stat display
11. `quest_tracker.dart` - Active quest display
12. `dialogue_box.dart` - NPC dialogue interface

### Utilities (lib/utils/)
1. `isometric_helper.dart` - Coordinate conversion helpers
2. `damage_calculator.dart` - Combat math
3. `sprite_loader.dart` - Sprite asset management
4. `game_constants.dart` - Game constants and configs

## Implementation Plan

### Phase 1: Foundation
1. Update theme with cyberpunk sci-fi color palette
2. Create all data models with sample data
3. Implement storage service for local persistence
4. Create character creation flow (breed, profession, appearance)
5. Build character selection screen

### Phase 2: Core Systems
1. Implement game state service
2. Create inventory and equipment system
3. Build skill system with requirements
4. Implement character stats calculation
5. Create quest system with tracking

### Phase 3: World & Rendering
1. Build isometric tile rendering system
2. Create map service with world data
3. Implement character sprite with animations
4. Build mini-map component
5. Create main game screen with viewport

### Phase 4: Combat & Interaction
1. Implement combat service
2. Create ability system with cooldowns
3. Build target selection
4. Implement NPC interaction
5. Create enemy AI and spawning

### Phase 5: UI/HUD
1. Build game HUD (health bars, hotbar)
2. Create inventory screen
3. Build character sheet screen
4. Implement quest log UI
5. Create world map screen

### Phase 6: Polish & Features
1. Add chat system
2. Implement vendor system
3. Create achievement tracking
4. Add sound effects (placeholder)
5. Polish animations and transitions
6. Compile and debug

## Sample Data
- 3-5 sample characters (different professions/breeds)
- 50+ items (weapons, armor, consumables)
- 20+ skills across categories
- 10+ quests (mix of types)
- Multiple map zones with tiles
- 20+ NPCs with dialogue
- 15+ enemy types
- 30+ abilities across professions

## Dependencies
- `shared_preferences` - Local storage
- `google_fonts` - Already included
- All rendering using Flutter's Canvas/CustomPaint for sprites
