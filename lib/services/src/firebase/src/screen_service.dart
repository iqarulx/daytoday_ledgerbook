import '../../../../constants/constants.dart';
import '/model/model.dart';
import '/services/services.dart';

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

  static Future updateProfile(UserModel model) async {
    try {
      var uid = await Db.getData(type: UserData.uid);
      await firebase.users.doc(uid).update(model.toUpdateMap());
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

  static Future createNotes(NotesModel model) async {
    try {
      var v = await firebase.notes.add(model.toMap());
      await firebase.notes.doc(v.id).update({"uid": v.id});
    } catch (e) {
      throw e.toString();
    }
  }
}
