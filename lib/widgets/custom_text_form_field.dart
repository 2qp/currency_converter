import 'package:currency_converter/bloc/autocomplete/auto_complete_state.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.currency,
      required this.type,
      required this.onFieldSubmitted,
      required this.onChanged,
      required this.onTapCurrency,
      required this.trailling,
      required this.readOnly});

  final TextEditingController controller;
  final FocusNode focusNode;

  final String currency;
  final AutoCompleteType type;
  final bool readOnly;

  final void Function() onFieldSubmitted;
  final void Function(String value) onChanged;
  final void Function() onTapCurrency;

  final Widget trailling;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          onChanged("0");
          return;
        }

        if (type == AutoCompleteType.currency) {
          return;
        }

        final double? numericValue = double.tryParse(value);

        if (numericValue == null) {
          return;
        }

        onChanged(value);
      },

      readOnly: getReadOnly(),
      keyboardType: handleKeyboardType(),
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: (value) {
        if (type == AutoCompleteType.currency) {
          return;
        }

        onFieldSubmitted;
      },
      //

      decoration: InputDecoration(
        isDense: true,
        suffixIcon: SizedBox(
          width: 100,
          child: GestureDetector(
            onTap: () {
              onTapCurrency();
              handleOnChangeMode();
            },
            child: trailling,
          ),
        ),
        fillColor: Colors.white.withOpacity(0.1),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: getHintText(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }

  TextInputType handleKeyboardType() {
    return type == AutoCompleteType.amount
        ? TextInputType.number
        : TextInputType.name;
  }

  void handleOnChangeMode() {
    if (type == AutoCompleteType.currency) {
      return;
    }
    controller.clear();
    focusNode.requestFocus();
  }

  String getHintText() {
    if (type == AutoCompleteType.currency) {
      return 'search a currency';
    }
    return "";
  }

  bool getReadOnly() {
    if (!readOnly) {
      return false;
    }

    if (readOnly) {
      if (type == AutoCompleteType.currency) {
        return false;
      }
    }

    return true;
  }
}
