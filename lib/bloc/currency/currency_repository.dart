import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:currency_converter/entities/currency_entity.dart';
import 'package:flutter/services.dart' show rootBundle;

class CurrencyRepository {
  const CurrencyRepository();

  Future<List<CurrencyEntity>> loadCurrencies() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/json/currencies.json');
      final List<dynamic> jsonResponse = await json.decode(jsonString);

      return jsonResponse.map((json) => CurrencyEntity.fromJson(json)).toList();
    } catch (e) {
      print('Error loading currencies: $e');
      return [];
    }
  }

  Future<CurrencyEntity?> getCurrencyByCode(String code) async {
    final List<CurrencyEntity> currencies = await loadCurrencies();

    final lCode = code.toLowerCase();

    return currencies.firstWhereOrNull((element) => element.code == lCode);
  }
}
