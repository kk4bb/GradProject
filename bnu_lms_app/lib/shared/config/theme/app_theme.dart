import 'package:flutter/material.dart';

import '../../resources/colors_manager.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: ColorsManager.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.lightBackground,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorsManager.white,

      selectedItemColor: ColorsManager.blue,
       // unselectedItemColor: ColorsManager.textSecondary,
    ),
    // iconTheme: const IconThemeData(
    // color: ColorsManager.white
    // ),
    iconTheme: const IconThemeData(
        color: ColorsManager.blue
    ),
  );

  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: ColorsManager.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.darkBackground,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorsManager.darkBackground,
      selectedItemColor: ColorsManager.blue,
       unselectedItemColor: ColorsManager.white,
    ),
    iconTheme: const IconThemeData(
        color: ColorsManager.blue
    ),
  );
}