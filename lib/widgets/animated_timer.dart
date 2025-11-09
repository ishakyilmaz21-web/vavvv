import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedPrayerTimer extends StatefulWidget {
  final Duration duration;
  const AnimatedPrayerTimer({super.key, required this.duration});

  @override
  State<AnimatedPrayerTimer> createState() => _AnimatedPrayerTimerState();
}

class _AnimatedPrayerTimerState extends State<AnimatedPrayerTimer> {
  late Duration _remaining;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining = _remaining - const Duration(seconds: 1);
        if (_remaining.isNegative) _remaining = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: _remaining.inSeconds.toDouble()),
      duration: const Duration(milliseconds: 300),
      builder: (_, __, ___) => Text(
        _fmt(_remaining),
        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
