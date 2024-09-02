import 'package:currency_converter/models/currency.dart';

class CurrencyState {
  final List<Currency> currencies;
  final bool isLoading;
  final String? errorMessage;

  const CurrencyState({
    this.currencies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CurrencyState copyWith({
    final List<Currency>? currencies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CurrencyState(
      currencies: currencies ?? this.currencies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
