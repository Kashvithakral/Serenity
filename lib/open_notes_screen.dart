import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'create_note_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OpenNotesScreen extends StatefulWidget {
  const OpenNotesScreen({super.key});

  @override
  _OpenNotesScreenState createState() => _OpenNotesScreenState();
}

class _OpenNotesScreenState extends State<OpenNotesScreen> {
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> notes = [];
    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      if (key.startsWith('note_')) {
        String? noteJson = prefs.getString(key);
        if (noteJson != null && noteJson.startsWith('{')) {
          try {
            Map<String, dynamic> note = jsonDecode(noteJson);
            notes.add(note);
          } catch (e) {
            print('Error decoding note: $e');
          }
        }
      }
    }

    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Notes'),
      ),
      body: _notes.isEmpty
          ? Center(child: Text('No notes saved yet.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> note = _notes[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note['title'],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          note['description'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Created: ${note['timestamp']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Updated: ${note['updatedOn'] ?? 'Not updated yet'}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _editNote(context, note);
                              },
                              child: Text('Edit Note'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteNote(note);
                              },
                              child: Text('Delete Note'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _editNote(BuildContext context, Map<String, dynamic> note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNoteScreen(
          initialTitle: note['title'],
          initialDescription: note['description'],
          onNoteUpdated: (updatedNote) {
            _updateNote(note['timestamp'], updatedNote, context);
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Note Updated'),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _updateNote(String timestamp, Map<String, dynamic> updatedNote, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String noteId = 'note_$timestamp';

    String title = updatedNote['title'];
    String description = updatedNote['description'];
    String updatedOn = DateTime.now().toString();

    Map<String, dynamic> newNote = {
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'updatedOn': updatedOn,
    };

    String noteJson = jsonEncode(newNote);
    await prefs.setString(noteId, noteJson);
     ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Note Updated'),
              ),
            );
    _loadNotes();
  }


  Future<void> _deleteNote(Map<String, dynamic> note) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
    String noteId = 'note_${note['timestamp']}';
    await prefs.remove(noteId);
    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Note Deleted'),
              ),
            );
    _loadNotes();
  }
}
