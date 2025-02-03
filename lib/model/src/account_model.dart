// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

class AccountModel {
  String accountId;
  String accountIdentification;
  String bankDetails;
  String openingBalance;
  String accountColor;

  AccountModel({
    required this.accountId,
    required this.accountIdentification,
    required this.bankDetails,
    required this.openingBalance,
    required this.accountColor,
  });

  AccountModel copyWith({
    String? accountId,
    String? accountIdentification,
    String? bankDetails,
    String? openingBalance,
    String? accountColor,
  }) {
    return AccountModel(
      accountId: accountId ?? this.accountId,
      accountIdentification:
          accountIdentification ?? this.accountIdentification,
      bankDetails: bankDetails ?? this.bankDetails,
      openingBalance: openingBalance ?? this.openingBalance,
      accountColor: accountColor ?? this.accountColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountId': accountId,
      'accountIdentification': accountIdentification,
      'bankDetails': bankDetails,
      'openingBalance': openingBalance,
      'accountColor': accountColor,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      accountId: map['accountId'] as String,
      accountIdentification: map['accountIdentification'] as String,
      bankDetails: map['bankDetails'] as String,
      openingBalance: map['openingBalance'] as String,
      accountColor: map['accountColor'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountModel.fromJson(String source) =>
      AccountModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccountModel(accountId: $accountId, accountIdentification: $accountIdentification, bankDetails: $bankDetails, openingBalance: $openingBalance, accountColor: $accountColor)';
  }

  @override
  bool operator ==(covariant AccountModel other) {
    if (identical(this, other)) return true;

    return other.accountId == accountId &&
        other.accountIdentification == accountIdentification &&
        other.bankDetails == bankDetails &&
        other.openingBalance == openingBalance &&
        other.accountColor == accountColor;
  }

  @override
  int get hashCode {
    return accountId.hashCode ^
        accountIdentification.hashCode ^
        bankDetails.hashCode ^
        openingBalance.hashCode ^
        accountColor.hashCode;
  }
}
