import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../color/app_colors.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorScheme),
    indicatorColor: AppColors.primaryColor,
    primaryColor: AppColors.primaryColor,
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

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorScheme),
    indicatorColor: AppColors.blackPrimaryColor,
    primaryColor: AppColors.blackPrimaryColor,
    useMaterial3: true,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.blackPrimaryColor,
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
