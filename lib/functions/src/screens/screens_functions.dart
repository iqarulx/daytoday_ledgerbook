import '/model/model.dart';
import '/services/services.dart';

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
