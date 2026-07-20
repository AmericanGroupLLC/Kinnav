import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_map_screen.dart';

void main() {
  runApp(const SaferApp());
}

class SaferApp extends StatelessWidget {
  const SaferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeMapScreen(),
    );
  }
}
