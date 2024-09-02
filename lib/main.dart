import 'package:currency_converter/app.dart';
import 'package:currency_converter/bloc/autocomplete/auto_complete_bloc.dart';
import 'package:currency_converter/bloc/autocomplete/auto_complete_state.dart';
import 'package:currency_converter/bloc/conversion/conversion_bloc.dart';
import 'package:currency_converter/bloc/conversion/conversion_service.dart';
import 'package:currency_converter/bloc/currency/currency_bloc.dart';
import 'package:currency_converter/bloc/currency/currency_repository.dart';
import 'package:currency_converter/bloc/currency/currency_service.dart';
import 'package:currency_converter/bloc/currency/currency_state.dart';
import 'package:currency_converter/db/db.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDatabase = await AppDatabase.create();

  const CurrencyRepository repository = CurrencyRepository();
  const CurrencyService currencyService = CurrencyService(repository);
  const ConversionService conversionService = ConversionService();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (BuildContext context) =>
            CurrencyCubit(const CurrencyState(), currencyService)),
    BlocProvider(
        create: (BuildContext context) => ConversionCubit(conversionService)),
    BlocProvider(
        create: (BuildContext context) =>
            AutoCompleteCubit(const AutoCompleteStates(), appDatabase))
  ], child: const App()));
}
