import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  List<dynamic> surahs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _fetchSurahs();
  }

  Future<void> _fetchSurahs() async {
    try {
      final r = await http.get(Uri.parse("https://api.acikkuran.com/surah"));
      final data = jsonDecode(utf8.decode(r.bodyBytes));
      setState(() {
        surahs = data['data'] ?? [];
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kur'an-ı Kerim"),
        bottom: TabBar(
          controller: _tab,
          tabs: const [Tab(text: "Cüz/Sure"), Tab(text: "Meal")],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // SURE LİSTESİ
          loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: surahs.length,
                  itemBuilder: (c, i) {
                    final s = surahs[i];
                    return ListTile(
                      title: Text("${s['name']}"),
                      subtitle: Text("${s['ayahs']} ayet"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SurahDetail(surahId: s['id'], title: s['name']),
                        ));
                      },
                    );
                  },
                ),
          // MEAL ÖRNEĞİ (Fatiha)
          FutureBuilder<http.Response>(
            future: http.get(Uri.parse("https://api.acikkuran.com/surah/1")),
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final data = jsonDecode(utf8.decode(snap.data!.bodyBytes));
              final verses = List.from(data['data']['verses'] ?? []);
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: verses.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, i) => ListTile(
                  title: Text(verses[i]['text']),
                  subtitle: Text(verses[i]['translation']['text'] ?? ""),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SurahDetail extends StatelessWidget {
  const SurahDetail({super.key, required this.surahId, required this.title});
  final int surahId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<http.Response>(
        future: http.get(Uri.parse("https://api.acikkuran.com/surah/$surahId")),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final data = jsonDecode(utf8.decode(snap.data!.bodyBytes));
          final verses = List.from(data['data']['verses'] ?? []);
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: verses.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) => ListTile(
              title: Text(verses[i]['text']),
              subtitle: Text(verses[i]['translation']['text'] ?? ""),
            ),
          );
        },
      ),
    );
  }
}
