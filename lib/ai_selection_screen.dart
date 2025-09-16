import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ai_chat_screen.dart';
import 'theme.dart';
import 'auth_service.dart';
import 'wellness_zone_screen.dart'; // Import the WellnessZoneScreen

final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.system);

class AISelectionScreen extends StatefulWidget {
  const AISelectionScreen({super.key});

  @override
  State<AISelectionScreen> createState() => _AISelectionScreenState();
}

class _AISelectionScreenState extends State<AISelectionScreen> with SingleTickerProviderStateMixin {
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

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('System'),
              onTap: () {
                themeNotifier.value = ThemeMode.system;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Light'),
              onTap: () {
                themeNotifier.value = ThemeMode.light;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () {
                themeNotifier.value = ThemeMode.dark;
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            const Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                final AuthService authService = AuthService();
                await authService.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your AI Bot',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBotCard(
                context,
                'Ira',
                'Your Emotional Buddy',
                'assets/rahi_avatar.png', // Replace with actual asset path
              ),
              const SizedBox(height: 32),
              _buildBotCard(
                context,
                'Rahi',
                'Your Logical Thinker',
                'assets/rahi_avatar.png', // Replace with actual asset path
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WellnessZoneScreen(),
                    ),
                  );
                },
                child: Text(
                  'Go to Wellness Zone',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotCard(BuildContext context, String botName, String description, String imagePath) {
    return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AIChatScreen(
                  botName: botName,
                  botPersonality: botName == 'Ira' ? 'emotional' : 'logical',
                ),
              ),
            );
          },
      child: Stack(
        children: [
          // Glowing Light Effect
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
                    stops: const [0.0, 0.2, 0.4, 1.0],
                    center: Alignment.center,
                  ),
                ),
                width: 250,
                height: 250,
              );
            },
          ),
          Card(
            elevation: 8,
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: SizedBox(width: 100, height: 100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    botName,
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
