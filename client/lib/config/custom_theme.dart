import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color customColorSeed = Color(0xFFCF6679);

const ColorScheme lightColorScheme = ColorScheme(
  primary: Color(0xFF6200EE),
  secondary: Color(0xFF03DAC6),
  surface: Color(0xFFFFFFFF),
  background: Color(0xFFFFFFFF),
  error: Color(0xFFB00020),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF000000),
  onSurface: Color(0xFF000000),
  onBackground: Color(0xFF000000),
  onError: Color(0xFFFFFFFF),
  brightness: Brightness.light,
);

const ColorScheme darkColorScheme = ColorScheme(
  primary: Color(0xFFBB86FC),
  secondary: Color(0xFF03DAC6),
  surface: Color(0xFF121212),
  background: Color(0xFF121212),
  error: Color(0xFFCF6679),
  onPrimary: Color(0xFF000000),
  onSecondary: Color(0xFF000000),
  onSurface: Color(0xFFFFFFFF),
  onBackground: Color(0xFFFFFFFF),
  onError: Color(0xFFFFFFFF),
  brightness: Brightness.dark,
);

InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(width: 1, color: colorScheme.primary),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
  );
}

final ThemeData lightThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
  inputDecorationTheme: inputDecorationTheme(lightColorScheme),
);

final ThemeData darkThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  brightness: Brightness.dark,
  textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
  inputDecorationTheme: inputDecorationTheme(darkColorScheme),
);
