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

  static Future<List<Map<String, dynamic>>> getCurrency() async {
    try {
      var r = await firebase.currency.get();
      List<Map<String, dynamic>> re = [];
      for (var i in r.docs) {
        re.add(i.data());
      }
      return re;
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
      var v = await firebase.expenses.add(model.toMap());
      await firebase.expenses.doc(v.id).update({"uid": v.id});
    } catch (e) {
      throw e.toString();
    }
  }

  static Future editEntry(EntryModel model) async {
    try {
      await firebase.expenses.doc(model.uid).update(model.toUpdateMap());
    } catch (e) {
      throw e.toString();
    }
  }

  static Future deleteEntry(EntryModel model) async {
    try {
      await firebase.expenses.doc(model.uid).delete();
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

  static Future editNotes(NotesModel model) async {
    try {
      await firebase.notes.doc(model.uid).update(model.toUpdateMap());
    } catch (e) {
      throw e.toString();
    }
  }

  static Future deleteNotes(NotesModel model) async {
    try {
      await firebase.notes.doc(model.uid).delete();
    } catch (e) {
      throw e.toString();
    }
  }
}
