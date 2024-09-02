class ConversionState {
  final double amount;
  final Map<String, double> rates;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, Map<String, double>> cachedRates;
  final bool cached;

  const ConversionState(
      {this.amount = 0.0,
      this.rates = const {},
      this.isLoading = false,
      this.errorMessage,
      this.cachedRates = const {},
      this.cached = false});

  ConversionState copyWith(
      {double? amount,
      Map<String, double>? rates,
      bool? isLoading,
      String? errorMessage,
      Map<String, Map<String, double>>? cachedRates,
      bool? cached}) {
    return ConversionState(
        amount: amount ?? this.amount,
        rates: rates ?? this.rates,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        cachedRates: cachedRates ?? this.cachedRates,
        cached: cached ?? this.cached);
  }
}
