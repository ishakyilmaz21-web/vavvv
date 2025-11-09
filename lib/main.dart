import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const EzanVaktiPlusApp());
}

class EzanVaktiPlusApp extends StatelessWidget {
  const EzanVaktiPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ezan Vakti Plus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF2F4F6),
      ),
      home: const IntroScreen(),
    );
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _initializing = true;

  final List<String> cities = <String>[
    'Adana','Adıyaman','Afyonkarahisar','Ağrı','Aksaray','Amasya','Ankara','Antalya','Ardahan','Artvin',
    'Aydın','Balıkesir','Bartın','Batman','Bayburt','Bilecik','Bingöl','Bitlis','Bolu','Burdur','Bursa',
    'Çanakkale','Çankırı','Çorum','Denizli','Diyarbakır','Düzce','Edirne','Elazığ','Erzincan','Erzurum',
    'Eskişehir','Gaziantep','Giresun','Gümüşhane','Hakkari','Hatay','Iğdır','Isparta','İstanbul','İzmir',
    'Kahramanmaraş','Karabük','Karaman','Kars','Kastamonu','Kayseri','Kırıkkale','Kırklareli','Kırşehir',
    'Kilis','Kocaeli','Konya','Kütahya','Malatya','Manisa','Mardin','Mersin','Muğla','Muş','Nevşehir',
    'Niğde','Ordu','Osmaniye','Rize','Sakarya','Samsun','Şanlıurfa','Siirt','Sinop','Sivas','Şırnak',
    'Tekirdağ','Tokat','Trabzon','Tunceli','Uşak','Van','Yalova','Yozgat','Zonguldak',
  ];

  @override
  void initState() {
    super.initState();
    _attemptAutoRedirect();
  }

  Future<void> _attemptAutoRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString(StorageKeys.selectedCity);
    final useLocation = prefs.getBool(StorageKeys.useLocation) ?? false;

    if (!mounted) return;

    if (savedCity != null && savedCity.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(city: savedCity, useLocation: useLocation),
        ),
      );
    } else {
      setState(() => _initializing = false);
    }
  }

  Future<void> _saveSelection({required String city, required bool useLocation}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.selectedCity, city);
    await prefs.setBool(StorageKeys.useLocation, useLocation);
  }

  void _openCityPicker() async {
    final city = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => _CityPickerDialog(cities: cities),
    );

    if (!mounted || city == null) return;

    await _saveSelection(city: city, useLocation: false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(city: city, useLocation: false),
      ),
    );
  }

  Future<void> _useLocation() async {
    await _saveSelection(city: 'Mevcut Konum', useLocation: true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(city: 'Mevcut Konum', useLocation: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Arkaplan görsel
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1604871000636-074fa5117945?auto=format&fit=crop&w=2000&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Karanlık katman
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.45))),
          // İçerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  const Text(
                    'Selamünaleyküm',
                    style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ezan Vakti Plus ile vakitleri ve havayı tek ekranda keşfet.',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: _openCityPicker,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Şehrini Seç', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _useLocation,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.my_location_outlined),
                    label: const Text('Konumunu Kullan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CityPickerDialog extends StatefulWidget {
  const _CityPickerDialog({required this.cities});
  final List<String> cities;

  @override
  State<_CityPickerDialog> createState() => _CityPickerDialogState();
}

