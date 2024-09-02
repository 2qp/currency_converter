import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ConversionService {
  const ConversionService();

  final String _apiUrl = 'https://api.exchangerate-api.com/v4/latest/';

  Future<Map<String, double>> getExchangeRates(String baseCurrency) async {
    if (kDebugMode) {
      print('api called');
    }
    final response = await http.get(Uri.parse('$_apiUrl$baseCurrency'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;

      final Map<String, double> result = {};
      for (var entry in rates.entries) {
        final currency = entry.key;
        final rate = entry.value;
        result[currency] = rate.toDouble();
      }

      return result;
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
