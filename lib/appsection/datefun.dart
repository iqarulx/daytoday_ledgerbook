/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'package:intl/intl.dart';

class DateFun {
  final DateTime inidate;
  DateFun({required this.inidate});

  getDailyInfo() {
    final DateFormat normalformatter = DateFormat('yyyy-MM-dd');
    final DateFormat monthformatter = DateFormat('MMMM');
    final DateFormat dayformatter = DateFormat('dd');
    final DateFormat dateformatter = DateFormat('EEEE');
    final DateFormat yearformatter = DateFormat('yyyy');
    final String date = dateformatter.format(inidate);
    final String day = dayformatter.format(inidate);
    final String month = monthformatter.format(inidate);
    final String year = yearformatter.format(inidate);
    final String normal = normalformatter.format(inidate);
    var result = {
      "date": date,
      "day": day,
      "month": month,
      "year": year,
      "normal": normal,
    };
    log(result.toString());
    return result;
  }

  getMonthlyInfo() {
    final DateTime monthFirst = DateTime(inidate.year, inidate.month, 1);
    final DateTime monthLast = DateTime(inidate.year, inidate.month + 1, 0);

    final DateFormat normalformatter = DateFormat('yyyy-MM-dd');
    final DateFormat monthformatter = DateFormat('MMMM');
    final DateFormat yearformatter = DateFormat('yyyy');
    final String month = monthformatter.format(inidate);
    final String year = yearformatter.format(inidate);
    final String normal = normalformatter.format(inidate);
    final String first = normalformatter.format(monthFirst);
    final String last = normalformatter.format(monthLast);
    var result = {
      "first": first,
      "last": last,
      "month": month,
      "normal": normal,
      "year": year,
    };
    log(result.toString());
    return result;
  }

  getYearlyInfo() {
    final DateTime monthFirst = DateTime(inidate.year, 1, 1);
    final DateTime monthLast = DateTime(inidate.year, 12, 31);
    final DateFormat normalformatter = DateFormat('yyyy-MM-dd');
    final String first = normalformatter.format(monthFirst);
    final String last = normalformatter.format(monthLast);

    var result = {
      "first": first,
      "last": last,
      "year": inidate.year,
    };
    log(result.toString());
    return result;
  }

  getdayMonthName() {
    final DateFormat monthformatter = DateFormat('dd-MMMM-yyyy');
    final String month = monthformatter.format(inidate);
    var result = month;
    return result;
  }
}
