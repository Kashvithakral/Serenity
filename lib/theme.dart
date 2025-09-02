import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class AppTheme {
  static const Color primary = Color(0xFFE3F2FD); // Soft Blue
  static const Color accent = Color(0xFF42A5F5); // Saturated Blue
  static const Color secondary = Color(0xFFFCE4EC); // Pastel Pink
  static const Color offWhite = Color(0xFFF5F5F5); // Creamy Off-White

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: offWhite,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: GoogleFonts.openSans(
        fontSize: 16,
        color: Colors.black54,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey[900],
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: TextTheme(
      displayLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.openSans(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),
  );
}
