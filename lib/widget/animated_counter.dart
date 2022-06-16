import 'dart:async' show Timer;

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';

import '../contacts/instances.dart';

const Duration _kTimerDuration = Duration(milliseconds: 200);

const Duration _kCountAnimatedDuration = Duration(milliseconds: 400);

class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.count,
    this.duration = const Duration(milliseconds: 1400),
  });

  final int count;
  final Duration duration;

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  double _count = 0.0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final int count =
        (widget.duration.inMilliseconds / _kTimerDuration.inMilliseconds)
            .floor();
    final double stepValue = widget.count / count;

    _timer = Timer.periodic(_kTimerDuration, (Timer timer) {
      if (_count >= widget.count) {
        setState(() {
          _count = widget.count.toDouble();
        });

        timer.cancel();

        _timer = null;
      } else {
        setState(() {
          _count += stepValue;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedFlipCounter(
      thousandSeparator: ',',
      duration: _kCountAnimatedDuration,
      value: _count,
      textStyle: currentTheme.textTheme.displaySmall,
    );
  }
}
