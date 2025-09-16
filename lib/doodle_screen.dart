import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DoodleScreen extends StatefulWidget {
  @override
  _DoodleScreenState createState() => _DoodleScreenState();
}

class _DoodleScreenState extends State<DoodleScreen> {
  List<Offset?> _points = <Offset?>[];
  double _brushThickness = 5.0;
  double _eraseSize = 5.0;
  bool _isErasing = false;
  bool _isFilling = false;
  Color _selectedColor = Colors.black;

  void _showBrushThicknessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Brush Thickness"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Thin"),
                  onTap: () {
                    setState(() {
                      _brushThickness = 3.0;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Medium"),
                  onTap: () {
                    setState(() {
                      _brushThickness = 5.0;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Thick"),
                  onTap: () {
                    setState(() {
                      _brushThickness = 7.0;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEraseSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Erase Size"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Small"),
                  onTap: () {
                    setState(() {
                      _eraseSize = 3.0;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Medium"),
                  onTap: () {
                    setState(() {
                      _eraseSize = 5.0;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Large"),
                  onTap: () {
                    setState(() {
                      _eraseSize = 7.0;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doodle Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  if (_isErasing) {
                    _points.removeWhere((point) => point != null && (details.localPosition - point).distance < _eraseSize);
                  } else {
                    _points = List.from(_points)..add(details.localPosition);
                  }
                });
              },
              onPanStart: (details) {
                setState(() {
                  if (_isErasing) {
                    _points.removeWhere((point) => point != null && (details.localPosition - point).distance < _eraseSize);
                  } else {
                    _points = List.from(_points)..add(details.localPosition);
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  if (!_isErasing) {
                    _points = List.from(_points)..add(null);
                  }
                });
              },
              child: Container(
                color: Colors.white,
                child: CustomPaint(
                  painter: DoodlePainter(points: _points, brushThickness: _brushThickness, erase: _isErasing, eraseSize: _eraseSize, selectedColor: _selectedColor),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Brush Tool
                IconButton(
                  icon: Icon(Icons.brush),
                  onPressed: () {
                    _showBrushThicknessDialog(context);
                    setState(() {
                      _isErasing = false;
                    });
                  },
                ),
                // Erase Tool
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showEraseSizeDialog(context);
                    setState(() {
                      _isErasing = true;
                    });
                  },
                ),
                // Fill Tool
                IconButton(
                  icon: Icon(Icons.format_color_fill),
                  onPressed: () {
                    setState(() {
                      _isFilling = true;
                    });
                  },
                ),
                // Color Options
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = Colors.red;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.red,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = Colors.green;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.green,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = Colors.blue;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = Colors.black;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                  color: Colors.black,
                ),
                ),
                // Color Palette
                IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: () {
                    _showColorPickerDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() => _selectedColor = color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DoodlePainter extends CustomPainter {
  DoodlePainter({required this.points, required this.brushThickness, this.erase = false, required this.eraseSize, required this.selectedColor});

  final List<Offset?> points;
  final double brushThickness;
  final double eraseSize;
  final bool erase;
  final Color selectedColor;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = erase ? Colors.white : selectedColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = erase ? eraseSize : brushThickness;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DoodlePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.brushThickness != brushThickness ||
        oldDelegate.erase != erase ||
        oldDelegate.eraseSize != eraseSize ||
        oldDelegate.selectedColor != selectedColor;
  }
}
