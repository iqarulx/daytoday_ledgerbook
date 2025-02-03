// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

class CurrencyModel {
  String code;
  String symbol;
  String region;
  CurrencyModel({
    required this.code,
    required this.symbol,
    required this.region,
  });

  CurrencyModel copyWith({
    String? code,
    String? symbol,
    String? region,
  }) {
    return CurrencyModel(
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      region: region ?? this.region,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'symbol': symbol,
      'region': region,
    };
  }

  factory CurrencyModel.fromMap(Map<String, dynamic> map) {
    return CurrencyModel(
      code: map['code'] as String,
      symbol: map['symbol'] as String,
      region: map['region'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrencyModel.fromJson(String source) =>
      CurrencyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CurrencyModel(code: $code, symbol: $symbol, region: $region)';

  @override
  bool operator ==(covariant CurrencyModel other) {
    if (identical(this, other)) return true;

    return other.code == code &&
        other.symbol == symbol &&
        other.region == region;
  }

  @override
  int get hashCode => code.hashCode ^ symbol.hashCode ^ region.hashCode;
}
