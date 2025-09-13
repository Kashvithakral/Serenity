import 'package:flutter/material.dart';
import 'dart:async';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({Key? key}) : super(key: key);

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  int _timerSeconds = 60;
  bool _startTextVisible = true;
  bool _exerciseStarted = false;
  String _inhaleExhaleText = '';
  bool _quoteVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 1, end: 1.2).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _startTextVisible = false;
      _exerciseStarted = true;
      _inhaleExhaleText = 'Inhale';
      _quoteVisible = true;
    });

    _controller.repeat(reverse: true);

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _quoteVisible = false;
      });

      Timer.periodic(const Duration(seconds: 4), (timer) {
        setState(() {
          if (_inhaleExhaleText == 'Inhale') {
            _inhaleExhaleText = 'Exhale';
            _controller.reverse();
          } else {
            _inhaleExhaleText = 'Inhale';
            _controller.forward();
          }
        });
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
          } else {
            timer.cancel();
            _controller.stop();
            _inhaleExhaleText = '';
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_quoteVisible)
              const Text(
                'Breathe in calm, breathe out stress—your peace begins with every breath.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (!_quoteVisible)
              Text(
                'Time: $_timerSeconds',
                style: const TextStyle(fontSize: 20),
              ),
            if (!_quoteVisible) const SizedBox(height: 20),
            if (_startTextVisible && !_quoteVisible)
              ElevatedButton(
                onPressed: _startBreathing,
                child: const Text('Start Breathing'),
              ),
            if (_exerciseStarted && !_quoteVisible) const SizedBox(height: 20),
            if (_exerciseStarted && !_quoteVisible)
              Text(
                _inhaleExhaleText,
                style: const TextStyle(fontSize: 24),
              ),
            if (_exerciseStarted && !_quoteVisible) const SizedBox(height: 20),
            if (_exerciseStarted && !_quoteVisible)
              Image.asset(
                'assets/Gemini_Generated_Image_bib6pqbib6pqbib6__1_-removebg-preview.png',
                width: 200 * (_animation.value * 1.5),
                height: 200 * (_animation.value * 1.5),
              ),
          ],
        ),
      ),
    );
  }
}
