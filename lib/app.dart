import 'package:currency_converter/pages/currency_converter_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const CurrencyConverterPage(),
    );
  }
}
