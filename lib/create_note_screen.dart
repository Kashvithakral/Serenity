import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CreateNoteScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final Function(Map<String, dynamic>)? onNoteUpdated;

  CreateNoteScreen({this.initialTitle, this.initialDescription, this.onNoteUpdated});

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }

  Future<void> _saveNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String title = _titleController.text;
    String description = _descriptionController.text;
    String timestamp = DateTime.now().toString();
    String noteId = 'note_$timestamp';
    String updatedOn = DateTime.now().toString();

    Map<String, dynamic> note = {
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'updatedOn': updatedOn,
    };

    String noteJson = jsonEncode(note);
    await prefs.setString(noteId, noteJson);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note Saved'),
      ),
    );

    if (widget.onNoteUpdated != null) {
      widget.onNoteUpdated!(note);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
