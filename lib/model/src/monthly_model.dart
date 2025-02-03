// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'entry_model.dart';

class MonthlyModel {
  String fromDate;
  String toDate;
  List<EntryModel> expense;
  String totalDebit;
  String totalCredit;
  String balance;
  MonthlyModel({
    required this.fromDate,
    required this.toDate,
    required this.expense,
    required this.totalDebit,
    required this.totalCredit,
    required this.balance,
  });

  MonthlyModel copyWith({
    String? fromDate,
    String? toDate,
    List<EntryModel>? expense,
    String? totalDebit,
    String? totalCredit,
    String? balance,
  }) {
    return MonthlyModel(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      expense: expense ?? this.expense,
      totalDebit: totalDebit ?? this.totalDebit,
      totalCredit: totalCredit ?? this.totalCredit,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromDate': fromDate,
      'toDate': toDate,
      'expense': expense.map((x) => x.toMap()).toList(),
      'totalDebit': totalDebit,
      'totalCredit': totalCredit,
      'balance': balance,
    };
  }

  factory MonthlyModel.fromMap(Map<String, dynamic> map) {
    return MonthlyModel(
      fromDate: map['fromDate'] as String,
      toDate: map['toDate'] as String,
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

  factory MonthlyModel.fromJson(String source) =>
      MonthlyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MonthlyModel(fromDate: $fromDate, toDate: $toDate, expense: $expense, totalDebit: $totalDebit, totalCredit: $totalCredit, balance: $balance)';
  }

  @override
  bool operator ==(covariant MonthlyModel other) {
    if (identical(this, other)) return true;

    return other.fromDate == fromDate &&
        other.toDate == toDate &&
        listEquals(other.expense, expense) &&
        other.totalDebit == totalDebit &&
        other.totalCredit == totalCredit &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return fromDate.hashCode ^
        toDate.hashCode ^
        expense.hashCode ^
        totalDebit.hashCode ^
        totalCredit.hashCode ^
        balance.hashCode;
  }
}
