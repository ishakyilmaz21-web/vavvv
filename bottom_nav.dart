import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/qibla_screen.dart';
import '../screens/zikirmatik_screen.dart';
import '../screens/quran_screen.dart';
import '../screens/settings_screen.dart';

class BottomNav extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const BottomNav({super.key, required this.onThemeToggle});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _index = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    QiblaScreen(),
    ZikirmatikScreen(),
    QuranScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = [
    "Ana Sayfa",
    "Kıble",
    "Zikirmatik",
    "Kur'an",
    "Ayarlar"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Kıble"),
          BottomNavigationBarItem(icon: Icon(Icons.repeat), label: "Zikirmatik"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Kur'an"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
        ],
      ),
    );
  }
}
