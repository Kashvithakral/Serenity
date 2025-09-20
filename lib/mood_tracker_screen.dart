import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';

class MoodTrackerScreen extends StatefulWidget {
  final VoidCallback onMoodDetermined;

  const MoodTrackerScreen({super.key, required this.onMoodDetermined});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, Object>> _questions = [
    {
      'question': 'How are you feeling today?',
      'answers': ['Happy', 'Sad', 'Angry', 'Low'],
    },
    {
      'question': 'What is your energy level?',
      'answers': ['High', 'Medium', 'Low'],
    },
    {
      'question': 'How did you sleep last night?',
      'answers': ['Well', 'Okay', 'Poorly'],
    },
    {
      'question': 'Are you feeling stressed?',
      'answers': ['Not at all', 'A little', 'A lot'],
    },
    {
      'question': 'How is your appetite?',
      'answers': ['Good', 'Normal', 'Poor'],
    },
    {
      'question': 'Are you feeling motivated?',
      'answers': ['Very', 'Somewhat', 'Not at all'],
    },
    {
      'question': 'How are you feeling physically?',
      'answers': ['Great', 'Okay', 'Not so good'],
    },
    {
      'question': 'Are you feeling overwhelmed?',
      'answers': ['No', 'A little', 'Yes'],
    },
  ];
  final Map<String, int> _moodScores = {
    'Happy': 0,
    'Sad': 0,
    'Angry': 0,
    'Low': 0,
  };

  void _handleAnswer(String answer) {
    setState(() {
      switch (answer) {
        case 'Happy':
        case 'High':
        case 'Well':
        case 'Not at all':
        case 'Good':
        case 'Very':
        case 'Great':
        case 'No':
          _moodScores['Happy'] = _moodScores['Happy']! + 1;
          break;
        case 'Sad':
        case 'Poorly':
        case 'A little':
        case 'Poor':
        case 'Not so good':
          _moodScores['Sad'] = _moodScores['Sad']! + 1;
          break;
        case 'Angry':
        case 'A lot':
        case 'Yes':
          _moodScores['Angry'] = _moodScores['Angry']! + 1;
          break;
        case 'Low':
        case 'Medium':
        case 'Okay':
        case 'Normal':
        case 'Somewhat':
        case 'Not at all':
          _moodScores['Low'] = _moodScores['Low']! + 1;
          break;
      }
    });

    if (_pageController.page! < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _showMoodResult();
    }
  }

  void _showMoodResult() {
    String mood = '';
    int maxScore = 0;
    _moodScores.forEach((key, value) {
      if (value > maxScore) {
        maxScore = value;
        mood = key;
      }
    });

    String suggestedBot = '';
    String botDescription = '';

    switch (mood) {
      case 'Happy':
        suggestedBot = 'Ira';
        botDescription = 'An emotional buddy to share your joy!';
        break;
      case 'Sad':
        suggestedBot = 'Ira';
        botDescription = 'An emotional buddy to help you through it.';
        break;
      case 'Angry':
        suggestedBot = 'Rahi';
        botDescription = 'A logical thinker to help you calm down.';
        break;
      case 'Low':
        suggestedBot = 'Ira';
        botDescription = 'An emotional buddy to lift your spirits.';
        break;
      default:
        suggestedBot = 'Ira';
        botDescription = 'An emotional buddy.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Mood',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
            'You seem to be feeling $mood. We suggest you talk to $suggestedBot: $botDescription'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AIChatScreen(
                    botName: suggestedBot,
                    botPersonality:
                        suggestedBot == 'Ira' ? 'emotional' : 'logical',
                  ),
                ),
              );
            },
            child: const Text('Chat with Suggested Bot'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7E57C2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onMoodDetermined();
            },
            child: const Text('Choose Another Bot'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7E57C2),
              side: const BorderSide(color: Color(0xFF7E57C2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              widget.onMoodDetermined();
            },
            child: const Text('Skip', style: TextStyle(color: Color(0xFF7E57C2))),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _questions[index]['question'] as String,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ...(_questions[index]['answers'] as List<String>)
                      .map((answer) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          icon: Icon(_getIconForAnswer(answer)),
                          onPressed: () => _handleAnswer(answer),
                          label: Text(answer),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF7E57C2),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForAnswer(String answer) {
    switch (answer) {
      case 'Happy':
        return Icons.sentiment_very_satisfied;
      case 'Sad':
        return Icons.sentiment_very_dissatisfied;
      case 'Angry':
        return Icons.sentiment_very_dissatisfied;
      case 'Low':
      case 'Poorly':
        return Icons.sentiment_dissatisfied;
      case 'High':
        return Icons.battery_full;
      case 'Medium':
        return Icons.battery_std;
      case 'Well':
        return Icons.nightlight_round;
      case 'Okay':
        return Icons.nightlight_round_outlined;
      case 'Not at all':
        return Icons.thumb_up;
      case 'A little':
        return Icons.thermostat;
      case 'A lot':
        return Icons.local_fire_department;
      case 'Good':
        return Icons.fastfood;
      case 'Normal':
        return Icons.fastfood_outlined;
      case 'Poor':
        return Icons.no_food;
      case 'Very':
        return Icons.directions_run;
      case 'Somewhat':
        return Icons.directions_walk;
      case 'Great':
        return Icons.fitness_center;
      case 'Not so good':
        return Icons.sick;
      case 'No':
        return Icons.check_circle;
      case 'Yes':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
