// lib/theme/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData ghibliTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF82A0D8), // Ghibli Sky Blue
    surface: const Color(0xFFE8DAB2),
    onSurface: Colors.brown.shade800,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.notoSerif(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.brown.shade800),
    bodyLarge:
        GoogleFonts.notoSerif(fontSize: 16, color: Colors.brown.shade700),
    labelLarge: GoogleFonts.notoSerif(fontWeight: FontWeight.w600),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF82A0D8),
    titleTextStyle: GoogleFonts.notoSerif(
        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  useMaterial3: true,
);
