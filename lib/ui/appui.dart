/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemeUI {
  ThemeData orginal = ThemeData(
    scaffoldBackgroundColor: const Color(0xffEEEEEE),
    primaryColor: const Color(0xff6666ff),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: const Color(0xff6666ff),
      primarySwatch: const MaterialColor(
        0xff6666ff,
        {
          50: Color(0xff9999ff),
          100: Color(0xff8080ff),
          200: Color(0xff6666ff),
          300: Color(0xff4d4dff),
          400: Color(0xff3333ff),
          500: Color(0xff1a1aff),
          600: Color(0xff0000ff),
          700: Color(0xFF0000e6),
          800: Color(0xFF0000cc),
          900: Color(0xFF0000b3),
        },
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Color(0xff6666ff),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72.0,
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
      ),
      bodyLarge: TextStyle(
        color: Color(0xff6666ff),
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Color(0xff6666ff),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
  ThemeData sea = ThemeData(
    scaffoldBackgroundColor: const Color(0xffEEEEEE),
    primaryColor: Colors.blueGrey,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: Colors.blueGrey,
      primarySwatch: Colors.blueGrey,
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.blueGrey,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72.0,
      ),
      titleLarge: TextStyle(
        fontSize: 21.0,
      ),
      bodyLarge: TextStyle(
        color: Colors.blueGrey,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Colors.blueGrey,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
  ThemeData teal = ThemeData(
    scaffoldBackgroundColor: const Color(0xffEEEEEE),
    primaryColor: Colors.teal,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: Colors.teal,
      primarySwatch: Colors.teal,
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.teal,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72.0,
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
      ),
      bodyLarge: TextStyle(
        color: Colors.teal,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Colors.teal,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
