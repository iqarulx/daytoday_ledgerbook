import 'package:daytoday_ledgerbook/model/src/entry_model.dart';
import 'package:daytoday_ledgerbook/services/firebase/screen_service.dart';

class ScreensFunctions {
  static Future<Map<String, dynamic>> getAccounts() async {
    try {
      return await ScreenService.getAccounts();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future createEntry(EntryModel model) async {
    try {
      return await ScreenService.createEntry(model);
    } catch (e) {
      throw e.toString();
    }
  }
}
