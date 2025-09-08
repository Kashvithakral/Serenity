import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<double> _dotSizes = [8.0, 10.0, 8.0];
  final List<Color> _dotColors = [Colors.grey, Colors.blue, Colors.grey];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _dotSizes.length,
        (index) => AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: 8.0,
              height: _dotSizes[index],
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                color: _dotColors[index],
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }
}
