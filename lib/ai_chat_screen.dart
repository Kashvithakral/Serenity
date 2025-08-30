import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_service.dart';
import 'theme.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // For jsonEncode and jsonDecode

// Placeholder for the AI Chat Screen
class AIChatScreen extends StatefulWidget {
  final String selectedBot; // To know which bot was selected (Ira or Rahi)

  const AIChatScreen({super.key, required this.selectedBot});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _chatMessages = []; // To store chat messages
  final String _apiKey = 'AIzaSyDLpLpM2EFRxIrJgYsWYjQ2D_IPsXaznys'.trim(); // Gemini API Key

  @override
  void initState() {
    super.initState();
    // Bot introduces itself
    _chatMessages.add('Hello! I am ${widget.selectedBot}. How can I help you today?');
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _chatMessages.add('You: $message');
      });
      _messageController.clear();

      String botResponse = '';
      String systemPrompt = '';

      // Construct system prompt based on selected bot
      if (widget.selectedBot == 'Ira') { // Emotional bot
        systemPrompt = "You are Ira, an emotional buddy. Respond to the user's message in an empathetic and friendly way, showing understanding and care.";
      } else { // Rahi, Logical bot
        systemPrompt = "You are Rahi, a logical thinker. Respond to the user's message in a concise, analytical, and fact-based manner.";
      }

      int retries = 0;
      while (retries < 3) {
        try {
          final response = await http.post(
            Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': systemPrompt},
                    {'text': message}
                  ]
                }
              ]
            }),
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            if (responseData['candidates'] != null &&
                responseData['candidates'].isNotEmpty &&
                responseData['candidates'][0]['content'] != null &&
                responseData['candidates'][0]['content']['parts'] != null &&
                responseData['candidates'][0]['content']['parts'].isNotEmpty) {
              botResponse = responseData['candidates'][0]['content']['parts'][0]['text'];
              break; // Exit loop on success
            } else {
              botResponse = 'Sorry, I could not generate a response.';
            }
          } else if (response.statusCode == 429) {
            // Handle rate limit error with backoff
            retries++;
            if (retries < 3) {
              await Future.delayed(Duration(seconds: 2 * retries)); // Exponential backoff
            } else {
              botResponse = 'Error: Too many requests. Please wait a while before trying again.';
            }
          } else {
            botResponse = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
            break; // Exit loop on other errors
          }
        } catch (e) {
          botResponse = 'An error occurred: $e';
          break; // Exit loop on exception
        }
      }

      setState(() {
        _chatMessages.add('${widget.selectedBot}: $botResponse');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedBot} Chat'),
        backgroundColor: widget.selectedBot == 'Ira'
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final message = _chatMessages[index];
                final isUserMessage = message.startsWith('You: ');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUserMessage
                            ? Theme.of(context).primaryColor.withOpacity(0.2)
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.cyan.withOpacity(0.8)
                                : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message.replaceFirst(isUserMessage ? 'You: ' : '${widget.selectedBot}: ', ''), // Remove prefix for display
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      filled: true,
                      fillColor: Theme.of(context).canvasColor.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppTheme.accent,
                          width: 2,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(), // Send on enter/submit
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: AppTheme.accent,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
