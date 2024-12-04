import 'package:intl/intl.dart';

import '/constants/constants.dart';
import '/model/model.dart';
import '/services/services.dart';

class HomeService {
  static Config firebase = Config();

  static Future<List<DailyModel>> getDaily() async {
    try {
      List<DailyModel> list = [];
      var uid = await Db.getData(type: UserData.uid);
      var r = await firebase.expenses
          .where('userId', isEqualTo: uid)
          .orderBy('created', descending: true)
          .get();

      if (r.docs.isNotEmpty) {
        Map<String, List<EntryModel>> groupedExpenses = {};

        for (var doc in r.docs) {
          var data = doc.data();
          var createdMillis = data['created'];
          var createdDate = DateTime.fromMillisecondsSinceEpoch(createdMillis);
          var df = await Db.getDateFormat();
          String createdDateString = DateFormat(df).format(createdDate);

          EntryModel entry = EntryModel(
            accountId: data['accountId'],
            accountIdentification: data['accountIdentification'],
            uid: data["uid"],
            userId: data["userId"],
            type: data["type"], // 1 = Credit, 2 = Debit
            entry: data["entry"],
            description: data["description"],
            title: data["title"],
            created: DateTime.fromMillisecondsSinceEpoch(data["created"]),
          );

          if (!groupedExpenses.containsKey(createdDateString)) {
            groupedExpenses[createdDateString] = [];
          }
          groupedExpenses[createdDateString]!.add(entry);
        }

        groupedExpenses.forEach((date, expenses) {
          // Calculate totals
          double totalCredit = expenses
              .where((e) => e.type == 1) // Filter credit entries
              .fold(0.0, (sum, e) => sum + e.entry);

          double totalDebit = expenses
              .where((e) => e.type == 2) // Filter debit entries
              .fold(0.0, (sum, e) => sum + e.entry);

          // Calculate balance
          double balance = totalCredit - totalDebit;

          list.add(DailyModel(
            date: date,
            expense: expenses,
            totalCredit: totalCredit.toStringAsFixed(2), // Convert to String
            totalDebit: totalDebit.toStringAsFixed(2), // Convert to String
            balance: balance.toStringAsFixed(2), // Convert to String
          ));
        });
      }

      return list;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<WeeklyModel>> getWeekly() async {
    try {
      List<WeeklyModel> list = [];
      var uid = await Db.getData(type: UserData.uid);

      // Calculate date range: today and 7 days ago
      DateTime now = DateTime.now();
      DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Format dates for return
      var df = await Db.getDateFormat();
      String fromDate = DateFormat(df).format(sevenDaysAgo);
      String toDate = DateFormat(df).format(now);

      // Fetch expenses within the date range
      var r = await firebase.expenses
          .where('userId', isEqualTo: uid)
          .where('created',
              isGreaterThanOrEqualTo: sevenDaysAgo.millisecondsSinceEpoch)
          .where('created', isLessThanOrEqualTo: now.millisecondsSinceEpoch)
          .orderBy('created', descending: true)
          .get();

      if (r.docs.isNotEmpty) {
        List<EntryModel> weeklyExpenses = [];
        for (var doc in r.docs) {
          var data = doc.data();
          EntryModel entry = EntryModel(
            accountId: data['accountId'],
            accountIdentification: data['accountIdentification'],
            uid: data["uid"],
            userId: data["userId"],
            type: data["type"], // 1 = Credit, 2 = Debit
            entry: data["entry"],
            description: data["description"],
            title: data["title"],
            created: DateTime.fromMillisecondsSinceEpoch(data["created"]),
          );
          weeklyExpenses.add(entry);
        }

        // Calculate totals for the week
        double totalCredit = weeklyExpenses
            .where((e) => e.type == 1) // Filter credit entries
            .fold(0.0, (sum, e) => sum + e.entry);

        double totalDebit = weeklyExpenses
            .where((e) => e.type == 2) // Filter debit entries
            .fold(0.0, (sum, e) => sum + e.entry);

        double balance = totalCredit - totalDebit;

        // Add the weekly data to the list
        list.add(WeeklyModel(
          fromDate: fromDate,
          toDate: toDate,
          expense: weeklyExpenses,
          totalCredit: totalCredit.toStringAsFixed(2), // Convert to String
          totalDebit: totalDebit.toStringAsFixed(2), // Convert to String
          balance: balance.toStringAsFixed(2), // Convert to String
        ));
      }

      return list;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<MonthlyModel>> getMonthly() async {
    try {
      List<MonthlyModel> list = [];
      var uid = await Db.getData(type: UserData.uid);

      // Calculate date range: today and 7 days ago
      DateTime now = DateTime.now();
      DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));

      var df = await Db.getDateFormat();
      String fromDate = DateFormat(df).format(thirtyDaysAgo);
      String toDate = DateFormat(df).format(now);

      // Fetch expenses within the date range
      var r = await firebase.expenses
          .where('userId', isEqualTo: uid)
          .where('created',
              isGreaterThanOrEqualTo: thirtyDaysAgo.millisecondsSinceEpoch)
          .where('created', isLessThanOrEqualTo: now.millisecondsSinceEpoch)
          .orderBy('created', descending: true)
          .get();

      if (r.docs.isNotEmpty) {
        List<EntryModel> monthlyExpenses = [];
        for (var doc in r.docs) {
          var data = doc.data();
          EntryModel entry = EntryModel(
            accountId: data['accountId'],
            accountIdentification: data['accountIdentification'],
            uid: data["uid"],
            userId: data["userId"],
            type: data["type"], // 1 = Credit, 2 = Debit
            entry: data["entry"],
            description: data["description"],
            title: data["title"],
            created: DateTime.fromMillisecondsSinceEpoch(data["created"]),
          );
          monthlyExpenses.add(entry);
        }

        // Calculate totals for the week
        double totalCredit = monthlyExpenses
            .where((e) => e.type == 1) // Filter credit entries
            .fold(0.0, (sum, e) => sum + e.entry);

        double totalDebit = monthlyExpenses
            .where((e) => e.type == 2) // Filter debit entries
            .fold(0.0, (sum, e) => sum + e.entry);

        double balance = totalCredit - totalDebit;

        // Add the weekly data to the list
        list.add(MonthlyModel(
          fromDate: fromDate,
          toDate: toDate,
          expense: monthlyExpenses,
          totalCredit: totalCredit.toStringAsFixed(2), // Convert to String
          totalDebit: totalDebit.toStringAsFixed(2), // Convert to String
          balance: balance.toStringAsFixed(2), // Convert to String
        ));
      }

      return list;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<YearlyModel>> getYearly() async {
    try {
      List<YearlyModel> list = [];
      var uid = await Db.getData(type: UserData.uid);

      // Calculate date range: today and 7 days ago
      DateTime now = DateTime.now();
      DateTime yearAgo = now.subtract(const Duration(days: 365));

      var df = await Db.getDateFormat();
      String fromDate = DateFormat(df).format(yearAgo);
      String toDate = DateFormat(df).format(now);

      // Fetch expenses within the date range
      var r = await firebase.expenses
          .where('userId', isEqualTo: uid)
          .where('created',
              isGreaterThanOrEqualTo: yearAgo.millisecondsSinceEpoch)
          .where('created', isLessThanOrEqualTo: now.millisecondsSinceEpoch)
          .orderBy('created', descending: true)
          .get();

      if (r.docs.isNotEmpty) {
        List<EntryModel> yearlyExpenses = [];
        for (var doc in r.docs) {
          var data = doc.data();
          EntryModel entry = EntryModel(
            accountId: data['accountId'],
            accountIdentification: data['accountIdentification'],
            uid: data["uid"],
            userId: data["userId"],
            type: data["type"], // 1 = Credit, 2 = Debit
            entry: data["entry"],
            description: data["description"],
            title: data["title"],
            created: DateTime.fromMillisecondsSinceEpoch(data["created"]),
          );
          yearlyExpenses.add(entry);
        }

        // Calculate totals for the week
        double totalCredit = yearlyExpenses
            .where((e) => e.type == 1) // Filter credit entries
            .fold(0.0, (sum, e) => sum + e.entry);

        double totalDebit = yearlyExpenses
            .where((e) => e.type == 2) // Filter debit entries
            .fold(0.0, (sum, e) => sum + e.entry);

        double balance = totalCredit - totalDebit;

        // Add the weekly data to the list
        list.add(YearlyModel(
          fromDate: fromDate,
          toDate: toDate,
          expense: yearlyExpenses,
          totalCredit: totalCredit.toStringAsFixed(2), // Convert to String
          totalDebit: totalDebit.toStringAsFixed(2), // Convert to String
          balance: balance.toStringAsFixed(2), // Convert to String
        ));
      }

      return list;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<DailyNotesModel>> getDailyNotes() async {
    try {
      List<DailyNotesModel> list = [];
      var userId = await Db.getData(type: UserData.uid);
      var r = await firebase.notes
          .where('userId', isEqualTo: userId)
          .orderBy('created', descending: true)
          .get();

      if (r.docs.isNotEmpty) {
        Map<String, List<NotesModel>> groupedExpenses = {};

        for (var doc in r.docs) {
          var data = doc.data();
          var createdMillis = data['created'];
          var createdDate = DateTime.fromMillisecondsSinceEpoch(createdMillis);
          var df = await Db.getDateFormat();
          String createdDateString = DateFormat(df).format(createdDate);

          NotesModel entry = NotesModel(
            userId: data['userId'],
            uid: data["uid"],
            notes: data['notes'],
            date: DateTime.fromMillisecondsSinceEpoch(data["date"]),
            created: DateTime.fromMillisecondsSinceEpoch(data["created"]),
          );

          if (!groupedExpenses.containsKey(createdDateString)) {
            groupedExpenses[createdDateString] = [];
          }
          groupedExpenses[createdDateString]!.add(entry);
        }

        groupedExpenses.forEach((date, expenses) {
          list.add(DailyNotesModel(
            date: date,
            notesList: expenses,
          ));
        });
      }

      return list;
    } catch (e) {
      throw e.toString();
    }
  }
}
