// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '/services/services.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorScheme),
    indicatorColor: AppColors.primaryColor,
    primaryColor: AppColors.primaryColor,
    secondaryHeaderColor: AppColors.secondaryColor,
    useMaterial3: true,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
          color: AppColors.whiteColor, fontSize: 20, fontFamily: 'Poppins'),
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xfff1f5f9),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    dividerColor: Colors.grey.shade300,
  );

  static ThemeData tealTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.tealColorScheme),
    indicatorColor: AppColors.tealPrimaryColor,
    primaryColor: AppColors.tealPrimaryColor,
    secondaryHeaderColor: AppColors.tealSecondaryColor,
    useMaterial3: true,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.tealPrimaryColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
          color: AppColors.whiteColor, fontSize: 20, fontFamily: 'Poppins'),
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xfff1f5f9),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
    ),
    scaffoldBackgroundColor: AppColors.whiteColor,
    dividerColor: Colors.grey.shade300,
  );

  static ThemeData lavendarTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lavendarColorScheme),
    indicatorColor: AppColors.lavendarPrimaryColor,
    primaryColor: AppColors.lavendarPrimaryColor,
    secondaryHeaderColor: AppColors.lavendarSecondaryColor,
    useMaterial3: true,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.lavendarPrimaryColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
          color: AppColors.whiteColor, fontSize: 20, fontFamily: 'Poppins'),
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xfff1f5f9),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
    ),
    scaffoldBackgroundColor: AppColors.whiteColor,
    dividerColor: Colors.grey.shade300,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blackColorScheme),
    indicatorColor: AppColors.blackColorScheme,
    primaryColor: AppColors.blackColorScheme,
    secondaryHeaderColor: AppColors.blackSecondaryColor,
    useMaterial3: true,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.blackColorScheme,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
          color: AppColors.whiteColor, fontSize: 20, fontFamily: 'Poppins'),
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xfff1f5f9),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
    ),
    scaffoldBackgroundColor: AppColors.whiteColor,
    dividerColor: Colors.grey.shade300,
  );
}
