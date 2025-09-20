import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IraScreen extends StatefulWidget {
  const IraScreen({Key? key}) : super(key: key);

  @override
  State<IraScreen> createState() => _IraScreenState();
}

class _IraScreenState extends State<IraScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final String _apiKey = 'AIzaSyDLpLpM2EFRxIrJgYsWYjQ2D_IPsXaznys';

  @override
  void initState() {
    super.initState();
    _messages.add({
      'sender': 'bot',
      'text': 'Hey there! I\'m Ira, your emotional buddy. How are you feeling today?',
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add({'sender': 'user', 'text': userMessage});
      _scrollToBottom();
      _isLoading = true;
    });

    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': 'You are Ira, an emotional buddy. Respond to the following message with empathy and emotion: $userMessage'}
            ]
          }
        ]
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final botResponse = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        _addMessage('bot', botResponse);
      } else {
        _addMessage('bot', 'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      _addMessage('bot', 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addMessage(String sender, String text) {
    setState(() {
      _messages.add({'sender': sender, 'text': text});
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ira Chat'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Onboarding 14.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (_isLoading && index == _messages.length) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.cyan[50] : Colors.cyan[50],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'Ira is typing...',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final message = _messages[index];
                  final isUser = message['sender'] == 'user';
                  return Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blueAccent : Theme.of(context).brightness == Brightness.dark ? Colors.cyan[50] : Colors.cyan[50],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            message['text']!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onSubmitted: (text) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
