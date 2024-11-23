// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class AccountEditModel {
  String? id;
  TextEditingController accountIdentification;
  TextEditingController bankDetails;
  TextEditingController openingBalance;
  String selectedColor;
  AccountEditModel({
    this.id,
    required this.accountIdentification,
    required this.bankDetails,
    required this.openingBalance,
    required this.selectedColor,
  });

  AccountEditModel copyWith({
    String? id,
    TextEditingController? accountIdentification,
    TextEditingController? bankDetails,
    TextEditingController? openingBalance,
    String? selectedColor,
  }) {
    return AccountEditModel(
      id: id ?? this.id,
      accountIdentification:
          accountIdentification ?? this.accountIdentification,
      bankDetails: bankDetails ?? this.bankDetails,
      openingBalance: openingBalance ?? this.openingBalance,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'accountIdentification': accountIdentification.text,
      'bankDetails': bankDetails.text,
      'openingBalance': openingBalance.text,
      'selectedColor': selectedColor,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(covariant AccountEditModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.accountIdentification == accountIdentification &&
        other.bankDetails == bankDetails &&
        other.openingBalance == openingBalance &&
        other.selectedColor == selectedColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        accountIdentification.hashCode ^
        bankDetails.hashCode ^
        openingBalance.hashCode ^
        selectedColor.hashCode;
  }

  @override
  String toString() {
    return 'AccountEditModel(id: $id, accountIdentification: $accountIdentification, bankDetails: $bankDetails, openingBalance: $openingBalance, selectedColor: $selectedColor)';
  }
}
