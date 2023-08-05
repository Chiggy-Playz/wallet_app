import 'package:flutter/material.dart';
import 'package:wallet_app/widgets/custom_color.dart';

final lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blueAccent,
    textTheme: const TextTheme(
      titleSmall: TextStyle(color: Colors.grey),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(style: ButtonStyle()),
    brightness: Brightness.light,
    extensions: [lightCustomColors]);

final darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blueAccent,

    textTheme: const TextTheme(
      titleSmall: TextStyle(color: Colors.grey),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(style: ButtonStyle()),
    brightness: Brightness.dark,
    extensions: [darkCustomColors]);
