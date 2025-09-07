import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'auth_service.dart';
import 'ai_chat_screen.dart';
import 'mood_tracker_screen.dart';
import 'ai_selection_screen.dart' hide themeNotifier;
import 'ai_bots_screen.dart';
import 'wellness_zone_screen.dart';
import 'journal_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

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
        return const MainScreen();
      }
    } else {
      return const LoginScreen();
    }
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = [
    AiBotsScreen(),
    WellnessZoneScreen(),
    JournalScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.android),
            label: 'AI Bots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wellness Zone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Journal',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
