import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'dart:math';

class WellnessZoneScreen extends StatefulWidget {
  @override
  _WellnessZoneScreenState createState() => _WellnessZoneScreenState();
}

class _WellnessZoneScreenState extends State<WellnessZoneScreen>  with SingleTickerProviderStateMixin {
  String quote = generateDailyQuote();
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(begin: Colors.purple.withOpacity(0.4), end: Colors.blue.withOpacity(0.4))
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellness Zone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: RadialGradient(
                            colors: [
                              _colorAnimation.value!,
                              Colors.blue.withOpacity(0.4),
                              Colors.green.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.3, 0.6, 1.0],
                            center: Alignment.center,
                          ),
                        ),
                        width: 320,
                        height: 170,
                      );
                    },
                  ),
                  Material(
                    elevation: 8,
                    shadowColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade600
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      color: Color(0xFFB2EBF2), // Light faded cyan
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade400,
                                    Colors.orange.shade700,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                "Quote of the day",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              quote,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _launchURL(
                        'https://open.spotify.com/playlist/4GxWjsANqWadCBmdnV08jy?si=rcYvuQnlTV-gelRD7j-nnw&pi=yWzr3GwhStKDT');
                  },
                  child: Text('Stories'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _launchURL(
                        'https://open.spotify.com/playlist/5DFZUVOZY2eNDhm65tvHdD?si=JPD3lFGATQapZuCvgBDlvg&pi=i1QiEbjtTr2cU');
                  },
                  child: Text('Songs'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch $url: $e');
    }
  }
}

String generateDailyQuote() {
  List<String> quotes = [
    "The sun sets gently, the world finds rest, in calm we breathe...",
    "In the midst of winter, I found there was, within me, an invincible summer.",
    "The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.",
    "Do not go where the path may lead, go instead where there is no path and leave a trail.",
    "Darkness cannot drive out darkness: only light can do that. Hate cannot drive out hate: only love can do that."
  ];

  // Use the current day as the seed for the random number generator
  Random random = Random(DateTime.now().day);
  int index = random.nextInt(quotes.length);
  return quotes[index];
}
