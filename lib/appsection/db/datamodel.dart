/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

class TranscationModel {
  String? name;
  double? amount;
  String? describe;
  String? transcationdate;
  int? isIncome;
  String? category;
  int? uid;
  int? aid;

  dataMap() {
    var mapping = <String, dynamic>{};
    mapping['name'] = name;
    mapping['amount'] = amount;
    mapping['describe'] = describe;
    mapping['transcationdate'] = transcationdate;
    mapping['isincome'] = isIncome;
    mapping['category'] = category;
    mapping['uid'] = uid;
    mapping['aid'] = aid;
    return mapping;
  }
}

class ExcelDataModel {
  final String name;
  final double amount;
  final String describe;
  final String transcationdate;
  final int isIncome;

  ExcelDataModel({
    required this.name,
    required this.amount,
    required this.describe,
    required this.transcationdate,
    required this.isIncome,
  });
}

class NoteModel {
  String? notetodo;
  String? transcationdate;
  dataMap() {
    var mapping = <String, dynamic>{};
    mapping['notetodo'] = notetodo;
    mapping['transcationdate'] = transcationdate;
    return mapping;
  }
}

class MonthlyDayOrder {
  String? date;
  List<TranscationModel>? income;
  List<TranscationModel>? expance;

  MonthlyDayOrder({
    required this.date,
    required this.income,
    required this.expance,
  });
}

class MonthOrder {
  String? monthdate;
  List<TranscationModel>? trancdata;
  MonthOrder({required this.monthdate, required this.trancdata});
}

class YearOrder {
  final String month;
  double income;
  double expance;
  double balance;
  YearOrder({
    required this.month,
    required this.income,
    required this.expance,
    required this.balance,
  });
}

class YearlyPrintModel {
  List<MonthOrder>? monthlyData;
  List<YearOrder>? yearlyData;
  YearlyPrintModel({required this.monthlyData, required this.yearlyData});
}

class CategoryFormat {
  String? name;
  int? iSincome;
  int? hide;
  int? custom;
  // CategoryFormat({
  //   required this.name,
  //   required this.iSincome,
  //   required this.hide,
  //   required this.custom,
  // });

  dataMap() {
    var mapping = <String, dynamic>{};
    mapping['name'] = name;
    mapping['isincome'] = iSincome;
    mapping['hide'] = hide;
    mapping['custom'] = custom;
    return mapping;
  }
}

class ProfileDataModel {
  int? uid;
  String? profileimage;
  String? profilename;
  String? profilepurpose;
  String? information;
  int? makedefault;
  int? deleteprofie;

  dataMap() {
    var mapping = <String, dynamic>{};
    mapping["uid"] = uid;
    mapping['profileimage'] = profileimage;
    mapping['profilename'] = profilename;
    mapping['profilepurpose'] = profilepurpose;
    mapping['information'] = information;
    mapping['makedefault'] = makedefault;
    mapping['deleteprofie'] = deleteprofie;
    return mapping;
  }
}

class AccountDataModel {
  int? aid;
  int? uid;
  String? identi;
  String? bank;
  int? balance;
  String? color;
  int? makedefault;
  int? deleteprofie;

  dataMap() {
    var mapping = <String, dynamic>{};
    mapping["aid"] = aid;
    mapping["uid"] = uid;
    mapping['identi'] = identi;
    mapping['bank'] = bank;
    mapping['balance'] = balance;
    mapping['color'] = color;
    mapping['makedefault'] = makedefault;
    mapping['deleteprofie'] = deleteprofie;
    return mapping;
  }
}

class ProfileAccount {
  ProfileDataModel? profileList;
  List<AccountDataModel>? accountlist;
  ProfileAccount({
    required this.profileList,
    required this.accountlist,
  });
}
