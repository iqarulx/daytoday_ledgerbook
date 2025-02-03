// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '/services/services.dart';
import '/view/view.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  Widget? _homeWidget;

  bool get isLoggedIn => _isLoggedIn;
  Widget? get homeWidget => _homeWidget;

  Future<void> checkLoginStatus() async {
    var isLogin = await Db.checkLogin();
    // var vs = await Versions.checkVersion(); // Version Status

    // if (vs["status"]) {
    if (isLogin) {
      _homeWidget = const Home();
    } else {
      _homeWidget = const Signin();
    }
    // } else {
    //   _homeWidget = Update(uD: vs["vd"]);
    // }

    _isLoggedIn = true;
    notifyListeners();
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeData? _appTheme;
  ThemeData? get appTheme => _appTheme;

  Future<void> getTheme() async {
    var theme = await Db.getTheme();
    if (theme != null) {
      if (theme == "light") {
        _appTheme = AppTheme.appTheme;
      } else if (theme == "teal") {
        _appTheme = AppTheme.tealTheme;
      } else if (theme == "lavendar") {
        _appTheme = AppTheme.lavendarTheme;
      } else if (theme == "dark") {
        _appTheme = AppTheme.darkTheme;
      }
    } else {
      _appTheme = AppTheme.appTheme;
    }
    notifyListeners();
  }

  Future<void> changeTheme(String theme) async {
    if (theme == "light") {
      _appTheme = AppTheme.appTheme;
    } else if (theme == "teal") {
      _appTheme = AppTheme.tealTheme;
    } else if (theme == "lavendar") {
      _appTheme = AppTheme.lavendarTheme;
    } else if (theme == "dark") {
      _appTheme = AppTheme.darkTheme;
    }
    await Db.setTheme(theme);
    notifyListeners();
  }
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> getLocale() async {
    var locale = await Db.getLocale();
    if (locale != null) {
      if (locale == "en") {
        _locale = const Locale('en');
      } else if (locale == 'ta') {
        _locale = const Locale('ta');
      } else if (locale == 'te') {
        _locale = const Locale('te');
      } else if (locale == 'ka') {
        _locale = const Locale('ka');
      } else if (locale == 'ml') {
        _locale = const Locale('ml');
      }
    }
    notifyListeners();
  }

  void setLocale(Locale locale) async {
    _locale = locale;
    await Db.setLocale(locale.languageCode);
    notifyListeners();
  }
}
