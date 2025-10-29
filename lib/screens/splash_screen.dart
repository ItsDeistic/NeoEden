import 'package:flutter/material.dart';
import 'package:neoeden/services/character_service.dart';
import 'package:neoeden/services/storage_service.dart';
import 'package:neoeden/theme.dart';
import 'package:neoeden/screens/character_selection_screen.dart';
import 'package:neoeden/screens/character_creation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    _controller.forward();
    _initialize();
  }

  Future<void> _initialize() async {
    await StorageService().init();
    await Future.delayed(const Duration(seconds: 3));
    
    final characters = await CharacterService().getAllCharacters();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => characters.isEmpty
            ? const CharacterCreationScreen()
            : const CharacterSelectionScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [GameColors.deepSpace, GameColors.darkSteel, GameColors.slateGray],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [GameColors.neonCyan, GameColors.electricPurple],
                    ),
                  ),
                  child: Icon(Icons.games, size: 70, color: GameColors.pureWhite),
                ),
                const SizedBox(height: 32),
                Text('NEOEDEN', style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  letterSpacing: 4,
                  shadows: [Shadow(color: GameColors.neonCyan, blurRadius: 20)],
                )),
                const SizedBox(height: 16),
                Text('A NEW WORLD AWAITS', style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 2)),
                const SizedBox(height: 48),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: GameColors.neonCyan,
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
