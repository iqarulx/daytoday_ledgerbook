// Project imports:
import '/model/model.dart';
import '/services/services.dart';

class HomeFunctions {
  static Future<List<DailyModel>> getDaily() async {
    try {
      return await HomeService.getDaily();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<WeeklyModel>> getWeekly() async {
    try {
      return await HomeService.getWeekly();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<MonthlyModel>> getMonthly() async {
    try {
      return await HomeService.getMonthly();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<YearlyModel>> getYearly() async {
    try {
      return await HomeService.getYearly();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<DailyNotesModel>> getDailyNotes() async {
    try {
      return await HomeService.getDailyNotes();
    } catch (e) {
      throw e.toString();
    }
  }
}
