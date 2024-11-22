import 'package:daytoday_ledgerbook/constants/constants.dart';
import 'package:daytoday_ledgerbook/model/src/entry_model.dart';
import 'package:daytoday_ledgerbook/services/db/db.dart';
import 'package:intl/intl.dart';

import '../../model/src/daily_model.dart';
import 'config.dart';

class HomeService {
  static Config firebase = Config();

  static Future<List<DailyModel>> getDaily() async {
    try {
      List<DailyModel> list = [];
      var uid = await Db.getData(type: UserData.uid);
      var r = await firebase.expenses
          .where('uid', isEqualTo: uid)
          .orderBy('created', descending: true)
          .get();

      if (r.docs.isNotEmpty) {
        Map<String, List<EntryModel>> groupedExpenses = {};
        for (var doc in r.docs) {
          var data = doc.data();
          var createdMillis = data['created']; // Millisecond epoch value
          var createdDate = DateTime.fromMillisecondsSinceEpoch(createdMillis);
          String createdDateString =
              DateFormat('yyyy-MM-dd').format(createdDate);

          EntryModel entry = EntryModel(
              // Populate EntryModel fields with document data
              accountId: data['accountId'],
              accountIdentification: data['accountIdentification'],
              uid: data["uid"],
              type: data["type"],
              entry: data["entry"],
              description: data["description"],
              title: data["title"],
              created: DateTime.fromMillisecondsSinceEpoch(data["created"])
              // Add other fields as needed
              );

          // Add to the group
          if (!groupedExpenses.containsKey(createdDateString)) {
            groupedExpenses[createdDateString] = [];
          }
          groupedExpenses[createdDateString]!.add(entry);
        }

        // Convert grouped data to DailyModel
        groupedExpenses.forEach((date, expenses) {
          list.add(DailyModel(
            date: date,
            expense: expenses,
          ));
        });
      }

      return list;
    } catch (e) {
      throw e.toString();
    }
  }
}
