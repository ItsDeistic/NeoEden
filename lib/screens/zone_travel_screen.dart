import 'package:flutter/material.dart';
import 'package:neoeden/services/map_service.dart';
import 'package:neoeden/services/game_state_service.dart';
import 'package:neoeden/theme.dart';

class ZoneTravelScreen extends StatelessWidget {
  const ZoneTravelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapService = MapService();
    final zones = mapService.allZones;
    final currentCharacter = GameStateService().currentCharacter;

    return Scaffold(
      appBar: AppBar(
        title: Text('Zone Travel', style: TextStyle(color: GameColors.neonCyan, fontWeight: FontWeight.bold)),
        backgroundColor: GameColors.darkSteel,
        iconTheme: IconThemeData(color: GameColors.neonCyan),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [GameColors.deepSpace, GameColors.darkSteel],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: zones.length,
          itemBuilder: (context, index) {
            final zone = zones[index];
            final isCurrentZone = currentCharacter?.currentZone == zone.name;
            final canAccess = currentCharacter != null && currentCharacter.level >= zone.recommendedLevel;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isCurrentZone ? GameColors.neonCyan.withValues(alpha: 0.2) : GameColors.slateGray.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCurrentZone ? GameColors.neonCyan : GameColors.darkSteel,
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: canAccess || isCurrentZone ? () {
                    if (!isCurrentZone) {
                      GameStateService().setCurrentZone(zone.name);
                      
                      final spawnPoint = zone.spawnPoints.isNotEmpty 
                          ? zone.spawnPoints.first 
                          : null;
                      
                      if (spawnPoint != null) {
                        GameStateService().updateCharacterPosition(spawnPoint.x, spawnPoint.y);
                      } else {
                        GameStateService().updateCharacterPosition(
                          zone.width / 2, 
                          zone.height / 2,
                        );
                      }

                      Navigator.of(context).pop();
                    }
                  } : null,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                zone.name,
                                style: TextStyle(
                                  color: isCurrentZone ? GameColors.neonCyan : GameColors.lightGray,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isCurrentZone)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: GameColors.neonCyan,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'CURRENT',
                                  style: TextStyle(
                                    color: GameColors.darkSteel,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (!canAccess && !isCurrentZone)
                              Icon(Icons.lock, color: GameColors.warningRed, size: 24),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          zone.description,
                          style: TextStyle(color: GameColors.lightGray, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildInfoChip(
                              icon: Icons.trending_up,
                              label: 'Level ${zone.recommendedLevel}+',
                              color: canAccess ? GameColors.successGreen : GameColors.warningRed,
                            ),
                            const SizedBox(width: 12),
                            _buildInfoChip(
                              icon: Icons.flag,
                              label: zone.faction,
                              color: _getFactionColor(zone.faction),
                            ),
                            const SizedBox(width: 12),
                            _buildInfoChip(
                              icon: Icons.map,
                              label: '${zone.width}x${zone.height}',
                              color: GameColors.electricPurple,
                            ),
                          ],
                        ),
                        if (zone.npcs.isNotEmpty || zone.enemies.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (zone.npcs.isNotEmpty)
                                Text(
                                  '${zone.npcs.length} NPCs',
                                  style: TextStyle(color: Color(0xFF00FF88), fontSize: 12),
                                ),
                              if (zone.npcs.isNotEmpty && zone.enemies.isNotEmpty)
                                Text(' • ', style: TextStyle(color: GameColors.lightGray, fontSize: 12)),
                              if (zone.enemies.isNotEmpty)
                                Text(
                                  '${zone.enemies.length} Enemies',
                                  style: TextStyle(color: Color(0xFFFF4A4A), fontSize: 12),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getFactionColor(String faction) {
    switch (faction) {
      case 'Omni-Tek': return Color(0xFF4A9EFF);
      case 'Clan': return Color(0xFFFF6B4A);
      case 'Neutral': return Color(0xFFFFD700);
      case 'Hostile': return GameColors.warningRed;
      case 'Alien': return Color(0xFFAA77DD);
      case 'Ancient': return Color(0xFFD4A574);
      default: return GameColors.lightGray;
    }
  }
}
