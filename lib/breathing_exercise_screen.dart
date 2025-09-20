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
  bool _showWellDone = false;
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
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
          } else {
            timer.cancel();
            _controller.stop();
            _inhaleExhaleText = '';
            setState(() {
              _showWellDone = true;
            });
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/Onboarding 14.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: _showWellDone
                    ? const Text(
                        'Well Done!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (_quoteVisible)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'Breathe in calm, breathe out stress—your peace begins with every breath.',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (!_quoteVisible)
                            Text(
                              'Time: $_timerSeconds',
                              style: const TextStyle(fontSize: 20, color: Colors.black),
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
                              style: const TextStyle(fontSize: 24, color: Colors.black),
                            ),
                          if (_exerciseStarted && !_quoteVisible) const SizedBox(height: 20),
                          Image.asset(
                            'assets/Gemini_Generated_Image_bib6pqbib6pqbib6__1_-removebg-preview.png',
                            width: 200 * (_animation.value * 1.5),
                            height: 200 * (_animation.value * 1.5),
                          ),
                        ],
                      ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
