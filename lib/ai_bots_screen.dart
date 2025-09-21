import 'package:flutter/material.dart';
import 'package:myapp/theme.dart';
import 'package:myapp/ira_screen.dart';
import 'package:myapp/rahi_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AiBotsScreen extends StatelessWidget {
  const AiBotsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _showHelplineDialog(context);
        },
        child: const Icon(Icons.phone),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meet Your AI Companions',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            _buildBotCard(
              context,
              'Ira',
              'Your friendly and supportive AI companion.',
              'assets/9439729.jpg',
            ),
            const SizedBox(height: 16),
            _buildBotCard(
              context,
              'Rahi',
              'Your knowledgeable and insightful AI guide.',
              'assets/9440461.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotCard(
      BuildContext context, String name, String description, String avatarPath) {
    return GestureDetector(
      onTap: () {
        if (name == 'Ira') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IraScreen()),
          );
        } else if (name == 'Rahi') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RahiScreen()),
          );
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(avatarPath),
                radius: 25,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelplineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text('We are with you')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final Uri phoneUri = Uri.parse('tel:18008914416');
                try {
                  await launchUrl(phoneUri);
                } catch (e) {
                  print('Could not launch $phoneUri');
                }
              },
              child: const Text('Get Help'),
            ),
          ],
        ),
      ),
    );
  }
}
