import 'package:flutter/material.dart';
import 'package:myapp/theme.dart';
import 'package:myapp/ira_screen.dart';
import 'package:myapp/rahi_screen.dart';

class AiBotsScreen extends StatelessWidget {
  const AiBotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meet Your AI Companions',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 20),
            _buildBotCard(
              context,
              'Ira',
              'Your friendly and supportive AI companion.',
              'assets/9439729.jpg',
            ),
            SizedBox(height: 16),
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
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 4),
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
}
