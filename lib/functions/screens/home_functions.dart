import 'package:daytoday_ledgerbook/model/src/daily_model.dart';
import 'package:daytoday_ledgerbook/services/firebase/home_service.dart';

class HomeFunctions {
  static Future<List<DailyModel>> getDaily() async {
    try {
      return await HomeService.getDaily();
    } catch (e) {
      throw e.toString();
    }
  }
}
