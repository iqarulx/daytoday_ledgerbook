import 'package:shared_preferences/shared_preferences.dart';

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
    }
    return null;
  }

  static Future<bool?> getRV() async {
    var cn = await connect();
    return cn.getBool('receipt_volunteer');
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
