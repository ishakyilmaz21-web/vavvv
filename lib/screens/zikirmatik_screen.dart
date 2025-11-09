import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZikirmatikScreen extends StatefulWidget {
  const ZikirmatikScreen({super.key});

  @override
  State<ZikirmatikScreen> createState() => _ZikirmatikScreenState();
}

class _ZikirmatikScreenState extends State<ZikirmatikScreen> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() => _count = p.getInt('zikir_count') ?? 0);
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('zikir_count', _count);
  }

  void _inc() { setState(() => _count++); _save(); }
  void _dec() { setState(() => _count = (_count > 0 ? _count-1 : 0)); _save(); }
  void _reset() { setState(() => _count = 0); _save(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zikirmatik")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$_count", style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(onPressed: _inc, child: const Text("+1")),
                OutlinedButton(onPressed: _dec, child: const Text("-1")),
                TextButton(onPressed: _reset, child: const Text("Sıfırla")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
