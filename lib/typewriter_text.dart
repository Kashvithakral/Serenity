import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  const TypewriterText({super.key, required this.text, this.onAnimationComplete});

  final String text;
  final VoidCallback? onAnimationComplete;

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.text.length * 50),
    );
    _textAnimation = IntTween(begin: 0, end: widget.text.length).animate(_animationController);
    _animationController.forward().whenComplete(() {
      if (widget.onAnimationComplete != null) {
        widget.onAnimationComplete!();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Text(widget.text.substring(0, _textAnimation.value));
      },
    );
  }
}
