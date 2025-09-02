import 'package:flutter/material.dart';
import 'ai_selection_screen.dart';
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
        title: const Text('Your Mood'),
        content: Text('You seem to be feeling $mood. We suggest you talk to $suggestedBot: $botDescription'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AIChatScreen(
                    botName: suggestedBot,
                    botPersonality: suggestedBot == 'Ira' ? 'emotional' : 'logical',
                  ),
                ),
              );
            },
            child: const Text('Chat with Suggested Bot'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onMoodDetermined();
            },
            child: const Text('Choose Another Bot'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              widget.onMoodDetermined();
            },
            child: const Text('Skip'),
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
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ...(_questions[index]['answers'] as List<String>).map((answer) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _handleAnswer(answer),
                        child: Text(answer),
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
}
