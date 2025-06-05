import 'package:flutter/material.dart';

final lightTheme=ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF1a1a16),
  colorScheme: ColorScheme.light(
    primary: Color.fromARGB(26,255, 255, 255,),
    secondary: Colors.white,
    surface: Colors.white30,
    onPrimary: const Color.fromARGB(179, 255, 252, 252),
  )
);



final darkTheme=ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFFFAFAFA),
  colorScheme: ColorScheme.dark(
    primary: Color.fromARGB(31,0, 0, 0),
    secondary: Colors.black,
    surface: Colors.black38,
    onPrimary: const Color.fromARGB(179, 12, 12, 12),
  )
);