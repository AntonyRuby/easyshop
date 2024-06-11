import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData dark({Color color = const Color(0xFFFE0100)}) => ThemeData(
      useMaterial3: false,
      fontFamily: AppConstants.fontFamily,
      primaryColor: color,
      secondaryHeaderColor: const Color(0xFFFE0100),
      disabledColor: const Color(0xffa2a7ad),
      brightness: Brightness.dark,
      hintColor: const Color(0xFFbebebe),
      cardColor: Color.fromARGB(57, 67, 66, 66),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme:
          ColorScheme.dark(primary: color, secondary: color).copyWith(background: const Color(0xFF191A26)).copyWith(error: const Color(0xFFdd3135)),
    );
