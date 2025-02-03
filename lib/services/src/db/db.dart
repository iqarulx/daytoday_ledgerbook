// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import '/constants/constants.dart';
import '/model/model.dart';

class Db {
  Db._internal();

  static final Db _instance = Db._internal();

  factory Db() {
    return _instance;
  }

  static Future<SharedPreferences> connect() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> checkLogin() async {
    var cn = await connect();
    bool? r = cn.getBool('login');
    return r ?? false;
  }

  static Future setLogin({required UserModel model}) async {
    var cn = await connect();
    cn.setString('uid', model.uid);
    cn.setString('profileImage', model.profileImage);
    cn.setString('profileName', model.profileName);
    cn.setString('currency', model.currency);
    cn.setString('dateFormat', model.dateFormat);
    cn.setBool('login', true);
    cn.setString('theme', 'light');
  }

  static Future<String?> getData({required UserData type}) async {
    var cn = await connect();
    if (type == UserData.profileName) {
      return cn.getString('profileName');
    } else if (type == UserData.uid) {
      return cn.getString('uid');
    } else if (type == UserData.profileImage) {
      return cn.getString('profileImage');
    } else if (type == UserData.dateFormat) {
      return cn.getString('dateFormat');
    } else if (type == UserData.currency) {
      return cn.getString('currency');
    }
    return null;
  }

  static Future<String> getDateFormat() async {
    var cn = await connect();
    return cn.getString('dateFormat') ?? 'yyyy-MM-dd';
  }

  static Future updateData(
      {required UserData type, required String value}) async {
    var cn = await connect();
    if (type == UserData.profileName) {
      return cn.setString('profileName', value);
    } else if (type == UserData.profileImage) {
      return cn.setString('profileImage', value);
    } else if (type == UserData.currency) {
      return cn.setString('currency', value);
    } else if (type == UserData.dateFormat) {
      return cn.setString('dateFormat', value);
    }
    return null;
  }

  static Future<String?> getTheme() async {
    var cn = await connect();
    return cn.getString('theme');
  }

  static Future setTheme(theme) async {
    var cn = await connect();
    return cn.setString('theme', theme);
  }

  static Future<String?> getLocale() async {
    var cn = await connect();
    return cn.getString('locale');
  }

  static Future setLocale(locale) async {
    var cn = await connect();
    return cn.setString('locale', locale);
  }

  static Future<bool> clearDb() async {
    var cn = await connect();
    return cn.clear();
  }
}
