import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'create_note_screen.dart';
import 'open_notes_screen.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  bool _isCreateNotePressed = false;
  bool _isOpenNotesPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTapDown: (_) => setState(() => _isCreateNotePressed = true),
              onTapUp: (_) => setState(() => _isCreateNotePressed = false),
              onTapCancel: () => setState(() => _isCreateNotePressed = false),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: _isCreateNotePressed
                        ? [Colors.blue.shade200, Colors.blue.shade400]
                        : [Colors.transparent, Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateNoteScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                    side: BorderSide(width: 2, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Create Note'),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTapDown: (_) => setState(() => _isOpenNotesPressed = true),
              onTapUp: (_) => setState(() => _isOpenNotesPressed = false),
              onTapCancel: () => setState(() => _isOpenNotesPressed = false),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: _isOpenNotesPressed
                        ? [Colors.blue.shade200, Colors.blue.shade400]
                        : [Colors.transparent, Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OpenNotesScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                    side: BorderSide(width: 2, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Open Notes'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
