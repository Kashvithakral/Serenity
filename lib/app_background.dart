import 'package:flutter/material.dart';
import 'theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Container(
          decoration: BoxDecoration(
            image: currentMode == ThemeMode.light
                ? const DecorationImage(
                    image: AssetImage('assets/Onboarding 14.png'),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: child,
        );
      },
    );
  }
}
