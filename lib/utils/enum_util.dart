// Convert enum to string
import 'package:currency_converter/bloc/autocomplete/auto_complete_state.dart';

AutoCompleteType stringToType(String type) {
  return AutoCompleteType.values.firstWhere(
    (e) => e.toString().split('.').last == type,
    orElse: () => AutoCompleteType.amount,
  );
}
