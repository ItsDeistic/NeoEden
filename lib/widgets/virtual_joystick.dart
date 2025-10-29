import 'package:flutter/material.dart';
import 'package:neoeden/theme.dart';
import 'dart:math' as math;

class VirtualJoystick extends StatefulWidget {
  final Function(double x, double y) onDirectionChanged;

  const VirtualJoystick({super.key, required this.onDirectionChanged});

  @override
  State<VirtualJoystick> createState() => _VirtualJoystickState();
}

class _VirtualJoystickState extends State<VirtualJoystick> {
  Offset _knobPosition = Offset.zero;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _isDragging = true;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          final centerX = 60.0;
          final centerY = 60.0;
          final maxDistance = 40.0;

          var dx = _knobPosition.dx + details.delta.dx;
          var dy = _knobPosition.dy + details.delta.dy;

          final distance = math.sqrt(dx * dx + dy * dy);
          if (distance > maxDistance) {
            dx = (dx / distance) * maxDistance;
            dy = (dy / distance) * maxDistance;
          }

          _knobPosition = Offset(dx, dy);
          
          final normalizedX = dx / maxDistance;
          final normalizedY = dy / maxDistance;
          widget.onDirectionChanged(normalizedX, normalizedY);
        });
      },
      onPanEnd: (details) {
        setState(() {
          _knobPosition = Offset.zero;
          _isDragging = false;
          widget.onDirectionChanged(0, 0);
        });
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: GameColors.darkSteel.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(color: GameColors.neonCyan.withValues(alpha: 0.6), width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: GameColors.slateGray.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
            Transform.translate(
              offset: _knobPosition,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _isDragging 
                      ? GameColors.neonCyan 
                      : GameColors.electricPurple,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: GameColors.neonCyan,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_isDragging ? GameColors.neonCyan : GameColors.electricPurple)
                          .withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.games,
                  color: _isDragging ? GameColors.darkSteel : GameColors.pureWhite,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
