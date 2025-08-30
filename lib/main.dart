import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'firebase_options.dart'; // Import Firebase options
import 'login_screen.dart';
import 'signup_screen.dart';
import 'auth_service.dart'; // Import AuthService
import 'ai_chat_screen.dart'; // Import the AIChatScreen
import 'mood_tracker_screen.dart';
import 'ai_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'theme.dart';

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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Flutter Auth Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          themeMode: currentMode,
          home:
              const AuthWrapper(), // Use AuthWrapper to handle authentication state
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  User? _user;
  bool _moodTrackerCompleted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authService.user.listen((user) {
      if (mounted) {
        setState(() {
          _user = user;
          if (user == null) {
            // User logged out, reset the flag
            _moodTrackerCompleted = false;
          }
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user != null) {
      // User is logged in
      if (!_moodTrackerCompleted) {
        return MoodTrackerScreen(
          onMoodDetermined: () {
            if (mounted) {
              setState(() {
                _moodTrackerCompleted = true;
              });
            }
          },
        );
      } else {
        return const AISelectionScreen();
      }
    } else {
      // User is logged out
      return const LoginScreen();
    }
  }
}

// Removed the old HomeScreen placeholder as it's replaced by BotSelectionScreen
// class HomeScreen extends StatelessWidget { ... }
