import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData light({Color color = const Color(0xFFFE0100)}) => ThemeData(
      useMaterial3: false,
      fontFamily: AppConstants.fontFamily,
      primaryColor: color,
      secondaryHeaderColor: const Color(0xFFFE0100),
      disabledColor: const Color(0xFFBABFC4),
      brightness: Brightness.light,
      hintColor: const Color(0xFF9F9F9F),
      cardColor: const Color(0xFFffffff),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme:
          ColorScheme.light(primary: color, secondary: color).copyWith(background: const Color(0xFFFCFCFC)).copyWith(error: const Color(0xFFE84D4F)),
    );
