/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '/appconfig/appconfig.dart';
import '/appsection/homepage.dart';
import '/auth/welcome.dart';
import '/ui/appui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appsection/db/datamodel.dart';
import 'appsection/db/dbservice.dart';
import 'appsection/settings/category.dart';
import 'firebase_options.dart';

ChangeThemeApp changeThemeApp = ChangeThemeApp();

SetSateLocal sateLocal = SetSateLocal();
ChangeLanguagefun languageRef = ChangeLanguagefun();

String language = 'en';

void getlanguage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getString('lang') == null) {
    preferences.setString('lang', 'en');
  }
  language = preferences.getString('lang')!;

  languageRef.toggletab(true);
}

Future loginAuth() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getBool('login') == null) {
    preferences.setBool('login', false);
  }

  var login = preferences.getBool('login');
  return login;
}

void gettheme() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getString('theme') == null) {
    preferences.setString('theme', 'orginal');
  }
  String theme = preferences.getString('theme')!;
  changeThemeApp.toggletab(theme);
}

changeDateformat() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getString('dateformat') == null) {
    preferences.setString('dateformat', "dd-MM-yyyy");
  }
}

getdata() async {
  var userSerive = DateService();
  categoryList.clear();
  var data = await userSerive.readAllDataCategory();

  for (var element in data) {
    CategoryFormat categoryFormat = CategoryFormat();
    categoryFormat.name = element["name"];
    categoryFormat.iSincome = element["isincome"];
    categoryFormat.hide = element["hide"];
    categoryFormat.custom = element["custom"];
    categoryList.add(categoryFormat);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  getlanguage();
  gettheme();
  var login = await loginAuth();
  getdata();
  changeDateformat();
  runApp(MyApp(
    login: login,
  ));
}

class MyApp extends StatefulWidget {
  final bool? login;
  const MyApp({super.key, required this.login});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData appTheme = AppThemeUI().orginal;

  getcurrentTheme() {
    setState(() {
      if (changeThemeApp.theme.toString().toLowerCase() == "orginal") {
        appTheme = AppThemeUI().orginal;
      } else if (changeThemeApp.theme.toString().toLowerCase() == "sea") {
        appTheme = AppThemeUI().sea;
      } else if (changeThemeApp.theme.toString().toLowerCase() == "teal") {
        appTheme = AppThemeUI().teal;
      } else {
        appTheme = AppThemeUI().orginal;
      }
    });
  }

  @override
  void initState() {
    getcurrentTheme();
    changeThemeApp.addListener(themeChanger);
    super.initState();
  }

  @override
  void dispose() {
    changeThemeApp.addListener(themeChanger);
    super.dispose();
  }

  themeChanger() {
    if (mounted) {
      getcurrentTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: sateLocal.locale,
      debugShowCheckedModeBanner: false,
      title: 'My Daybook',
      theme: appTheme,
      home: widget.login! == true ? const HomePage() : const Welcome(),
    );
  }
}
