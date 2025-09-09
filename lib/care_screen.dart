import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CareScreen extends StatelessWidget {
  const CareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BreathingExerciseScreen()),
                  );
                },
                child: const Text(
                  'Breathing Exercise',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                ),
                onPressed: () async {
                  final Uri phoneUri = Uri.parse('tel:18008914416');
                  try {
                    await launchUrl(phoneUri);
                  } catch (error) {
                    print("Can't open dialer. Error: $error");
                  }
                },
                child: const Text(
                  'Get Help',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _timerSeconds = 60;
  bool _startTextVisible = true;
  bool _exerciseStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 1, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _startTextVisible = false;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _exerciseStarted = true;
      });
      _controller.repeat(reverse: true);
      _startTimer();
    });
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
          _startTimer();
        } else {
          _controller.stop();
        }
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
            Text(
              'Time: $_timerSeconds',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            if (_startTextVisible)
              ElevatedButton(
                onPressed: _startBreathing,
                child: const Text('Start Breathing'),
              ),
            if (!_startTextVisible && !_exerciseStarted && _timerSeconds > 0)
              const Text(
                'Breathe deeply, let go, and invite calm with every breath',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (_timerSeconds == 0)
              AnimatedOpacity(
                opacity: _exerciseStarted ? 1.0 : 0.0,
                duration: const Duration(seconds: 2),
                child: const Text(
                  'Breathe in deep, let worries sleep',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            if (_exerciseStarted)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    children: [
                      Icon(
                        _controller.value <= 0.5 ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 100,
                      ),
                      Text(
                        _controller.value <= 0.5 ? 'Inhale' : 'Exhale',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
