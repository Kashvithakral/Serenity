import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WellnessZoneScreen extends StatefulWidget {
  const WellnessZoneScreen({Key? key}) : super(key: key);

  @override
  State<WellnessZoneScreen> createState() => _WellnessZoneScreenState();
}

class _WellnessZoneScreenState extends State<WellnessZoneScreen> {
  String? _quote;
  String? _poem;
  String? _story;
  bool _isLoading = true;
  String? _errorMessage;

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final prefs = await SharedPreferences.getInstance();
    _quote = prefs.getString('quote');
    _poem = prefs.getString('poem');
    _story = prefs.getString('story');

    if (_quote == null || _poem == null || _story == null) {
      await _fetchData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchData() async {
    _quote = await _fetchGeminiContent('3 line motivational quote');
    _poem = await _fetchGeminiContent('5 to 8 line motivational poem');
    _story = await _fetchGeminiContent('10 to 12 line motivational story');
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _saveData();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quote', _quote ?? '');
    await prefs.setString('poem', _poem ?? '');
    await prefs.setString('story', _story ?? '');
  }

  Future<String?> _fetchGeminiContent(String prompt) async {
    await dotenv.load();
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      setState(() {
        _errorMessage = 'GEMINI_API_KEY not found in .env file';
        _isLoading = false;
      });
      return null;
    }
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': 'Respond to the following prompt: $prompt'}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        return content;
      } else {
        setState(() {
          _errorMessage = 'Failed to load content. Please try again later.';
          _isLoading = false;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please check your internet connection and try again.';
        _isLoading = false;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Motivational Quote',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _quote ?? 'Loading...',
                    style: GoogleFonts.openSans(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => _speak(_quote ?? ''),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Motivational Poem',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _poem ?? 'Loading...',
                    style: GoogleFonts.openSans(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => _speak(_poem ?? ''),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Motivational Story',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _story ?? 'Loading...',
                    style: GoogleFonts.openSans(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => _speak(_story ?? ''),
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

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }
}
