import 'dart:typed_data';
import 'package:excel/excel.dart';
import '/constants/constants.dart';
import '/model/model.dart';

class XlsExport {
  final ExportType type;
  final List<DailyModel>? daily;
  final List<WeeklyModel>? weekly;
  final List<MonthlyModel>? monthly;
  final List<YearlyModel>? yearly;
  XlsExport({
    required this.type,
    this.daily,
    this.weekly,
    this.monthly,
    this.yearly,
  });

  static var excel = Excel.createExcel();
  static var sheet = excel['Sheet1'];

  Future<Uint8List> dailyExcel() async {
    int rowIndex = 0;

    for (var i in daily!) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = TextCellValue(i.date);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = TextCellValue("");
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = TextCellValue("Balance");
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = TextCellValue(i.balance);
      rowIndex++;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = TextCellValue("S.No");
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = TextCellValue("Account");
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = TextCellValue("Credit");
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = TextCellValue("Debit");

      rowIndex++;

      for (var j = 0; j < i.expense.length; j++) {
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue((j + 1).toString()); // S.No starts at 1
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(i.expense[j].accountIdentification);
        sheet
                .cell(CellIndex.indexByColumnRow(
                    columnIndex: 2, rowIndex: rowIndex))
                .value =
            TextCellValue(
                i.expense[j].type == 1 ? i.expense[j].entry.toString() : "-");
        sheet
                .cell(CellIndex.indexByColumnRow(
                    columnIndex: 3, rowIndex: rowIndex))
                .value =
            TextCellValue(
                i.expense[j].type == 2 ? i.expense[j].entry.toString() : "-");
        rowIndex++;
      }
      rowIndex++;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = TextCellValue("");
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = TextCellValue("");
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = TextCellValue(i.totalCredit);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = TextCellValue(i.totalDebit);
      rowIndex++;
    }

    var savedData = excel.save();

    return Uint8List.fromList(savedData!);
  }
}
