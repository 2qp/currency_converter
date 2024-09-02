import 'package:circle_flags/circle_flags.dart';
import 'package:currency_converter/utils/enum_util.dart';
import 'package:flutter/foundation.dart';

@immutable
class AutoCompleteState {
  final AutoCompleteType type;
  final String flag;
  final bool readOnly;
  final String currency;

  const AutoCompleteState({
    this.type = AutoCompleteType.amount,
    this.flag = Flag.US,
    this.readOnly = false,
    this.currency = 'USD',
  });

  AutoCompleteState copyWith({
    AutoCompleteType? type,
    String? flag,
    bool? readOnly,
    String? currency,
  }) {
    return AutoCompleteState(
      type: type ?? this.type,
      flag: flag ?? this.flag,
      readOnly: readOnly ?? this.readOnly,
      currency: currency ?? this.currency,
    );
  }

  factory AutoCompleteState.fromMap(Map<String, dynamic> map) {
    return AutoCompleteState(
      type: stringToType(map['type']),
      flag: map['flag'],
      readOnly: map['readOnly'],
      currency: map['currency'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'flag': flag,
      'readOnly': readOnly,
      'currency': currency,
    };
  }

  @override
  String toString() {
    return 'AutoCompleteState(type: $type, flag: $flag, readOnly: $readOnly, currency: $currency)';
  }
}

@immutable
class AutoCompleteStates {
  final Map<String, AutoCompleteState> states;

  const AutoCompleteStates(
      {this.states = const {'primary': AutoCompleteState()}});

  Map<String, dynamic> toMap() {
    return {
      'states': states.map((key, state) => MapEntry(key, state.toMap())),
    };
  }

  factory AutoCompleteStates.fromMap(Map<String, dynamic> map) {
    final statesMap = (map['states'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, AutoCompleteState.fromMap(value)),
    );
    return AutoCompleteStates(states: statesMap);
  }

  AutoCompleteStates copyWith({
    Map<String, AutoCompleteState>? states,
  }) {
    return AutoCompleteStates(
      states: states ?? this.states,
    );
  }
}

enum AutoCompleteType {
  currency,
  amount,
}