class _CityPickerDialogState extends State<_CityPickerDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCities = _searchQuery.isEmpty
        ? widget.cities
        : widget.cities.where((c) => c.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Şehir ara...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
            Expanded(
              child: filteredCities.isEmpty
                  ? const Center(child: Text('Şehir bulunamadı'))
                  : ListView.builder(
                      itemCount: filteredCities.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(filteredCities[i]),
                        onTap: () => Navigator.of(context).pop(filteredCities[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.city, required this.useLocation, super.key});
  final String city;
  final bool useLocation;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<PrayerTime> _prayerTimes;
  late List<WeatherForecast> _forecast;
  Timer? _timer;

  PrayerTime? _currentPrayer;
  PrayerTime? _nextPrayer;
  Duration? _timeUntilNext;

  final VerseOfTheDay _verse = const VerseOfTheDay(
    content: '"Allah, göklerin ve yerin nurudur."',
    source: 'Nur Suresi 24:35',
  );

  @override
  void initState() {
    super.initState();
    _prayerTimes = _generateSamplePrayerTimes();
    _forecast = _generateSampleForecast();
    _computePrayerState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _computePrayerState());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _computePrayerState() {
    final now = DateTime.now();
    PrayerTime? current;
    PrayerTime? next;

    for (var i = 0; i < _prayerTimes.length; i++) {
      final start = _prayerTimes[i].time;
      final end = i < _prayerTimes.length - 1 ? _prayerTimes[i + 1].time : start.add(const Duration(hours: 24));
      if (now.isAfter(start) && now.isBefore(end)) {
        current = _prayerTimes[i];
        next = i < _prayerTimes.length - 1
            ? _prayerTimes[i + 1]
            : _prayerTimes.first.copyWith(time: _prayerTimes.first.time.add(const Duration(days: 1)));
        break;
      }
    }

    if (current == null) {
      if (now.isBefore(_prayerTimes.first.time)) {
        current = null;
        next = _prayerTimes.first;
      } else {
        current = _prayerTimes.last;
        next = _prayerTimes.first.copyWith(time: _prayerTimes.first.time.add(const Duration(days: 1)));
      }
    }

    setState(() {
      _currentPrayer = current;
      _nextPrayer = next;
      _timeUntilNext = next?.time.difference(now);
    });
  }

  List<PrayerTime> _generateSamplePrayerTimes() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      PrayerTime(name: 'İmsak', time: today.add(const Duration(hours: 5, minutes: 15))),
      PrayerTime(name: 'Sabah', time: today.add(const Duration(hours: 6, minutes: 50))),
      PrayerTime(name: 'Güneş', time: today.add(const Duration(hours: 8, minutes: 5))),
      PrayerTime(name: 'Öğle', time: today.add(const Duration(hours: 13, minutes: 15))),
      PrayerTime(name: 'İkindi', time: today.add(const Duration(hours: 16, minutes: 45))),
      PrayerTime(name: 'Akşam', time: today.add(const Duration(hours: 18, minutes: 50))),
      PrayerTime(name: 'Yatsı', time: today.add(const Duration(hours: 20, minutes: 10))),
    ];
  }

  List<WeatherForecast> _generateSampleForecast() {
    final now = DateTime.now();
    return [
      WeatherForecast(day: 'Bugün', description: 'Parçalı Bulutlu', temperature: 18),
      WeatherForecast(day: 'Yarın', description: 'Az Yağmurlu', temperature: 16),
      WeatherForecast(
        day: '${now.add(const Duration(days: 2)).day}.${now.month}',
        description: 'Güneşli',
        temperature: 20,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(StorageKeys.selectedCity);
          await prefs.remove(StorageKeys.useLocation);
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const IntroScreen()),
            (_) => false,
          );
        },
        icon: const Icon(Icons.edit_location_alt),
        label: const Text('Şehir Değiştir'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst başlık + hava
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Şehir', style: TextStyle(color: Colors.black54, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(widget.city, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  WeatherSummaryCard(forecasts: _forecast),
                ],
              ),
              const SizedBox(height: 24),

              PrayerCountdownCard(
                currentPrayer: _currentPrayer,
                nextPrayer: _nextPrayer,
                timeUntilNext: _timeUntilNext,
              ),
              const SizedBox(height: 24),

              Expanded(
                child: PrayerTimesList(prayerTimes: _prayerTimes, currentPrayer: _currentPrayer),
              ),
              const SizedBox(height: 16),

              VerseCard(verse: _verse),
            ],
          ),
        ),
      ),
    );
  }
}

class PrayerCountdownCard extends StatelessWidget {
  const PrayerCountdownCard({
    required this.currentPrayer,
    required this.nextPrayer,
    required this.timeUntilNext,
    super.key,
  });

  final PrayerTime? currentPrayer;
  final PrayerTime? nextPrayer;
  final Duration? timeUntilNext;

  String _formatDuration(Duration? d) {
    if (d == null) return '--:--';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0
        ? '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isUpcoming = currentPrayer == null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isUpcoming ? 'Sıradaki Vakit' : '${currentPrayer!.name} Vakti İçindesin',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Yaklaşan Vakit', style: TextStyle(color: Colors.black54, fontSize: 14)),
                const SizedBox(height: 4),
                Text(nextPrayer?.name ?? '--', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
              Text(
                _formatDuration(timeUntilNext),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PrayerTimesList extends StatelessWidget {
  const PrayerTimesList({required this.prayerTimes, required this.currentPrayer, super.key});

  final List<PrayerTime> prayerTimes;
  final PrayerTime? currentPrayer;

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: prayerTimes.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 24, endIndent: 24),
        itemBuilder: (_, i) {
          final p = prayerTimes[i];
          final active = currentPrayer?.name == p.name;
          return ListTile(
            title: Text(
              p.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? Colors.redAccent : Colors.black87,
              ),
            ),
            trailing: Text(
              _fmt(p.time),
              style: TextStyle(
                fontSize: 18,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? Colors.redAccent : Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }
}

class WeatherSummaryCard extends StatelessWidget {
  const WeatherSummaryCard({required this.forecasts, super.key});
  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    final today = forecasts.isNotEmpty ? forecasts.first : null;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: today == null
          ? const Text('—')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.wb_cloudy_outlined),
                Text('${today.temperature}°C', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(today.description, style: const TextStyle(fontSize: 12)),
              ],
            ),
    );
  }
}

class VerseCard extends StatelessWidget {
  const VerseCard({required this.verse, super.key});
  final VerseOfTheDay verse;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(verse.content, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
        const SizedBox(height: 8),
        Text(verse.source, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ]),
    );
  }
}

// ---- Basit veri sınıfları
class PrayerTime {
  final String name;
  final DateTime time;
  const PrayerTime({required this.name, required this.time});

  PrayerTime copyWith({String? name, DateTime? time}) =>
      PrayerTime(name: name ?? this.name, time: time ?? this.time);
}

class WeatherForecast {
  final String day;
  final String description;
  final int temperature;
  const WeatherForecast({required this.day, required this.description, required this.temperature});
}

class VerseOfTheDay {
  final String content;
  final String source;
  const VerseOfTheDay({required this.content, required this.source});
}

// ---- SharedPreferences key'leri
class StorageKeys {
  static const selectedCity = 'selected_city';
  static const useLocation = 'use_location';
}
