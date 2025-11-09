import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  Position? _pos;
  String? _err;

  static const _kaabaLat = 21.4225;
  static const _kaabaLon = 39.8262;

  @override
  void initState() {
    super.initState();
    _ensureLocation();
  }

  Future<void> _ensureLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _err = "Konum servisi kapalı");
        return;
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
        setState(() => _err = "Konum izni verilmedi");
        return;
      }
      final p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      setState(() => _pos = p);
    } catch (e) {
      setState(() => _err = e.toString());
    }
  }

  double _bearingToKaaba(double lat, double lon) {
    final phi1 = lat * math.pi / 180;
    final phi2 = _kaabaLat * math.pi / 180;
    final dLon = (_kaabaLon - lon) * math.pi / 180;
    final y = math.sin(dLon) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) - math.sin(phi1) * math.cos(phi2) * math.cos(dLon);
    double brng = math.atan2(y, x) * 180 / math.pi;
    return (brng + 360) % 360; // 0..360
  }

  @override
  Widget build(BuildContext context) {
    if (_err != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Kıble Yönü")),
        body: Center(child: Text(_err!)),
      );
    }
    if (_pos == null) {
      return const Scaffold(
        appBar: AppBar(title: Text("Kıble Yönü")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final qiblaBearing = _bearingToKaaba(_pos!.latitude, _pos!.longitude);

    return Scaffold(
      appBar: AppBar(title: const Text("Kıble Yönü")),
      body: StreamBuilder(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          final heading = (snapshot.data?.heading ?? 0);
          final angleToQibla = ((qiblaBearing - heading) * math.pi / 180);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 260, height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 6),
                      ),
                    ),
                    Transform.rotate(
                      angle: angleToQibla,
                      child: const Icon(Icons.navigation, size: 120), // ok
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Kıble Açısı: ${qiblaBearing.toStringAsFixed(1)}°"),
                Text("Cihaz Başlığı: ${heading.toStringAsFixed(1)}°"),
                const SizedBox(height: 8),
                const Text("Oku Kıble'ye çevirin"),
              ],
            ),
          );
        },
      ),
    );
  }
}
