import 'package:daytoday_ledgerbook/constants/constants.dart';
import 'package:daytoday_ledgerbook/model/src/entry_model.dart';
import 'package:daytoday_ledgerbook/services/db/db.dart';

import 'config.dart';

class ScreenService {
  static Config firebase = Config();

  static Future<Map<String, dynamic>> getAccounts() async {
    try {
      var uid = await Db.getData(type: UserData.uid);
      var r = await firebase.users.doc(uid).get();
      return r.data() ?? {};
    } catch (e) {
      throw e.toString();
    }
  }

  static Future createEntry(EntryModel model) async {
    try {
      await firebase.expenses.add(model.toMap());
    } catch (e) {
      throw e.toString();
    }
  }
}
