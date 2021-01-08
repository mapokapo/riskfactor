import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme _textTheme = TextTheme(
  bodyText1: GoogleFonts.sourceSansPro(fontSize: 20.0),
  bodyText2: GoogleFonts.sourceSansPro(fontSize: 16.0),
  headline1: GoogleFonts.sourceSansPro(fontSize: 64.0),
  headline3: GoogleFonts.sourceSansPro(fontSize: 48.0),
  headline5: GoogleFonts.sourceSansPro(fontSize: 32.0),
  subtitle1: GoogleFonts.sourceSansPro(fontSize: 12.0),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFFF45656),
  primarySwatch: Colors.red,
).copyWith(
  textTheme: _textTheme.copyWith(
    bodyText1: _textTheme.bodyText1.copyWith(color: Colors.black),
    bodyText2: _textTheme.bodyText2.copyWith(color: Colors.black),
    headline1: _textTheme.headline1.copyWith(color: Colors.black),
    headline3: _textTheme.headline3.copyWith(color: Colors.black),
    headline5: _textTheme.headline5.copyWith(color: Colors.black),
    subtitle1: _textTheme.subtitle1.copyWith(color: Colors.black),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFFC0504A),
  primarySwatch: Colors.red,
  accentColor: Color(0xFFC0504A),
).copyWith(
  textTheme: _textTheme.copyWith(
    bodyText1: _textTheme.bodyText1.copyWith(color: Colors.white),
    bodyText2: _textTheme.bodyText2.copyWith(color: Colors.white),
    headline1: _textTheme.headline1.copyWith(color: Colors.white),
    headline3: _textTheme.headline3.copyWith(color: Colors.white),
    headline5: _textTheme.headline5.copyWith(color: Colors.white),
    subtitle1: _textTheme.subtitle1.copyWith(color: Colors.white),
  ),
);
