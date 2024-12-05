import '/constants/constants.dart';
import '/model/model.dart';
import '/services/services.dart';

class AuthService {
  static Config firebase = Config();

  static Future<String> registerAccount(UserModel model) async {
    try {
      var r = await firebase.users.add(model.toMap());
      return r.id;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<Map<String, dynamic>> checkLogin(
      String username, String password) async {
    try {
      var r = await firebase.users.where('username', isEqualTo: username).get();

      if (r.docs.isNotEmpty) {
        var d = r.docs.first;
        if (d.exists) {
          var data = await firebase.users.doc(d.id).get();
          if (data["password"] == password) {
            var accountList = [];

            for (var i in data["accountList"]) {
              accountList.add({
                "accountColor": i["accountColor"],
                "accountId": i["accountId"],
                "accountIdentification": i["accountIdentification"],
                "bankDetails": i["bankDetails"],
                "openingBalance": i["openingBalance"],
              });
            }

            return {
              "status": true,
              "uid": data.id,
              "profileName": data["profileName"],
              "profileImage": data["profileImage"],
              "currency": data["currency"],
              "dateFormat": data["dateFormat"],
              "purpose": data["purpose"],
              "additionalInfo": data["additionalInfo"],
              "accountList": accountList
            };
          }
          return {"status": false, "msg": "Invalid Password"};
        }
        return {"status": false, "msg": "Something went wrong"};
      }
      return {"status": false, "msg": "No accounts found"};
    } catch (e) {
      return {"status": false, "msg": e.toString()};
    }
  }

  static Future deleteAccount() async {
    try {
      var uid = await Db.getData(type: UserData.uid);

      // Account data
      var ar = await firebase.users.doc(uid).get();
      var pi = ar["profileImage"];
      await firebase.users.doc(uid).delete();

      // Delete image
      await Storage.deleteImage(pi);

      // Expense data
      var er = await firebase.expenses.where('uid', isEqualTo: uid).get();
      if (er.docs.isNotEmpty) {
        for (var i in er.docs) {
          await firebase.expenses.doc(i.id).delete();
        }
      }

      // Notes data
      var nr = await firebase.notes.where('userId', isEqualTo: uid).get();
      if (nr.docs.isNotEmpty) {
        for (var i in nr.docs) {
          await firebase.notes.doc(i.id).delete();
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<bool> checkUserName(String name) async {
    try {
      var r = await firebase.users.where('username', isEqualTo: name).get();
      if (r.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
