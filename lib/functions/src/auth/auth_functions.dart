import '/model/model.dart';
import '/services/services.dart';

class AuthFunctions {
  static Future<String> registerAccount(UserModel model) async {
    try {
      return await AuthService.registerAccount(model);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<UserModel> checkLogin(String username, String password) async {
    try {
      var d = await AuthService.checkLogin(username, password);
      if (d.isNotEmpty) {
        if (d["status"]) {
          List<AccountModel> model = [];
          for (var i in d["accountList"]) {
            model.add(
              AccountModel(
                accountColor: i["accountColor"],
                accountId: i["accountId"],
                accountIdentification: i["accountIdentification"],
                bankDetails: i["bankDetails"],
                openingBalance: i["openingBalance"],
              ),
            );
          }

          return UserModel(
            uid: d["uid"],
            profileName: d["profileName"],
            profileImage: d["profileImage"],
            purpose: d["purpose"],
            password: "",
            username: "",
            currency: d["currency"],
            dateFormat: d["dateFormat"],
            additionalInfo: d["additionalInfo"],
            accountList: model,
          );
        }
        throw d["msg"];
      }
      throw "Something went wrong";
    } catch (e) {
      throw e.toString();
    }
  }
}
