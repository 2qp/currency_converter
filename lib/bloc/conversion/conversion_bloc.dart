import 'package:currency_converter/bloc/conversion/conversion_service.dart';
import 'package:currency_converter/bloc/conversion/conversion_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionCubit extends Cubit<ConversionState> {
  ConversionCubit(this._conversionService) : super(const ConversionState());

  final ConversionService _conversionService;

  void conversionRateEvent(
    String amount,
    String currency,
  ) async {
    final fAmount = double.parse(amount);
    emit(state.copyWith(amount: fAmount, isLoading: true));

    // Check if the rates are cached
    if (state.cachedRates.containsKey(currency)) {
      // Use cached rates
      final cachedRates = state.cachedRates[currency]!;
      emit(state.copyWith(isLoading: false, rates: cachedRates, cached: true));
      return;
    }

    try {
      final rates = await _conversionService.getExchangeRates(currency);
      final updatedCachedRates =
          Map<String, Map<String, double>>.from(state.cachedRates)
            ..[currency] = rates;

      emit(state.copyWith(
          isLoading: false,
          rates: rates,
          cachedRates: updatedCachedRates,
          cached: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
