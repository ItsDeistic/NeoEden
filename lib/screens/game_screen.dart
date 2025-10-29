import 'package:flutter/material.dart';
import 'package:neoeden/services/game_state_service.dart';
import 'package:neoeden/theme.dart';
import 'package:neoeden/widgets/game_hud.dart';
import 'package:neoeden/widgets/isometric_viewport.dart';
import 'package:neoeden/widgets/virtual_joystick.dart';
import 'package:neoeden/screens/inventory_screen.dart';
import 'package:neoeden/screens/character_sheet_screen.dart';
import 'package:neoeden/screens/quest_log_screen.dart';
import 'package:neoeden/screens/zone_travel_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GlobalKey<IsometricViewportState> _viewportKey = GlobalKey<IsometricViewportState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IsometricViewport(key: _viewportKey),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GameHUD(
                onMapTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ZoneTravelScreen())),
                onInventoryTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InventoryScreen())),
                onCharacterTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CharacterSheetScreen())),
                onQuestTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuestLogScreen())),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: VirtualJoystick(
                onDirectionChanged: (x, y) {
                  _viewportKey.currentState?.handleJoystickChanged(x, y);
                },
              ),
            ),
            Positioned(
              bottom: 16,
              left: 152,
              right: 16,
              child: _buildHotbar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotbar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GameColors.darkSteel.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GameColors.neonCyan, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          10,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: GameColors.slateGray,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: GameColors.neonCyan.withValues(alpha: 0.3), width: 1),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: GameColors.lightGray, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
