import 'package:currency_converter/bloc/currency/currency_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit(super.initialState, this._currencyService) {
    fetchCurrencies();
  }

  final CurrencyService _currencyService;

  void fetchCurrencies() async {
    emit(state.copyWith(isLoading: true));
    final currencies = await _currencyService.getCurrencyModels();

    emit(state.copyWith(currencies: currencies, isLoading: false));
  }
}
