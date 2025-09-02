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

class _AISelectionScreenState extends State<AISelectionScreen> {
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                final AuthService _authService = AuthService();
                await _authService.signOut();
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
            onPressed: _showThemeDialog,
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
                'assets/ira_avatar.png', // Replace with actual asset path
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
                      builder: (context) => const WellnessZoneScreen(),
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
      child: Card(
        elevation: 8,
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
                child: Image.asset(imagePath, width: 100, height: 100),
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
    );
  }
}
