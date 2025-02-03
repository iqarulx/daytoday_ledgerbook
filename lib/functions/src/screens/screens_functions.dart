// Project imports:
import '/constants/constants.dart';
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

  static Future<List<Map<String, dynamic>>> getCurrency() async {
    try {
      return await ScreenService.getCurrency();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future updateProfile(UserModel model) async {
    try {
      await ScreenService.updateProfile(model);
      await Db.updateData(type: UserData.profileName, value: model.profileName);
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

  static Future editEntry(EntryModel model) async {
    try {
      return await ScreenService.editEntry(model);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future deleteEntry(EntryModel model) async {
    try {
      return await ScreenService.deleteEntry(model);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future createNotes(NotesModel model) async {
    try {
      return await ScreenService.createNotes(model);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future editNotes(NotesModel model) async {
    try {
      return await ScreenService.editNotes(model);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future deleteNotes(NotesModel model) async {
    try {
      return await ScreenService.deleteNotes(model);
    } catch (e) {
      throw e.toString();
    }
  }
}
