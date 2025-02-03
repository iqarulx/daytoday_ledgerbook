// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '/model/model.dart';

class DailyModel {
  String date;
  List<EntryModel> expense;
  String totalDebit;
  String totalCredit;
  String balance;
  DailyModel({
    required this.date,
    required this.expense,
    required this.totalDebit,
    required this.totalCredit,
    required this.balance,
  });

  DailyModel copyWith({
    String? date,
    List<EntryModel>? expense,
    String? totalDebit,
    String? totalCredit,
    String? balance,
  }) {
    return DailyModel(
      date: date ?? this.date,
      expense: expense ?? this.expense,
      totalDebit: totalDebit ?? this.totalDebit,
      totalCredit: totalCredit ?? this.totalCredit,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'expense': expense.map((x) => x.toMap()).toList(),
      'totalDebit': totalDebit,
      'totalCredit': totalCredit,
      'balance': balance,
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
      totalDebit: map['totalDebit'] as String,
      totalCredit: map['totalCredit'] as String,
      balance: map['balance'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyModel.fromJson(String source) =>
      DailyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DailyModel(date: $date, expense: $expense, totalDebit: $totalDebit, totalCredit: $totalCredit, balance: $balance)';
  }

  @override
  bool operator ==(covariant DailyModel other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        listEquals(other.expense, expense) &&
        other.totalDebit == totalDebit &&
        other.totalCredit == totalCredit &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        expense.hashCode ^
        totalDebit.hashCode ^
        totalCredit.hashCode ^
        balance.hashCode;
  }
}
