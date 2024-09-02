import 'package:currency_converter/bloc/autocomplete/auto_complete_state.dart';
import 'package:currency_converter/db/db.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AutoCompleteCubit extends Cubit<AutoCompleteStates> {
  AutoCompleteCubit(super.initialState, this._db) {
    prefetchStoredStates();
  }

  final AppDatabase _db;

  void add() {
    const Uuid uuid = Uuid();
    final id = uuid.v4();

    final updatedStates = Map<String, AutoCompleteState>.from(state.states);

    updatedStates[id] = const AutoCompleteState(
        type: AutoCompleteType.amount,
        flag: "US",
        readOnly: true,
        currency: "USD");

    emit(state.copyWith(states: updatedStates));

    // DB
    _db.saveAutoCompleteStates(AutoCompleteStates(states: updatedStates));
  }

  void remove(String id) async {
    final updatedStates = Map<String, AutoCompleteState>.from(state.states);
    updatedStates.remove(id);

    emit(state.copyWith(states: updatedStates));

    // DB
    _db.removeState(id);
  }

  void handleModeEvent(String id) async {
    final currentState = state.states[id] ?? const AutoCompleteState();

    final mode = getType(currentState.type);

    final updatedState = currentState.copyWith(type: mode);

    final updatedStates = Map<String, AutoCompleteState>.from(state.states);
    updatedStates[id] = updatedState;

    emit(state.copyWith(states: updatedStates));
  }

  void handleCurrencyChangeEvent(String id, Currency currency) async {
    final currentState = state.states[id] ?? const AutoCompleteState();
    final updatedState = currentState.copyWith(
        currency: currency.code, flag: currency.countryCode);

    final updatedStates = Map<String, AutoCompleteState>.from(state.states);
    updatedStates[id] = updatedState;

    emit(state.copyWith(states: updatedStates));
  }

  void prefetchStoredStates() async {
    final states = await _db.getAutoCompleteStates();

    if (states == null) {
      return;
    }

    if (state.states.isEmpty) {
      return;
    }

    emit(state.copyWith(states: states.states));
  }

// HELPER
  AutoCompleteType getType(AutoCompleteType type) {
    switch (type) {
      case AutoCompleteType.currency:
        return AutoCompleteType.amount;

      case AutoCompleteType.amount:
        return AutoCompleteType.currency;
    }
  }
}
