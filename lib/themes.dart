import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: const TextTheme(
    titleSmall: TextStyle(color: Colors.grey),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(style: ButtonStyle()),
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  textTheme: const TextTheme(
    titleSmall: TextStyle(color: Colors.grey),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(style: ButtonStyle()),
  brightness: Brightness.dark,
);