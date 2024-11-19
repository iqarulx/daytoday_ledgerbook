/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:excel/excel.dart';
import '/appsection/db/datamodel.dart';
import '/appui/alartbox.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

enum ExcelDataType { all, year, month, custom }

class ExcelDownload {
  createExcel(context, {required List<ExcelDataModel> excelData}) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    excelCell(0, 0, "Date", sheet);
    excelCell(1, 0, "Purpose", sheet);
    excelCell(2, 0, "Income", sheet);
    excelCell(3, 0, "Expance", sheet);
    excelCell(4, 0, "Description", sheet);
    for (var i = 0; i < excelData.length; i++) {
      String income =
          excelData[i].isIncome == 1 ? excelData[i].amount.toString() : "";
      String expance =
          excelData[i].isIncome == 1 ? excelData[i].amount.toString() : "";
      String date = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(excelData[i].transcationdate))
          .toString();
      excelCell(0, (i + 1), date, sheet);
      excelCell(1, (i + 1), excelData[i].name, sheet);
      excelCell(2, (i + 1), income, sheet);
      excelCell(3, (i + 1), expance, sheet);
      excelCell(3, (i + 1), excelData[i].describe, sheet);
    }
    var fileBytes = excel.save();
    var filename = await downloadpath("Day-to-Day-Expense");

    if (await checkPermissions()) {
      var file = File(filename);
      file.writeAsBytesSync(fileBytes!);
      successalertshowSnackBar(context, "Excel was Download your Phone");
    } else {
      erroralertshowSnackBar(context, "Excel was Not Download");
    }

    await checkPermissions();
  }

  excelCell(int columnIndex, int rowIndex, String value, Sheet sheet) {
    return sheet
        .cell(
          CellIndex.indexByColumnRow(
            columnIndex: columnIndex,
            rowIndex: rowIndex,
          ),
        )
        .value = TextCellValue(value);
  }

  downloadpath(String filename) {
    Directory dir = Directory('/storage/emulated/0/Download');
    String time =
        DateFormat('yyyy-MM-dd-hh-mm-a').format(DateTime.now()).toString();
    return filename = "${dir.absolute.path}/$filename-$time.xlsx";
  }

  Future<bool> checkPermissions() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      final photosStatus = await Permission.photos.status;
      final videosStatus = await Permission.videos.status;

      if (photosStatus.isGranted && videosStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      final storageStatus = await Permission.storage.status;

      if (storageStatus.isGranted) {
        return true;
      } else {
        await Permission.storage.request();
        return false;
      }
    }
  }
}
