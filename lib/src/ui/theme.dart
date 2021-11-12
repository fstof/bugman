import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get themeData {
  return ThemeData(
    colorScheme: ColorScheme(
      primary: Colors.yellow,
      primaryVariant: Colors.yellow[700]!,
      secondary: Colors.yellow[900]!,
      secondaryVariant: Colors.yellow[900]!,
      surface: Colors.yellow[50]!,
      background: Colors.yellow[50]!,
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    // textTheme: GoogleFonts.fredokaOneTextTheme(),
    textTheme: GoogleFonts.fascinateTextTheme(),
    scaffoldBackgroundColor: Colors.yellow[50]!,
  );
}
