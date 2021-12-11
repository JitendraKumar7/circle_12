import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  fontFamily: 'Times New Roman',
  textTheme: GoogleFonts.openSansTextTheme(),
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[200],
  primaryColorDark: Colors.blue[300],
  primaryColorLight: Colors.blue[100],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue[200],
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: Colors.orange),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
    ),
  ),
);
