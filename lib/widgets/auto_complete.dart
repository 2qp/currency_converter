import 'package:currency_converter/bloc/autocomplete/auto_complete_bloc.dart';
import 'package:currency_converter/bloc/autocomplete/auto_complete_state.dart';
import 'package:currency_converter/bloc/conversion/conversion_bloc.dart';
import 'package:currency_converter/bloc/conversion/conversion_state.dart';
import 'package:currency_converter/bloc/currency/currency_bloc.dart';
import 'package:currency_converter/bloc/currency/currency_state.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:currency_converter/utils/debouncer.dart';
import 'package:currency_converter/widgets/currency_trailling.dart';
import 'package:currency_converter/widgets/custom_text_form_field.dart';
import 'package:currency_converter/widgets/option_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAutoComplete extends StatefulWidget {
  const CustomAutoComplete({
    super.key,
    required this.autoId,
  });

  final String autoId;

  @override
  State<CustomAutoComplete> createState() => _CustomAutoCompleteState();
}

class _CustomAutoCompleteState extends State<CustomAutoComplete> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  late final String autoId;

  late final Debouncer _debouncer;

  @override
  void initState() {
    _controller = TextEditingController()..text = '0.00';
    _focusNode = FocusNode();

    autoId = widget.autoId;

    _debouncer = Debouncer(milliseconds: 1000);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CurrencyCubit, CurrencyState, List<Currency>>(
      selector: (state) => state.currencies,
      builder: (context, currencyState) {
        return BlocSelector<AutoCompleteCubit, AutoCompleteStates,
            AutoCompleteState>(
          selector: (state) => state.states[autoId]!,
          builder: (context, autoCompleteState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return RawAutocomplete<Currency>(
                  textEditingController: _controller,
                  focusNode: _focusNode,
                  fieldViewBuilder: ((context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return BlocSelector<ConversionCubit, ConversionState,
                        ConversionState>(
                      selector: (state) => state,
                      builder: (context, conversionState) {
                        final rate =
                            conversionState.rates[autoCompleteState.currency] ??
                                0.0;
                        final byRate =
                            (rate * conversionState.amount).toStringAsFixed(2);

                        // Update the text controller with the new rate
                        if (autoCompleteState.readOnly &&
                            autoCompleteState.type == AutoCompleteType.amount) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _controller.text = byRate;
                          });
                        }

                        return CustomTextFormField(
                          controller: _controller,
                          focusNode: _focusNode,
                          currency: autoCompleteState.currency,
                          readOnly: autoCompleteState.readOnly,
                          type: autoCompleteState.type,

                          //
                          onChanged: (value) {
                            if (conversionState.cached) {
                              context
                                  .read<ConversionCubit>()
                                  .conversionRateEvent(
                                      value, autoCompleteState.currency);
                              return;
                            }

                            _debouncer.run(() => context
                                .read<ConversionCubit>()
                                .conversionRateEvent(
                                    value, autoCompleteState.currency));
                          },
                          onTapCurrency: () {
                            context
                                .read<AutoCompleteCubit>()
                                .handleModeEvent(autoId);
                          },

                          onFieldSubmitted: onFieldSubmitted,
                          //
                          trailling: BlocSelector<ConversionCubit,
                              ConversionState, bool>(
                            selector: (state) => state.isLoading,
                            builder: (context, isConversionLoading) {
                              return CurrencyTrailing(
                                  isConversionLoading: isConversionLoading,
                                  mode: autoCompleteState.type,
                                  currency: autoCompleteState.currency,
                                  flag: autoCompleteState.flag);
                            },
                          ),
                        );
                      },
                    );
                  }),
                  optionsViewBuilder: (context, onSelected, options) {
                    if (autoCompleteState.type == AutoCompleteType.amount) {
                      return const SizedBox.shrink();
                    }

                    if (options.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return OptionView(
                      constraints: constraints,
                      onSelected: onSelected,
                      options: options,
                    );
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isNotEmpty) {
                      final options = currencyState;

                      final filteredOptions = options
                          .where((currency) => currency.code
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()))
                          .toList();
                      return filteredOptions.isEmpty
                          ? options
                          : filteredOptions;
                    }

                    return currencyState;
                  },
                  onSelected: (selection) {
                    // events
                    context
                        .read<AutoCompleteCubit>()
                        .handleCurrencyChangeEvent(autoId, selection);

                    context.read<AutoCompleteCubit>().handleModeEvent(autoId);

                    _controller.clear();
                    return;
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
