import 'package:flutter/material.dart';
import 'package:neoeden/theme.dart';
import 'package:neoeden/screens/splash_screen.dart';

void main() {
  runApp(const NeoEdenApp());
}

class NeoEdenApp extends StatelessWidget {
  const NeoEdenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeoEden - 2D Isometric MMORPG',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
