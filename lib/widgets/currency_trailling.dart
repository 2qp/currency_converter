import 'package:circle_flags/circle_flags.dart';
import 'package:currency_converter/bloc/autocomplete/auto_complete_state.dart';
import 'package:flutter/material.dart';

class CurrencyTrailing extends StatelessWidget {
  const CurrencyTrailing(
      {super.key,
      required this.mode,
      required this.currency,
      required this.flag,
      required this.isConversionLoading});

  final AutoCompleteType mode;
  final String currency;
  final String flag;
  final bool isConversionLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: switch (mode) {
            AutoCompleteType.currency => Colors.black.withOpacity(0.5),
            AutoCompleteType.amount => null,
          }),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isConversionLoading) const CircularProgressIndicator.adaptive(),
          if (!isConversionLoading)
            CircleFlag(
              flag,
              size: 20,
            ),
          const SizedBox(
            width: 10,
          ),
          Text(
            currency,
          ),
          const SizedBox(
            width: 10,
          ),
          switch (mode) {
            //qp
            AutoCompleteType.currency => const Icon(Icons.arrow_drop_down),
            AutoCompleteType.amount => const Icon(Icons.arrow_drop_up),
          }
        ],
      ),
    );
  }
}
