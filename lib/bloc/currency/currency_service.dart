import 'package:currency_converter/bloc/currency/currency_repository.dart';
import 'package:currency_converter/models/currency.dart';

class CurrencyService {
  const CurrencyService(this._repository);

  final CurrencyRepository _repository;

  Future<List<Currency>> getCurrencyModels() async {
    final currencyEntities = await _repository.loadCurrencies();
    return currencyEntities
        .map((currency) => Currency.fromEntity(currency))
        .toList();
  }

  Future<Currency?> getCurrencyModelByCode(String code) async {
    final currencyEntity = await _repository.getCurrencyByCode(code);
    if (currencyEntity != null) {
      return Currency.fromEntity(currencyEntity);
    }
    return null;
  }
}
