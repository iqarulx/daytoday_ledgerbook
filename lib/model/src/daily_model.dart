// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:daytoday_ledgerbook/model/src/entry_model.dart';

class DailyModel {
  String date;
  List<EntryModel> expense;
  DailyModel({
    required this.date,
    required this.expense,
  });

  DailyModel copyWith({
    String? date,
    List<EntryModel>? expense,
  }) {
    return DailyModel(
      date: date ?? this.date,
      expense: expense ?? this.expense,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'expense': expense.map((x) => x.toMap()).toList(),
    };
  }

  factory DailyModel.fromMap(Map<String, dynamic> map) {
    return DailyModel(
      date: map['date'] as String,
      expense: List<EntryModel>.from(
        (map['expense'] as List<int>).map<EntryModel>(
          (x) => EntryModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyModel.fromJson(String source) =>
      DailyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DailyModel(date: $date, expense: $expense)';

  @override
  bool operator ==(covariant DailyModel other) {
    if (identical(this, other)) return true;

    return other.date == date && listEquals(other.expense, expense);
  }

  @override
  int get hashCode => date.hashCode ^ expense.hashCode;
}
