import 'package:flutter/material.dart';

const nightPrimaryColor = Color(0xff3A3A3B);

ThemeData _withCommonTheme(ThemeData themeData, [bool night = false]) {
  final colorScheme = themeData.colorScheme.copyWith(
    onPrimary: night ? Color(0xffBFBFBF) : Colors.white,
    surface: night ? nightPrimaryColor : Colors.white,
  );

  final textTheme = themeData.textTheme.apply(
    bodyColor: Color(night ? 0xffBFBFBF : 0xff323232),
    displayColor: Color(night ? 0xffBFBFBF : 0xff323232)
  ).copyWith(
    button: TextStyle(color: themeData.primaryColor),
  );
  
  return themeData.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    splashFactory: InkRipple.splashFactory,
    brightness: themeData.brightness ?? Brightness.light,
    backgroundColor: night ? Color(0xff252526) : Colors.white,
    cardColor: colorScheme.surface,
    colorScheme: colorScheme,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: themeData.primaryColorLight,
      cursorColor: themeData.accentColor,
      selectionHandleColor: themeData.accentColor,
    ),
    textTheme: textTheme,
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(themeData.accentColor.withOpacity(0.2)),
      foregroundColor: MaterialStateProperty.all(themeData.accentColor)
    )),
  );
}

ThemeData _theme(MaterialColor color) => _withCommonTheme(ThemeData(primarySwatch: color));

final nightTheme = _withCommonTheme(ThemeData(
  primaryColor: nightPrimaryColor,
  accentColor: Color(0xff0DBC79),
  primaryColorDark: Color(0xff076642),
  primaryColorLight: Color(0xff0B9560),
  scaffoldBackgroundColor: Color(0xff252526),
  dividerColor: Color(0xff626262),
  hintColor: Color(0xffD0D0D0),
  disabledColor: Color(0xff797979),
  brightness: Brightness.dark
), true);

final Map<String, ThemeData> themes = {
  'green': _theme(Colors.green),
  'pink': _theme(Colors.pink),
  'indigo': _theme(Colors.indigo),
  'orange': _theme(Colors.orange),
  'blue': _theme(Colors.blue),
  'deepPurple': _theme(Colors.deepPurple),
  'teal': _theme(Colors.teal),
  'night': nightTheme
};