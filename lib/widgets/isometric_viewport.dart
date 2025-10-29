import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neoeden/services/game_state_service.dart';
import 'package:neoeden/services/map_service.dart';
import 'package:neoeden/models/map_zone_model.dart';
import 'package:neoeden/theme.dart';
import 'dart:math' as math;

class IsometricViewport extends StatefulWidget {
  final Function(double x, double y)? onJoystickChanged;
  
  const IsometricViewport({super.key, this.onJoystickChanged});

  @override
  State<IsometricViewport> createState() => IsometricViewportState();
}

class IsometricViewportState extends State<IsometricViewport> with SingleTickerProviderStateMixin {
  double _cameraX = 0;
  double _cameraY = 0;
  final MapService _mapService = MapService();
  MapZoneModel? _currentZone;
  double _joystickX = 0;
  double _joystickY = 0;
  late AnimationController _movementController;
  
  // Keyboard movement
  final Set<LogicalKeyboardKey> _pressedKeys = {};
  
  // Click-to-move
  Offset? _targetPosition;
  bool _isMovingToTarget = false;
  
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadCurrentZone();
    _movementController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateMovement);
    _movementController.repeat();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _movementController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateMovement() {
    final character = GameStateService().currentCharacter;
    if (character == null || _currentZone == null) return;

    double deltaX = 0;
    double deltaY = 0;
    final speed = 0.5;

    // Priority 1: Joystick movement
    if (_joystickX != 0 || _joystickY != 0) {
      deltaX = _joystickX * speed;
      deltaY = _joystickY * speed;
      _isMovingToTarget = false;
      _targetPosition = null;
    }
    // Priority 2: Keyboard movement
    else if (_pressedKeys.isNotEmpty) {
      if (_pressedKeys.contains(LogicalKeyboardKey.keyW) || _pressedKeys.contains(LogicalKeyboardKey.arrowUp)) {
        deltaY -= speed;
      }
      if (_pressedKeys.contains(LogicalKeyboardKey.keyS) || _pressedKeys.contains(LogicalKeyboardKey.arrowDown)) {
        deltaY += speed;
      }
      if (_pressedKeys.contains(LogicalKeyboardKey.keyA) || _pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
        deltaX -= speed;
      }
      if (_pressedKeys.contains(LogicalKeyboardKey.keyD) || _pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
        deltaX += speed;
      }
      _isMovingToTarget = false;
      _targetPosition = null;
    }
    // Priority 3: Click-to-move
    else if (_isMovingToTarget && _targetPosition != null) {
      final currentX = character.positionX;
      final currentY = character.positionY;
      final targetX = _targetPosition!.dx;
      final targetY = _targetPosition!.dy;

      final dx = targetX - currentX;
      final dy = targetY - currentY;
      final distance = math.sqrt(dx * dx + dy * dy);

      if (distance < speed * 2) {
        // Reached target
        _isMovingToTarget = false;
        _targetPosition = null;
      } else {
        // Move towards target
        deltaX = (dx / distance) * speed;
        deltaY = (dy / distance) * speed;
      }
    }

    // Apply movement
    if (deltaX != 0 || deltaY != 0) {
      final newX = character.positionX + deltaX;
      final newY = character.positionY + deltaY;
      
      final clampedX = newX.clamp(0.0, _currentZone!.width.toDouble());
      final clampedY = newY.clamp(0.0, _currentZone!.height.toDouble());
      
      GameStateService().updateCharacterPosition(clampedX, clampedY);
      
      // Auto-center camera on character
      _updateCamera();
    }
  }

  void _updateCamera() {
    final character = GameStateService().currentCharacter;
    if (character == null) return;
    
    // Smooth camera follow
    final targetCameraX = character.positionX * 30.0;
    final targetCameraY = character.positionY * 15.0;
    
    setState(() {
      _cameraX += (targetCameraX - _cameraX) * 0.1;
      _cameraY += (targetCameraY - _cameraY) * 0.1;
    });
  }

  void handleJoystickChanged(double x, double y) {
    setState(() {
      _joystickX = x;
      _joystickY = y;
    });
  }

  void _loadCurrentZone() {
    final character = GameStateService().currentCharacter;
    if (character != null) {
      final zoneName = character.currentZone ?? 'omni_entertainment';
      final zoneId = _getZoneIdFromName(zoneName);
      setState(() {
        _currentZone = _mapService.getZone(zoneId);
      });
    } else {
      setState(() {
        _currentZone = _mapService.getZone('omni_entertainment');
      });
    }
  }

  String _getZoneIdFromName(String zoneName) {
    final zoneMap = {
      'Omni-1 Entertainment': 'omni_entertainment',
      'Old Athen': 'old_athen',
      'Newland Desert': 'newland_desert',
      'Perpetual Wastelands': 'perpetual_wastelands',
      'Shadowlands': 'shadowlands',
      'Temple of Three Winds': 'temple_winds',
    };
    return zoneMap[zoneName] ?? 'omni_entertainment';
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          setState(() {
            _pressedKeys.add(event.logicalKey);
          });
        } else if (event is KeyUpEvent) {
          setState(() {
            _pressedKeys.remove(event.logicalKey);
          });
        }
      },
      child: GestureDetector(
        onTapUp: (details) {
          _handleTap(details.localPosition);
          _focusNode.requestFocus();
        },
        child: Container(
          color: GameColors.deepSpace,
          child: CustomPaint(
            size: Size.infinite,
            painter: IsometricPainter(
              cameraX: _cameraX,
              cameraY: _cameraY,
              character: GameStateService().currentCharacter,
              zone: _currentZone,
              targetPosition: _targetPosition,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset position) {
    if (_currentZone == null) return;

    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final worldPos = _screenToIso(
      position.dx,
      position.dy,
      centerX,
      centerY,
      60,
      30,
    );

    // Clamp to zone bounds
    final clampedX = worldPos.dx.clamp(0.0, _currentZone!.width.toDouble());
    final clampedY = worldPos.dy.clamp(0.0, _currentZone!.height.toDouble());

    setState(() {
      _targetPosition = Offset(clampedX, clampedY);
      _isMovingToTarget = true;
    });
  }

  Offset _screenToIso(double screenX, double screenY, double centerX, double centerY, double tileWidth, double tileHeight) {
    final adjustedX = screenX - centerX + _cameraX;
    final adjustedY = screenY - centerY + _cameraY;

    final isoX = (adjustedX / (tileWidth / 2) + adjustedY / (tileHeight / 2)) / 2;
    final isoY = (adjustedY / (tileHeight / 2) - adjustedX / (tileWidth / 2)) / 2;

    return Offset(isoX, isoY);
  }
}

class IsometricPainter extends CustomPainter {
  final double cameraX;
  final double cameraY;
  final dynamic character;
  final MapZoneModel? zone;
  final Offset? targetPosition;

  IsometricPainter({
    required this.cameraX,
    required this.cameraY,
    this.character,
    this.zone,
    this.targetPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    if (zone != null) {
      _drawMapTiles(canvas, size, centerX, centerY);
      _drawMapObjects(canvas, centerX, centerY);
      _drawMapNPCs(canvas, centerX, centerY);
      _drawMapEnemies(canvas, centerX, centerY);
      _drawTargetMarker(canvas, centerX, centerY);
    } else {
      _drawGrid(canvas, size, centerX, centerY);
    }

    _drawCharacter(canvas, centerX, centerY);
    _drawZoneInfo(canvas, size);
    _drawMinimap(canvas, size);
  }

  void _drawMapTiles(Canvas canvas, Size size, double centerX, double centerY) {
    if (zone == null) return;

    final tileWidth = 60.0;
    final tileHeight = 30.0;

    final viewportLeft = -cameraX - size.width / 2;
    final viewportRight = -cameraX + size.width / 2;
    final viewportTop = -cameraY - size.height / 2;
    final viewportBottom = -cameraY + size.height / 2;

    final startX = math.max(0, ((viewportLeft / tileWidth) - 10).floor());
    final endX = math.min(zone!.width, ((viewportRight / tileWidth) + 10).ceil());
    final startY = math.max(0, ((viewportTop / tileHeight) - 10).floor());
    final endY = math.min(zone!.height, ((viewportBottom / tileHeight) + 10).ceil());

    for (int y = startY; y < endY; y++) {
      for (int x = startX; x < endX; x++) {
        final tileType = zone!.tiles[y][x];
        final screenPos = _isoToScreen(x.toDouble(), y.toDouble(), centerX, centerY, tileWidth, tileHeight);

        final color = _getTileColor(tileType);
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        final path = Path();
        path.moveTo(screenPos.dx, screenPos.dy);
        path.lineTo(screenPos.dx + tileWidth / 2, screenPos.dy + tileHeight / 2);
        path.lineTo(screenPos.dx, screenPos.dy + tileHeight);
        path.lineTo(screenPos.dx - tileWidth / 2, screenPos.dy + tileHeight / 2);
        path.close();

        canvas.drawPath(path, paint);

        final borderPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        canvas.drawPath(path, borderPaint);
      }
    }
  }

  Color _getTileColor(int tileType) {
    switch (tileType) {
      case 0: return Color(0xFF4A7C59);
      case 1: return Color(0xFF8B7355);
      case 2: return Color(0xFFE8D4A2);
      case 3: return Color(0xFF4A90E2);
      case 4: return Color(0xFF6B6B6B);
      case 5: return Color(0xFF5A6B7C);
      case 6: return Color(0xFF7C8A99);
      case 7: return Color(0xFF4A4A4A);
      case 8: return Color(0xFF3A3A3A);
      case 9: return Color(0xFF8A9BA8);
      case 10: return Color(0xFF9B8563);
      case 11: return Color(0xFF6B5B4B);
      case 12: return Color(0xFF8B4789);
      case 13: return Color(0xFF4A5A6A);
      case 14: return Color(0xFF6A4A8B);
      case 15: return Color(0xFFAA77DD);
      case 16: return Color(0xFF1A1A2E);
      case 17: return Color(0xFF5A8BDD);
      case 18: return Color(0xFF8B7355);
      case 19: return Color(0xFFB89968);
      default: return Color(0xFF5A6B7C);
    }
  }

  void _drawMapObjects(Canvas canvas, double centerX, double centerY) {
    if (zone == null) return;

    for (final obj in zone!.objects) {
      final screenPos = _isoToScreen(obj.x, obj.y, centerX, centerY, 60, 30);

      final paint = Paint()..color = Color(0xFF8B6B47);
      canvas.drawCircle(Offset(screenPos.dx, screenPos.dy - 10), 8, paint);

      final outlinePaint = Paint()
        ..color = Color(0xFFD4A574)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(screenPos.dx, screenPos.dy - 10), 8, outlinePaint);
    }
  }

  void _drawMapNPCs(Canvas canvas, double centerX, double centerY) {
    if (zone == null) return;

    for (final npc in zone!.npcs) {
      final screenPos = _isoToScreen(npc.x, npc.y, centerX, centerY, 60, 30);

      final bodyPaint = Paint()..color = Color(0xFF4A9EFF);
      canvas.drawCircle(Offset(screenPos.dx, screenPos.dy - 20), 12, bodyPaint);

      final outlinePaint = Paint()
        ..color = Color(0xFF00FF88)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(screenPos.dx, screenPos.dy - 20), 12, outlinePaint);

      final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.3);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(screenPos.dx, screenPos.dy), width: 18, height: 6),
        shadowPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: npc.name,
          style: TextStyle(color: Color(0xFF00FF88), fontSize: 10, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(screenPos.dx - textPainter.width / 2, screenPos.dy - 40));
    }
  }

  void _drawMapEnemies(Canvas canvas, double centerX, double centerY) {
    if (zone == null) return;

    for (final enemy in zone!.enemies) {
      final screenPos = _isoToScreen(enemy.x, enemy.y, centerX, centerY, 60, 30);

      final bodyPaint = Paint()..color = Color(0xFFFF4A4A);
      canvas.drawCircle(Offset(screenPos.dx, screenPos.dy - 20), 14, bodyPaint);

      final outlinePaint = Paint()
        ..color = Color(0xFFFF8888)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(screenPos.dx, screenPos.dy - 20), 14, outlinePaint);

      final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.3);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(screenPos.dx, screenPos.dy), width: 20, height: 7),
        shadowPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${enemy.name} [${enemy.level}]',
          style: TextStyle(color: Color(0xFFFF4A4A), fontSize: 10, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(screenPos.dx - textPainter.width / 2, screenPos.dy - 42));
    }
  }

  void _drawTargetMarker(Canvas canvas, double centerX, double centerY) {
    if (targetPosition == null) return;

    final screenPos = _isoToScreen(targetPosition!.dx, targetPosition!.dy, centerX, centerY, 60, 30);

    final markerPaint = Paint()
      ..color = GameColors.neonCyan.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(screenPos.dx, screenPos.dy), 15, markerPaint);
    canvas.drawCircle(Offset(screenPos.dx, screenPos.dy), 10, markerPaint);

    // Draw X marker
    canvas.drawLine(
      Offset(screenPos.dx - 8, screenPos.dy - 8),
      Offset(screenPos.dx + 8, screenPos.dy + 8),
      markerPaint,
    );
    canvas.drawLine(
      Offset(screenPos.dx + 8, screenPos.dy - 8),
      Offset(screenPos.dx - 8, screenPos.dy + 8),
      markerPaint,
    );
  }

  void _drawGrid(Canvas canvas, Size size, double centerX, double centerY) {
    final gridSize = 20;
    final tileWidth = 60.0;
    final tileHeight = 30.0;

    for (int y = -gridSize; y < gridSize; y++) {
      for (int x = -gridSize; x < gridSize; x++) {
        final screenPos = _isoToScreen(x.toDouble(), y.toDouble(), centerX, centerY, tileWidth, tileHeight);

        final isEvenTile = (x + y) % 2 == 0;
        final paint = Paint()
          ..color = isEvenTile ? GameColors.slateGray.withValues(alpha: 0.3) : GameColors.darkSteel.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

        final path = Path();
        path.moveTo(screenPos.dx, screenPos.dy);
        path.lineTo(screenPos.dx + tileWidth / 2, screenPos.dy + tileHeight / 2);
        path.lineTo(screenPos.dx, screenPos.dy + tileHeight);
        path.lineTo(screenPos.dx - tileWidth / 2, screenPos.dy + tileHeight / 2);
        path.close();

        canvas.drawPath(path, paint);

        final borderPaint = Paint()
          ..color = GameColors.neonCyan.withValues(alpha: 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawPath(path, borderPaint);
      }
    }
  }

  void _drawCharacter(Canvas canvas, double centerX, double centerY) {
    if (character == null) return;

    final charX = character.positionX;
    final charY = character.positionY;
    final screenPos = _isoToScreen(charX, charY, centerX, centerY, 60, 30);

    final bodyPaint = Paint()..color = GameColors.electricPurple;
    canvas.drawCircle(Offset(screenPos.dx, screenPos.dy - 25), 18, bodyPaint);

    final outlinePaint = Paint()
      ..color = GameColors.neonCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(screenPos.dx, screenPos.dy - 25), 18, outlinePaint);

    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.4);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(screenPos.dx, screenPos.dy), width: 25, height: 10),
      shadowPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: character.name,
        style: TextStyle(color: GameColors.neonCyan, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(screenPos.dx - textPainter.width / 2, screenPos.dy - 50));
  }

  void _drawZoneInfo(Canvas canvas, Size size) {
    if (zone == null) return;

    final boxWidth = 200.0;
    final boxHeight = 60.0;
    final rightMargin = 16.0;
    final topMargin = 100.0;

    final bgPaint = Paint()..color = GameColors.darkSteel.withValues(alpha: 0.9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - boxWidth - rightMargin, topMargin, boxWidth, boxHeight),
        Radius.circular(12),
      ),
      bgPaint,
    );

    final borderPaint = Paint()
      ..color = GameColors.neonCyan.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - boxWidth - rightMargin, topMargin, boxWidth, boxHeight),
        Radius.circular(12),
      ),
      borderPaint,
    );

    final titlePainter = TextPainter(
      text: TextSpan(
        text: zone!.name,
        style: TextStyle(color: GameColors.neonCyan, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout(maxWidth: boxWidth - 20);
    titlePainter.paint(canvas, Offset(size.width - boxWidth - rightMargin + 10, topMargin + 10));

    final descPainter = TextPainter(
      text: TextSpan(
        text: 'Lv${zone!.recommendedLevel}+ • ${zone!.faction}',
        style: TextStyle(color: GameColors.lightGray, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    descPainter.layout(maxWidth: boxWidth - 20);
    descPainter.paint(canvas, Offset(size.width - boxWidth - rightMargin + 10, topMargin + 35));
  }

  void _drawMinimap(Canvas canvas, Size size) {
    if (zone == null || character == null) return;

    final minimapSize = 120.0;
    final rightMargin = 16.0;
    final topMargin = 180.0;
    final minimapX = size.width - minimapSize - rightMargin;
    final minimapY = topMargin;

    final bgPaint = Paint()..color = GameColors.darkSteel.withValues(alpha: 0.9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(minimapX, minimapY, minimapSize, minimapSize),
        Radius.circular(12),
      ),
      bgPaint,
    );

    final borderPaint = Paint()
      ..color = GameColors.neonCyan.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(minimapX, minimapY, minimapSize, minimapSize),
        Radius.circular(12),
      ),
      borderPaint,
    );

    final scaleX = minimapSize / zone!.width;
    final scaleY = minimapSize / zone!.height;

    for (final enemy in zone!.enemies) {
      final ex = minimapX + enemy.x * scaleX;
      final ey = minimapY + enemy.y * scaleY;
      final enemyPaint = Paint()..color = Color(0xFFFF4A4A);
      canvas.drawCircle(Offset(ex, ey), 2.5, enemyPaint);
    }

    for (final npc in zone!.npcs) {
      final nx = minimapX + npc.x * scaleX;
      final ny = minimapY + npc.y * scaleY;
      final npcPaint = Paint()..color = Color(0xFF00FF88);
      canvas.drawCircle(Offset(nx, ny), 2.5, npcPaint);
    }

    if (targetPosition != null) {
      final tx = minimapX + targetPosition!.dx * scaleX;
      final ty = minimapY + targetPosition!.dy * scaleY;
      final targetPaint = Paint()..color = GameColors.neonCyan.withValues(alpha: 0.6);
      canvas.drawCircle(Offset(tx, ty), 3, targetPaint);
    }

    final charX = minimapX + character.positionX * scaleX;
    final charY = minimapY + character.positionY * scaleY;
    final charPaint = Paint()..color = GameColors.neonCyan;
    canvas.drawCircle(Offset(charX, charY), 4, charPaint);
  }

  Offset _isoToScreen(double isoX, double isoY, double centerX, double centerY, double tileWidth, double tileHeight) {
    final screenX = centerX + (isoX - isoY) * (tileWidth / 2) - cameraX;
    final screenY = centerY + (isoX + isoY) * (tileHeight / 2) - cameraY;
    return Offset(screenX, screenY);
  }

  @override
  bool shouldRepaint(covariant IsometricPainter oldDelegate) =>
      oldDelegate.cameraX != cameraX ||
      oldDelegate.cameraY != cameraY ||
      oldDelegate.character != character ||
      oldDelegate.zone != zone ||
      oldDelegate.targetPosition != targetPosition;
}
