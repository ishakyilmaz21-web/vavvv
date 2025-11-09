import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(const EzanVaktiPlus());
}

class EzanVaktiPlus extends StatefulWidget {
  const EzanVaktiPlus({super.key});

  @override
  State<EzanVaktiPlus> createState() => _EzanVaktiPlusState();
}

class _EzanVaktiPlusState extends State<EzanVaktiPlus> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ezan Vakti Plus",
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: BottomNav(
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
