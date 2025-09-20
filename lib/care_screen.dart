import 'package:flutter/material.dart';
import 'breathing_exercise_screen.dart';
import 'word_hunt_screen.dart';
import 'doodle_screen.dart';

class CareScreen extends StatelessWidget {
  const CareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BreathingExerciseScreen(),
                      ),
                    );
                  },
                  child: const Text('Breathing Exercise'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordHuntScreen(),
                      ),
                    );
                  },
                  child: const Text('Word Hunt'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoodleScreen(),
                      ),
                    );
                  },
                  child: const Text('Doodle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
