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
import 'care_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_background.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
            scaffoldBackgroundColor: Colors.transparent,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          themeMode: currentMode,
          home: AppBackground(child: AuthWrapper()),
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


// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';
// import 'login_screen.dart';
// import 'signup_screen.dart';
// import 'auth_service.dart';
// import 'ai_chat_screen.dart';
// import 'mood_tracker_screen.dart';
// import 'ai_selection_screen.dart' hide themeNotifier;
// import 'ai_bots_screen.dart';
// import 'wellness_zone_screen.dart';
// import 'journal_screen.dart';
// import 'care_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'theme.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'splash_screen.dart';
// import 'app_background.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();

  static List<Widget> _widgetOptions = [
    const AiBotsScreen(),
    const WellnessZoneScreen(),
    JournalScreen(),
    const CareScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showHelplineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          content: const Text(
            'You are not alone.',
            style: TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Get Help',
                    style: TextStyle(fontSize: 16, color: Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _launchHelpline();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _launchHelpline() async {
    const String phoneNumber = '18008914416';
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      await url_launcher.launchUrl(phoneUri);
    } catch (error) {
      print("Can't dial the number!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serenity'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String item) async {
              if (item == 'Theme') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Select Theme'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: const Text('System Default'),
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
                        ],
                      ),
                    );
                  },
                );
              } else if (item == 'Logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SeeYouSoonScreen()),
                );
                await Future.delayed(const Duration(seconds: 2));
                await _authService.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Theme',
                  child: Text('Theme'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Select Theme'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: const Text('System Default'),
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
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SeeYouSoonScreen()),
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    await _authService.signOut();
                  },
                ),
              ];
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? null
            : Colors.transparent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.android), label: 'AI Bots'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wellness Zone',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Journal'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Gaming',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class SeeYouSoonScreen extends StatefulWidget {
  const SeeYouSoonScreen({Key? key}) : super(key: key);

  @override
  State<SeeYouSoonScreen> createState() => _SeeYouSoonScreenState();
}

class _SeeYouSoonScreenState extends State<SeeYouSoonScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Onboarding 14.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            'See you soon!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
