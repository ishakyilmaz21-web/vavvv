import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/animated_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Duration remaining = const Duration(hours: 1, minutes: 39, seconds: 42);
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        remaining = remaining - const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeNow = DateTime.now();
    final formatted =
        "${timeNow.day}.${timeNow.month}.${timeNow.year} (${timeNow.hour}:${timeNow.minute.toString().padLeft(2, '0')})";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Ezan Vakti Plus",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(formatted, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              const Text(
                "Vaktin Çıkmasına Kalan Süre",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              AnimatedPrayerTimer(duration: Duration(hours: 1, minutes: 39, seconds: 42)),
              const SizedBox(height: 50),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.menu_book, color: Colors.teal),
                      title: Text("Vaktin Ayeti"),
                      subtitle: Text("“Allah göklerin ve yerin nurudur.” (Nur Suresi 24:35)"),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.favorite, color: Colors.orange),
                      title: Text("Vaktin Hadisi"),
                      subtitle: Text("Güzel söz sadakadır."),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.auto_awesome, color: Colors.blueAccent),
                      title: Text("Bir Dua"),
                      subtitle: Text("“Rabbim! Kalbimi imanla aydınlat.”"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
