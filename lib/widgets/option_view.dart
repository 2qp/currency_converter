import 'package:circle_flags/circle_flags.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:flutter/material.dart';

class OptionView extends StatelessWidget {
  const OptionView(
      {super.key,
      required this.options,
      required this.onSelected,
      required this.constraints});

  final Iterable<Currency> options;
  final void Function(Currency) onSelected;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: constraints.biggest.width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10), //
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return Card(
                child: ListTile(
                  dense: true,
                  leading: CircleFlag(
                    option.countryCode,
                    size: 20,
                  ),
                  title: Text(option.code),
                  onTap: () => onSelected(option),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
