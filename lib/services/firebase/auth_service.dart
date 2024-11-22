import 'package:daytoday_ledgerbook/model/src/user_model.dart';
import 'package:daytoday_ledgerbook/services/firebase/config.dart';

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
}
