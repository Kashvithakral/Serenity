import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'firebase_options.dart'; // Import Firebase options
import 'login_screen.dart';
import 'signup_screen.dart';
import 'auth_service.dart'; // Import AuthService
import 'ai_chat_screen.dart'; // Import the AIChatScreen
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(), // Use AuthWrapper to handle authentication state
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService(); // AuthService instance

    return StreamBuilder<User?>(
      stream: _authService.user,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // If the user is logged in, show the BotSelectionScreen
          if (snapshot.hasData && snapshot.data != null) {
            return const BotSelectionScreen(); // Changed from HomeScreen to BotSelectionScreen
          } else {
            // If the user is not logged in, show the LoginScreen
            return const LoginScreen();
          }
        }
        // Show a loading indicator while checking authentication state
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

// Bot Selection Screen
class BotSelectionScreen extends StatelessWidget {
  const BotSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Bot'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final AuthService _authService = AuthService();
              await _authService.signOut();
              // AuthWrapper will handle navigation back to LoginScreen
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose your AI companion:',
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 48),
              _buildBotOption(
                context: context,
                botName: 'Ira',
                botDescription: 'An emotional buddy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIChatScreen(selectedBot: 'Ira'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              _buildBotOption(
                context: context,
                botName: 'Rahi',
                botDescription: 'A logical thinker',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIChatScreen(selectedBot: 'Rahi'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotOption({
    required BuildContext context,
    required String botName,
    required String botDescription,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              botName,
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              botDescription,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Removed the old HomeScreen placeholder as it's replaced by BotSelectionScreen
// class HomeScreen extends StatelessWidget { ... }
