import 'package:currency_converter/entities/currency_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CurrencyBase {
  final String code;

  const CurrencyBase({required this.code});

  void getFlag();
}

class Currency extends CurrencyBase {
  const Currency(
      {required super.code,
      required this.name,
      required this.flag,
      required this.countryCode});

  final String name;
  final String countryCode;
  final String? flag; // base64

  factory Currency.fromEntity(CurrencyEntity entity) {
    return Currency(
        code: entity.code,
        name: entity.name,
        flag: entity.flag,
        countryCode: entity.countryCode);
  }

  @override
  void getFlag() {}
}
