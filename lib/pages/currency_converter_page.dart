import 'package:currency_converter/bloc/autocomplete/auto_complete_bloc.dart';
import 'package:currency_converter/bloc/autocomplete/auto_complete_state.dart';
import 'package:currency_converter/widgets/auto_complete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomAutoComplete(autoId: 'primary'),

            const SizedBox(
              height: 25,
            ),

            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), //
                ),
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 325),
                clipBehavior: Clip.antiAlias,
                child: const Converters(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.lightGreenAccent,
                    backgroundColor: Colors.green[800]),
                onPressed: () {
                  context.read<AutoCompleteCubit>().add();
                },
                child: const Text('+ ADD CONVERTER'))

            //
          ],
        ),
      ),
    );
  }
}

class Converters extends StatelessWidget {
  const Converters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AutoCompleteCubit, AutoCompleteStates,
        Map<String, AutoCompleteState>>(
      selector: (state) => state.states,
      builder: (context, autoCompleteMap) {
        final autoCompleteList = autoCompleteMap.entries.toList();

        return ListView.separated(
          shrinkWrap: true,
          itemCount: autoCompleteList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final entry = autoCompleteList[index];
            final id = entry.key;

            if (id == 'primary') {
              return const SizedBox.shrink();
            }

            return Dismissible(
                onDismissed: (direction) =>
                    context.read<AutoCompleteCubit>().remove(id),
                key: Key(id),
                child: CustomAutoComplete(autoId: id));
          },
        );
      },
    );
  }
}
